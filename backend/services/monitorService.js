const axios = require('axios');
const { exec } = require('child_process');
const { promisify } = require('util');
const { Website, MonitorLog, User, Alert } = require('../models');
const { Op } = require('sequelize');
const { sendEmailAlert, sendTelegramAlert, handleDowntime, handleRecovery } = require('./alertService');

const execPromise = promisify(exec);

class MonitorService {
  constructor() {
    this.monitoringIntervals = new Map();
    this.previousStatuses = new Map(); // Track previous status for recovery detection
  }

  // Broadcast status update to connected clients
  broadcastStatusUpdate(websiteId, statusData) {
    if (!global.sseConnections) return;

    // Find the website to get the owner
    Website.findByPk(websiteId).then(website => {
      if (!website) return;

      // Send to website owner
      const ownerConnection = global.sseConnections.get(website.userId);
      if (ownerConnection && ownerConnection.sendStatusUpdate) {
        ownerConnection.sendStatusUpdate(websiteId, statusData);
      }

      // Send to all admin users
      if (global.sseConnections) {
        global.sseConnections.forEach((connection, userId) => {
          if (connection.user && connection.user.role === 'admin' && userId !== website.userId) {
            if (connection.sendStatusUpdate) {
              connection.sendStatusUpdate(websiteId, statusData);
            }
          }
        });
      }
    }).catch(error => {
      console.error('Error broadcasting status update:', error);
    });
  }

  // Get previous status for recovery detection
  getPreviousStatus(websiteId) {
    return this.previousStatuses.get(websiteId) || 'unknown';
  }

  // Set previous status
  setPreviousStatus(websiteId, status) {
    this.previousStatuses.set(websiteId, status);
  }

  // Handle recovery alerts
  async handleRecovery(website, responseTime) {
    try {
      return await handleRecovery(website, responseTime);
    } catch (error) {
      console.error('Error handling recovery:', error);
      return [{ success: false, error: error.message }];
    }
  }

  async checkWebsite(website) {
    const startTime = Date.now();
    const previousStatus = this.getPreviousStatus(website.id);
    
    try {
      // Ensure we have fresh website data with user preferences
      const freshWebsite = await Website.findByPk(website.id, {
        include: [{
          model: User,
          attributes: ['id', 'email', 'telegramChatId', 'alertPreferences']
        }]
      });
      
      if (!freshWebsite) {
        throw new Error('Website not found');
      }

      let finalStatusCode = null;
      let responseTime = null;
      let status = 'down';
      let message = '';
      let usedMethod = '';

      // Extract hostname from URL for ping
      let hostname = '';
      try {
        const url = new URL(freshWebsite.url);
        hostname = url.hostname;
      } catch (error) {
        // If URL parsing fails, use the entire URL as hostname for CUSTOM_CURL
        hostname = freshWebsite.url;
      }

      // Check website based on method
      if (freshWebsite.httpMethod === 'PING') {
        console.log(`Checking website ${freshWebsite.url} using PING method`);
        usedMethod = 'PING';
        
        const pingSuccess = await this.pingHostSimple(hostname);
        responseTime = Date.now() - startTime;
        
        if (pingSuccess) {
          status = 'up';
          finalStatusCode = 200;
          message = 'Website is up (PING successful)';
        } else {
          status = 'down';
          message = 'PING failed - no response from server';
        }
      } 
      else if (freshWebsite.httpMethod.startsWith('CURL_')) {
        // CURL methods
        const curlMethod = freshWebsite.httpMethod.replace('CURL_', '');
        console.log(`Checking website ${freshWebsite.url} using CURL ${curlMethod} method`);
        usedMethod = `CURL ${curlMethod}`;
        
        const result = await this.curlCheck(freshWebsite, curlMethod);
        responseTime = result.responseTime;
        finalStatusCode = result.statusCode;
        status = result.status;
        message = result.message;
      }
      else if (freshWebsite.httpMethod === 'CUSTOM_CURL') {
        // Custom CURL command
        console.log(`Checking website using CUSTOM CURL method`);
        usedMethod = 'CUSTOM CURL';
        
        const result = await this.customCurlCheck(freshWebsite);
        responseTime = result.responseTime;
        finalStatusCode = result.statusCode;
        status = result.status;
        message = result.message;
      }
      else {
        // Standard HTTP methods (GET, POST, HEAD, OPTIONS)
        console.log(`Checking website ${freshWebsite.url} using HTTP ${freshWebsite.httpMethod} method`);
        usedMethod = `HTTP ${freshWebsite.httpMethod}`;
        
        // Prepare headers - convert array of objects to object
        const customHeaders = (freshWebsite.headers || []).reduce((acc, header) => {
          if (header.key && header.value) {
            acc[header.key] = header.value;
          }
          return acc;
        }, {});

        try {
          const response = await axios({
            method: freshWebsite.httpMethod.toLowerCase(),
            url: freshWebsite.url,
            timeout: 10000,
            maxRedirects: 5,
            validateStatus: () => true,
            headers: {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
              'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
              ...customHeaders
            }
          });

          responseTime = Date.now() - startTime;
          finalStatusCode = response.status;
          status = freshWebsite.expectedStatusCodes.includes(finalStatusCode) ? 'up' : 'down';
          message = status === 'up' 
            ? `Website is up (HTTP ${finalStatusCode})` 
            : `Unexpected HTTP status: ${finalStatusCode}`;

        } catch (httpError) {
          // If HTTP request fails, try PING as fallback
          try {
            console.log(`HTTP ${freshWebsite.httpMethod} failed, trying PING fallback for ${freshWebsite.url}`);
            const pingSuccess = await this.pingHostSimple(hostname);
            usedMethod = 'PING (fallback)';
            responseTime = Date.now() - startTime;
            
            if (pingSuccess) {
              status = 'up';
              finalStatusCode = 200;
              message = 'Website is up (PING fallback successful)';
            } else {
              status = 'down';
              message = `HTTP failed and PING fallback also failed: ${this.getErrorMessage(httpError)}`;
            }
          } catch (pingError) {
            status = 'down';
            message = `All check methods failed: ${this.getErrorMessage(httpError)}`;
          }
        }
      }

      // Log the check
      await MonitorLog.create({
        websiteId: freshWebsite.id,
        status,
        responseTime,
        statusCode: finalStatusCode,
        message: message + ` [${usedMethod}]`
      });

      console.log(`Website check completed: ${status} - ${message}`);

      // Broadcast status update to connected clients
      this.broadcastStatusUpdate(freshWebsite.id, {
        status,
        responseTime,
        statusCode: finalStatusCode,
        message: message + ` [${usedMethod}]`,
        lastChecked: new Date().toISOString()
      });

      // Check for recovery (was down, now up)
      if (previousStatus === 'down' && status === 'up') {
        console.log(`Website ${freshWebsite.url} recovered from downtime, sending recovery alert`);
        await this.handleRecovery(freshWebsite, responseTime);
      }

      // If status is down, send alerts
      if (status === 'down') {
        await handleDowntime(freshWebsite, finalStatusCode, responseTime, message);
      }

      // Update previous status
      this.setPreviousStatus(freshWebsite.id, status);

      return { status, responseTime, statusCode: finalStatusCode, message, method: usedMethod };

    } catch (error) {
      const responseTime = Date.now() - startTime;
      const errorMessage = this.getErrorMessage(error);
      
      // Log the error
      await MonitorLog.create({
        websiteId: website.id,
        status: 'down',
        responseTime,
        statusCode: null,
        message: errorMessage
      });

      // Broadcast error status
      this.broadcastStatusUpdate(website.id, {
        status: 'down',
        responseTime,
        statusCode: null,
        message: errorMessage,
        lastChecked: new Date().toISOString()
      });

      // Update previous status
      this.setPreviousStatus(website.id, 'down');

      // Send alerts for errors - use fresh website data if available
      try {
        const freshWebsite = await Website.findByPk(website.id, {
          include: [{
            model: User,
            attributes: ['id', 'email', 'telegramChatId', 'alertPreferences']
          }]
        });
        
        if (freshWebsite) {
          await handleDowntime(freshWebsite, null, responseTime, errorMessage);
        } else {
          await handleDowntime(website, null, responseTime, errorMessage);
        }
      } catch (alertError) {
        console.error('Error sending alert:', alertError);
      }

      return { status: 'down', responseTime, error: errorMessage };
    }
  }

  // IMPROVED Custom CURL check implementation
  async customCurlCheck(website) {
    const startTime = Date.now();
    
    try {
      if (!website.customCurlCommand || !website.customCurlCommand.trim()) {
        return {
          status: 'down',
          statusCode: null,
          responseTime: Date.now() - startTime,
          message: 'Custom CURL command is empty'
        };
      }

      // Get the command and ensure it starts with curl
      let command = website.customCurlCommand.trim();
      
      if (!command.toLowerCase().startsWith('curl')) {
        throw new Error('Command must start with "curl"');
      }

      // SECURITY: Smarter security check that allows CURL command syntax
      const dangerousPatterns = ['&', '|', '`', '$', '>', '<', '&&', '||', '$(', '`('];

      // Check for dangerous patterns that could lead to command injection
      for (const pattern of dangerousPatterns) {
        if (command.includes(pattern)) {
          throw new Error(`Command contains potentially dangerous pattern: ${pattern}`);
        }
      }

      // Allow semicolons but prevent command chaining
      let inQuotes = false;
      let quoteChar = null;
      let commandCount = 0;
      
      for (let i = 0; i < command.length; i++) {
        const char = command[i];
        
        // Track when we're inside quotes
        if ((char === '"' || char === "'") && (i === 0 || command[i-1] !== '\\')) {
          if (!inQuotes) {
            inQuotes = true;
            quoteChar = char;
          } else if (char === quoteChar) {
            inQuotes = false;
            quoteChar = null;
          }
        }
        
        // Count commands only when not inside quotes
        if (char === ';' && !inQuotes) {
          const beforeSemicolon = command.substring(0, i).trim();
          const afterSemicolon = command.substring(i + 1).trim();
          
          // Only count as separate command if there's content before and after
          if (beforeSemicolon.length > 0 && afterSemicolon.length > 0) {
            commandCount++;
          }
        }
      }
      
      if (commandCount > 0) {
        throw new Error('Multiple commands not allowed. Please use a single CURL command.');
      }

      // IMPORTANT: Use the ACTUAL custom CURL command provided by the user
      // Add timeout to prevent hanging requests
      let finalCommand = command;
      
      // Ensure we follow redirects (important for your case)
      if (!command.includes('-L') && !command.includes('--location')) {
        finalCommand += ' -L'; // Follow redirects
      }

      // Ensure we have a timeout set (add if not present)
      if (!command.includes('--max-time') && !command.includes('-m')) {
        finalCommand += ' --max-time 30';
      }

      // Ensure we're getting the status code (add if not present)
      if (!command.includes('-w') && !command.includes('--write-out')) {
        finalCommand += ' -w "%{http_code}"';
      }

      // Ensure silent mode (add if not present)
      if (!command.includes('-s') && !command.includes('--silent')) {
        finalCommand += ' -s';
      }

      // Ensure output is discarded (add if not present)
      if (!command.includes('-o') && !command.includes('--output')) {
        finalCommand += ' -o /dev/null';
      }

      console.log(`Executing Custom CURL command: ${finalCommand}`);
      
      const { stdout, stderr } = await execPromise(finalCommand);
      const responseTime = Date.now() - startTime;
      
      // Parse the status code from output
      let statusCode = null;
      
      // Try to extract status code from stdout (could be just the code or full output)
      if (stdout.trim()) {
        // If stdout is just numbers, it's likely the status code
        const codeMatch = stdout.trim().match(/^\d+$/);
        if (codeMatch) {
          statusCode = parseInt(codeMatch[0]);
        } else {
          // Look for HTTP status code pattern in the output
          const httpCodeMatch = stdout.match(/\b(\d{3})\b/);
          if (httpCodeMatch) {
            statusCode = parseInt(httpCodeMatch[1]);
          }
        }
      }
      
      // If we couldn't find status code in stdout, check stderr or use fallback
      if (!statusCode && stderr) {
        const errorCodeMatch = stderr.match(/\b(\d{3})\b/);
        if (errorCodeMatch) {
          statusCode = parseInt(errorCodeMatch[1]);
        }
      }
      
      // Determine status based on expected status codes
      let status = 'down';
      let message = '';
      
      if (statusCode !== null) {
        status = website.expectedStatusCodes.includes(statusCode) ? 'up' : 'down';
        message = status === 'up' 
          ? `Custom CURL successful (Status ${statusCode})` 
          : `Unexpected status code: ${statusCode}`;
      } else {
        // If no status code found, check if command executed successfully
        message = `Command executed but no status code detected. Output: ${stdout || stderr || 'No output'}`;
        
        // If there's no stderr and we got some output, consider it a success
        if (!stderr && stdout) {
          status = 'up';
          message = `Custom CURL executed successfully (No status code returned)`;
        }
      }
      
      return {
        status,
        statusCode,
        responseTime,
        message
      };
      
    } catch (error) {
      const responseTime = Date.now() - startTime;
      console.error('Custom CURL error:', error);
      
      return {
        status: 'down',
        statusCode: null,
        responseTime,
        message: `Custom CURL failed: ${error.message || 'Command execution error'}`
      };
    }
  }

  // CURL check implementation (for CURL_GET and CURL_POST)
  async curlCheck(website, method) {
    const startTime = Date.now();
    
    try {
      // Build curl command with proper quoting
      let curlCommand = `curl -s -o /dev/null -w "%{http_code}" `;
      
      // Add method
      if (method === 'POST') {
        curlCommand += `-X POST `;
      } else {
        curlCommand += `-X GET `;
      }
      
      // Add timeout
      curlCommand += `--max-time 10 `;
      
      // Add headers
      if (website.headers && website.headers.length > 0) {
        website.headers.forEach(header => {
          if (header.key && header.value) {
            curlCommand += `-H "${header.key}: ${header.value}" `;
          }
        });
      }
      
      // Add URL with proper quoting
      curlCommand += `"${website.url}"`;
      
      console.log(`Executing CURL command: ${curlCommand}`);
      
      const { stdout } = await execPromise(curlCommand);
      const responseTime = Date.now() - startTime;
      
      // Parse status code from curl output
      const statusCode = parseInt(stdout.trim());
      
      if (isNaN(statusCode)) {
        throw new Error(`Invalid status code from curl: ${stdout}`);
      }
      
      const status = website.expectedStatusCodes.includes(statusCode) ? 'up' : 'down';
      const message = status === 'up' 
        ? `Website is up (CURL ${method} - Status ${statusCode})` 
        : `Unexpected status code: ${statusCode}`;
      
      return {
        status,
        statusCode,
        responseTime,
        message
      };
      
    } catch (error) {
      const responseTime = Date.now() - startTime;
      return {
        status: 'down',
        statusCode: null,
        responseTime,
        message: `CURL ${method} failed: ${error.message || 'Unknown error'}`
      };
    }
  }

  // SIMPLIFIED Ping function - just check if host is reachable
  async pingHostSimple(hostname) {
    const isWindows = process.platform === 'win32';
    const command = isWindows 
      ? `ping -n 1 -w 3000 ${hostname}` // 1 attempt, 3 second timeout on Windows
      : `ping -c 1 -W 3 ${hostname}`;   // 1 attempt, 3 second timeout on Linux/Mac

    try {
      const { stdout } = await execPromise(command);
      
      // If we get any output, the ping was successful
      const hasOutput = stdout && stdout.length > 0;
      const hasSuccessfulResponse = stdout && (
        stdout.includes('Reply from') || // Windows
        stdout.includes('bytes from') || // Linux/Mac
        stdout.includes('1 packets transmitted') // Linux/Mac success
      );
      
      return hasOutput || hasSuccessfulResponse;
    } catch (error) {
      // If ping command fails, the host is down
      return false;
    }
  }

  getErrorMessage(error) {
    if (error.code === 'ECONNABORTED') {
      return 'Request timeout';
    } else if (error.code === 'ENOTFOUND') {
      return 'DNS lookup failed';
    } else if (error.code === 'ECONNREFUSED') {
      return 'Connection refused';
    } else if (error.code === 'CERT_HAS_EXPIRED') {
      return 'SSL certificate expired';
    } else if (error.code === 'UNABLE_TO_VERIFY_LEAF_SIGNATURE') {
      return 'SSL certificate verification failed';
    } else {
      return error.message || 'Unknown error';
    }
  }

  startMonitoring(website) {
    this.stopMonitoring(website.id);
    
    if (!website.isActive) {
      console.log(`Skipping monitoring for inactive website: ${website.url}`);
      return;
    }

    const intervalMs = website.interval * 60 * 1000;
    
    console.log(`Starting monitoring for: ${website.url} using ${website.httpMethod} method`);
    
    // Initial check
    this.checkWebsite(website);
    
    const intervalId = setInterval(() => {
      this.checkWebsite(website);
    }, intervalMs);

    this.monitoringIntervals.set(website.id, intervalId);
  }

  stopMonitoring(websiteId) {
    if (this.monitoringIntervals.has(websiteId)) {
      clearInterval(this.monitoringIntervals.get(websiteId));
      this.monitoringIntervals.delete(websiteId);
      console.log(`Stopped monitoring for website ID: ${websiteId}`);
    }
  }

  async initializeMonitoring() {
    try {
      const websites = await Website.findAll({ 
        where: { isActive: true },
        include: [{
          model: User,
          attributes: ['id', 'email', 'telegramChatId', 'alertPreferences']
        }]
      });
      
      // Initialize previous statuses
      for (const website of websites) {
        this.previousStatuses.set(website.id, 'unknown');
      }
      
      for (const website of websites) {
        this.startMonitoring(website);
      }
      
      console.log(`Monitoring initialized for ${websites.length} websites`);
      
    } catch (error) {
      console.log('Monitoring initialization failed:', error.message);
    }
  }

  // Get monitoring status for a specific website
  async getWebsiteStatus(websiteId) {
    try {
      const latestLog = await MonitorLog.findOne({
        where: { websiteId },
        order: [['createdAt', 'DESC']]
      });
      
      return latestLog || {
        status: 'unknown',
        responseTime: null,
        statusCode: null,
        message: 'Not checked yet'
      };
    } catch (error) {
      console.error('Error getting website status:', error);
      return {
        status: 'error',
        responseTime: null,
        statusCode: null,
        message: 'Error retrieving status'
      };
    }
  }

  // Get monitoring statistics for all websites
  async getOverallStats() {
    try {
      const websites = await Website.count();
      const totalChecks = await MonitorLog.count();
      const upChecks = await MonitorLog.count({ where: { status: 'up' } });
      const uptimePercentage = totalChecks > 0 ? (upChecks / totalChecks) * 100 : 0;
      
      const recentLogs = await MonitorLog.findAll({
        where: {
          createdAt: {
            [Op.gte]: new Date(Date.now() - 24 * 60 * 60 * 1000) // Last 24 hours
          }
        }
      });
      
      const avgResponseTime = recentLogs.length > 0 
        ? recentLogs.reduce((sum, log) => sum + (log.responseTime || 0), 0) / recentLogs.length 
        : 0;
      
      return {
        totalWebsites: websites,
        totalChecks,
        uptimePercentage: parseFloat(uptimePercentage.toFixed(2)),
        avgResponseTime: parseFloat(avgResponseTime.toFixed(2)),
        upChecks,
        downChecks: totalChecks - upChecks
      };
    } catch (error) {
      console.error('Error getting overall stats:', error);
      return {
        totalWebsites: 0,
        totalChecks: 0,
        uptimePercentage: 0,
        avgResponseTime: 0,
        upChecks: 0,
        downChecks: 0
      };
    }
  }
}

module.exports = new MonitorService();