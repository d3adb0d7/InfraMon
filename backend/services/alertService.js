const nodemailer = require('nodemailer');
const TelegramBot = require('node-telegram-bot-api');
const { User, Alert } = require('../models');
const { Op } = require('sequelize');

// Email configuration
const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  secure: process.env.SMTP_SECURE === 'true',
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS
  }
});

// Telegram bot configuration
let telegramBot;
if (process.env.TELEGRAM_BOT_TOKEN) {
  telegramBot = new TelegramBot(process.env.TELEGRAM_BOT_TOKEN, { polling: true });
}

// Function to check if we're in quiet hours
function isInQuietHours(quietHours, now = new Date()) {
  if (!quietHours || !quietHours.enabled || !quietHours.start || !quietHours.end) {
    return false;
  }

  try {
    const [startHour, startMinute] = quietHours.start.split(':').map(Number);
    const [endHour, endMinute] = quietHours.end.split(':').map(Number);

    const startTime = new Date(now);
    startTime.setHours(startHour, startMinute, 0, 0);

    const endTime = new Date(now);
    endTime.setHours(endHour, endMinute, 0, 0);

    // Handle overnight quiet hours
    if (endTime <= startTime) {
      endTime.setDate(endTime.getDate() + 1);
    }

    return now >= startTime && now < endTime;
  } catch (error) {
    console.error('Error checking quiet hours:', error);
    return false;
  }
}

// Function to escape Markdown characters for Telegram
function escapeMarkdown(text) {
  if (!text) return '';
  
  return text
    .replace(/\_/g, '\\_')
    .replace(/\*/g, '\\*')
    .replace(/\[/g, '\\[')
    .replace(/\]/g, '\\]')
    .replace(/\(/g, '\\(')
    .replace(/\)/g, '\\)')
    .replace(/\~/g, '\\~')
    .replace(/\`/g, '\\`')
    .replace(/\>/g, '\\>')
    .replace(/\#/g, '\\#')
    .replace(/\+/g, '\\+')
    .replace(/\-/g, '\\-')
    .replace(/\=/g, '\\=')
    .replace(/\|/g, '\\|')
    .replace(/\{/g, '\\{')
    .replace(/\}/g, '\\}')
    .replace(/\./g, '\\.')
    .replace(/\!/g, '\\!');
}

// Function to create alert in database
async function createAlertRecord(websiteId, userId, type, message) {
  try {
    const alert = await Alert.create({
      websiteId,
      userId,
      type,
      message: message.substring(0, 1000), // Ensure message doesn't exceed column limit
      sentAt: new Date()
    });
    console.log(`✅ Alert record created in database: ${type} alert for website ${websiteId}`);
    return alert;
  } catch (error) {
    console.error('❌ Failed to create alert record in database:', error);
    throw error;
  }
}

// Beautiful message templates
const messageTemplates = {
  downtime: {
    email: {
      subject: (website) => `🔴 CRITICAL: ${website.name || website.url} is DOWN - InfraMon Alert`,
      html: (website, statusCode, responseTime, errorMessage, method) => `
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #ff4444, #cc0000); color: white; padding: 20px; border-radius: 10px 10px 0 0; text-align: center; }
        .content { background: #f8f9fa; padding: 20px; border-radius: 0 0 10px 10px; }
        .alert-badge { background: #dc3545; color: white; padding: 5px 10px; border-radius: 15px; font-size: 12px; font-weight: bold; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin: 15px 0; }
        .info-item { background: white; padding: 10px; border-radius: 5px; border-left: 4px solid #dc3545; }
        .footer { text-align: center; margin-top: 20px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; font-size: 12px; }
        .response-time { font-size: 24px; font-weight: bold; color: #dc3545; }
        .timestamp { color: #666; font-size: 12px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🚨 Website Down Alert</h1>
        <p>Your monitored website is currently unavailable</p>
    </div>
    
    <div class="content">
        <div style="text-align: center; margin-bottom: 20px;">
            <span class="alert-badge">CRITICAL</span>
            <h2 style="color: #dc3545; margin: 10px 0;">${website.name || website.url}</h2>
            <p class="timestamp">Alert triggered: ${new Date().toLocaleString()}</p>
        </div>

        <div class="info-grid">
            <div class="info-item">
                <strong>🌐 URL</strong><br>
                ${website.url}
            </div>
            <div class="info-item">
                <strong>⚡ Method</strong><br>
                ${method}
            </div>
            <div class="info-item">
                <strong>📊 Status Code</strong><br>
                ${statusCode || 'N/A'}
            </div>
            <div class="info-item">
                <strong>⏱️ Response Time</strong><br>
                <span class="response-time">${responseTime}ms</span>
            </div>
        </div>

        ${errorMessage ? `
        <div style="background: #fff3cd; border: 1px solid #ffeaa7; border-radius: 5px; padding: 15px; margin: 15px 0;">
            <strong>⚠️ Error Details:</strong><br>
            ${errorMessage}
        </div>
        ` : ''}

        <div style="background: #d1ecf1; border: 1px solid #bee5eb; border-radius: 5px; padding: 15px; margin: 15px 0;">
            <strong>🔧 Recommended Actions:</strong>
            <ul style="margin: 10px 0; padding-left: 20px;">
                <li>Check server status and logs</li>
                <li>Verify network connectivity</li>
                <li>Review recent deployments</li>
                <li>Check SSL certificate validity</li>
            </ul>
        </div>
    </div>

    <div class="footer">
        <p>This alert was sent by InfraMon Monitoring System</p>
        <p>Monitor ID: ${website.id} • Checked at: ${new Date().toLocaleString()}</p>
    </div>
</body>
</html>
      `,
      text: (website, statusCode, responseTime, errorMessage, method) => `
🚨 CRITICAL: Website Down Alert
================================

Website: ${website.name || website.url}
URL: ${website.url}
Status: DOWN ❌
Response Time: ${responseTime}ms
Status Code: ${statusCode || 'N/A'}
Monitoring Method: ${method}
Error: ${errorMessage || 'None'}

📊 Technical Details:
- URL: ${website.url}
- Method: ${method}
- Status Code: ${statusCode || 'N/A'}
- Response Time: ${responseTime}ms
- Timestamp: ${new Date().toLocaleString()}

🔧 Recommended Actions:
• Check server status and logs
• Verify network connectivity  
• Review recent deployments
• Check SSL certificate validity

This is an automated alert from InfraMon.
Monitor ID: ${website.id}
      `
    },
    telegram: (website, statusCode, responseTime, errorMessage, method) => {
      // Escape all dynamic content to prevent Markdown parsing errors
      const safeWebsiteName = escapeMarkdown(website.name || website.url);
      const safeUrl = escapeMarkdown(website.url);
      const safeStatusCode = statusCode ? escapeMarkdown(statusCode.toString()) : 'N/A';
      const safeResponseTime = escapeMarkdown(responseTime.toString());
      const safeMethod = escapeMarkdown(method);
      const safeErrorMessage = errorMessage ? escapeMarkdown(errorMessage) : 'None';
      const safeTimestamp = escapeMarkdown(new Date().toLocaleString());
      const safeMonitorId = escapeMarkdown(website.id.toString());

      return `
🚨 *CRITICAL ALERT: Website Down* 🚨

*Website:* ${safeWebsiteName}
*URL:* ${safeUrl}
*Status:* DOWN ❌
*Response Time:* ${safeResponseTime}ms
*Status Code:* ${safeStatusCode}
*Method:* ${safeMethod}

📊 *Technical Details:*
• URL: ${safeUrl}
• Monitoring Method: ${safeMethod}
• Status Code: ${safeStatusCode}
• Response Time: ${safeResponseTime}ms
• Timestamp: ${safeTimestamp}

${safeErrorMessage !== 'None' ? `⚠️ *Error:* ${safeErrorMessage}` : ''}

🔧 *Recommended Actions:*
• Check server status
• Verify network connectivity
• Review recent changes
• Check SSL certificates

_This is an automated alert from InfraMon_
_Monitor ID: ${safeMonitorId}_
    `;
    }
  },
  recovery: {
    email: {
      subject: (website) => `🟢 RECOVERED: ${website.name || website.url} is BACK ONLINE - InfraMon`,
      html: (website, responseTime, method) => `
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; line-height: 1.6; color: #333; max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #28a745, #20c997); color: white; padding: 20px; border-radius: 10px 10px 0 0; text-align: center; }
        .content { background: #f8f9fa; padding: 20px; border-radius: 0 0 10px 10px; }
        .success-badge { background: #28a745; color: white; padding: 5px 10px; border-radius: 15px; font-size: 12px; font-weight: bold; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin: 15px 0; }
        .info-item { background: white; padding: 10px; border-radius: 5px; border-left: 4px solid #28a745; }
        .footer { text-align: center; margin-top: 20px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; font-size: 12px; }
        .response-time { font-size: 24px; font-weight: bold; color: #28a745; }
        .timestamp { color: #666; font-size: 12px; }
        .recovery-stats { background: #d4edda; border: 1px solid #c3e6cb; border-radius: 5px; padding: 15px; margin: 15px 0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>✅ Website Recovery Alert</h1>
        <p>Your website is back online and responding normally</p>
    </div>
    
    <div class="content">
        <div style="text-align: center; margin-bottom: 20px;">
            <span class="success-badge">RECOVERED</span>
            <h2 style="color: #28a745; margin: 10px 0;">${website.name || website.url}</h2>
            <p class="timestamp">Recovery detected: ${new Date().toLocaleString()}</p>
        </div>

        <div class="recovery-stats">
            <div style="text-align: center;">
                <span class="response-time">${responseTime}ms</span>
                <p style="margin: 5px 0; font-size: 16px;">Current Response Time</p>
            </div>
        </div>

        <div class="info-grid">
            <div class="info-item">
                <strong>🌐 URL</strong><br>
                ${website.url}
            </div>
            <div class="info-item">
                <strong>⚡ Method</strong><br>
                ${method}
            </div>
            <div class="info-item">
                <strong>🕒 Check Interval</strong><br>
                Every ${website.interval} minutes
            </div>
            <div class="info-item">
                <strong>📈 Status</strong><br>
                ONLINE ✅
            </div>
        </div>

        <div style="background: #d1ecf1; border: 1px solid #bee5eb; border-radius: 5px; padding: 15px; margin: 15px 0;">
            <strong>🎉 Recovery Confirmed:</strong>
            <p>Your website has successfully recovered and is now responding normally. The monitoring system will continue to track its status.</p>
        </div>
    </div>

    <div class="footer">
        <p>This recovery alert was sent by InfraMon Monitoring System</p>
        <p>Monitor ID: ${website.id} • Checked at: ${new Date().toLocaleString()}</p>
    </div>
</body>
</html>
      `,
      text: (website, responseTime, method) => `
✅ RECOVERY: Website Back Online
================================

Website: ${website.name || website.url}
URL: ${website.url}
Status: ONLINE ✅
Response Time: ${responseTime}ms
Monitoring Method: ${method}

🎉 Recovery Confirmed!
Your website has successfully recovered and is now responding normally.

📊 Current Status:
- URL: ${website.url}
- Method: ${method} 
- Response Time: ${responseTime}ms
- Status: ONLINE ✅
- Check Interval: Every ${website.interval} minutes
- Recovery Time: ${new Date().toLocaleString()}

The monitoring system will continue to track your website's status.

This is an automated recovery alert from InfraMon.
Monitor ID: ${website.id}
      `
    },
    telegram: (website, responseTime, method) => {
      // Escape all dynamic content for Telegram
      const safeWebsiteName = escapeMarkdown(website.name || website.url);
      const safeUrl = escapeMarkdown(website.url);
      const safeResponseTime = escapeMarkdown(responseTime.toString());
      const safeMethod = escapeMarkdown(method);
      const safeInterval = escapeMarkdown(website.interval.toString());
      const safeTimestamp = escapeMarkdown(new Date().toLocaleString());
      const safeMonitorId = escapeMarkdown(website.id.toString());

      return `
✅ *RECOVERY ALERT: Website Back Online* ✅

*Website:* ${safeWebsiteName}
*URL:* ${safeUrl}  
*Status:* ONLINE ✅
*Response Time:* ${safeResponseTime}ms
*Method:* ${safeMethod}

🎉 *Recovery Confirmed!*
Your website has successfully recovered and is now responding normally.

📊 *Current Status:*
• URL: ${safeUrl}
• Monitoring Method: ${safeMethod}
• Response Time: ${safeResponseTime}ms
• Status: ONLINE ✅
• Check Interval: Every ${safeInterval} minutes
• Recovery Time: ${safeTimestamp}

The monitoring system will continue to track your website's status.

_This is an automated recovery alert from InfraMon_
_Monitor ID: ${safeMonitorId}_
    `;
    }
  }
};

async function sendEmailAlert(to, subject, text, html = null) {
  try {
    if (!process.env.SMTP_HOST || !process.env.SMTP_USER) {
      console.log('📧 Email configuration missing - skipping email alert');
      return { success: false, error: 'Email configuration missing' };
    }

    // Test transporter connection
    try {
      await transporter.verify();
    } catch (verifyError) {
      console.error('📧 SMTP connection failed:', verifyError.message);
      return { success: false, error: 'SMTP connection failed: ' + verifyError.message };
    }

    const mailOptions = {
      from: process.env.SMTP_FROM || `InfraMon <${process.env.SMTP_USER}>`,
      to,
      subject,
      text
    };

    if (html) {
      mailOptions.html = html;
    }

    await transporter.sendMail(mailOptions);
    console.log(`📧 Email alert sent to ${to}`);
    return { success: true };
  } catch (error) {
    console.error('❌ Failed to send email alert:', error);
    return { success: false, error: error.message };
  }
}

async function sendTelegramAlert(chatId, message) {
  try {
    if (!process.env.TELEGRAM_BOT_TOKEN || !chatId) {
      console.log('Telegram configuration missing');
      return { success: false, error: 'Telegram configuration missing' };
    }

    if (!telegramBot) {
      telegramBot = new TelegramBot(process.env.TELEGRAM_BOT_TOKEN, { polling: false });
    }

    // Send with Markdown formatting and error handling
    await telegramBot.sendMessage(chatId, message, { 
      parse_mode: 'Markdown',
      disable_web_page_preview: true // Prevent URL previews that might cause issues
    });
    
    console.log(`🤖 Beautiful Telegram alert sent to chat ${chatId}`);
    return { success: true };
  } catch (error) {
    console.error('Failed to send telegram alert:', error);
    
    // Try sending without Markdown if Markdown fails
    if (error.code === 'ETELEGRAM' && error.response?.body?.description?.includes('parse entities')) {
      try {
        console.log('Retrying Telegram alert without Markdown formatting...');
        const plainMessage = message.replace(/\*/g, '').replace(/_/g, '').replace(/`/g, '');
        await telegramBot.sendMessage(chatId, plainMessage, {
          disable_web_page_preview: true
        });
        console.log(`🤖 Telegram alert sent (without Markdown) to chat ${chatId}`);
        return { success: true };
      } catch (retryError) {
        console.error('Failed to send telegram alert even without Markdown:', retryError);
        return { success: false, error: retryError.message };
      }
    }
    
    return { success: false, error: error.message };
  }
}

async function handleDowntime(website, statusCode, responseTime, errorMessage = '') {
  try {
    // ALWAYS fetch fresh user data from database
    const owner = await User.findByPk(website.userId, {
      attributes: ['id', 'username', 'email', 'telegramChatId', 'alertPreferences']
    });
    
    if (!owner) {
      console.error(`Owner not found for website ${website.url}`);
      return;
    }

    // Use fresh preferences from database
    const preferences = owner.alertPreferences || {
      email: true,
      telegram: false,
      minUptime: 99.5,
      notifyOnUp: true,
      notifyOnDown: true,
      alertCooldown: 30, // Default cooldown
      quietHours: { enabled: false, start: '22:00', end: '06:00' }
    };

    console.log('FRESH User preferences for downtime:', {
      notifyOnDown: preferences.notifyOnDown,
      email: preferences.email,
      telegram: preferences.telegram,
      alertCooldown: preferences.alertCooldown,
      quietHours: preferences.quietHours
    });

    // Check if downtime notifications are enabled
    if (preferences.notifyOnDown === false) {
      console.log(`Downtime notifications disabled for ${owner.username}`);
      return;
    }

    // Check quiet hours
    if (isInQuietHours(preferences.quietHours)) {
      console.log(`Quiet hours active for ${owner.username}`);
      return;
    }

    // CONFIGURABLE Alert cooldown check
    const cooldownMinutes = preferences.alertCooldown || 30; // Default to 30 minutes if not set
    const cooldownTimeAgo = new Date(Date.now() - cooldownMinutes * 60 * 1000);
    
    const recentAlert = await Alert.findOne({
      where: {
        websiteId: website.id,
        sentAt: { [Op.gte]: cooldownTimeAgo }
      }
    });

    if (recentAlert) {
      console.log(`Alert cooldown active for ${website.url}. Next alert in ${cooldownMinutes} minutes.`);
      return;
    }

    const method = website.httpMethod === 'CUSTOM_CURL' 
      ? 'CUSTOM CURL' 
      : website.httpMethod.startsWith('CURL_') 
        ? `CURL ${website.httpMethod.replace('CURL_', '')}` 
        : website.httpMethod;

    // Get beautiful messages (include cooldown info in message)
    const emailTemplate = messageTemplates.downtime.email;
    const telegramTemplate = messageTemplates.downtime.telegram;

    const emailSubject = emailTemplate.subject(website);
    const emailHtml = emailTemplate.html(website, statusCode, responseTime, errorMessage, method, cooldownMinutes);
    const emailText = emailTemplate.text(website, statusCode, responseTime, errorMessage, method, cooldownMinutes);
    const telegramMessage = telegramTemplate(website, statusCode, responseTime, errorMessage, method, cooldownMinutes);

    // Store alerts in database FIRST, then try to send
    const alertPromises = [];

    if (preferences.email && owner.email) {
      alertPromises.push(
        createAlertRecord(website.id, owner.id, 'email', emailText)
          .then(() => {
            return sendEmailAlert(owner.email, emailSubject, emailText, emailHtml)
              .then(result => {
                if (result.success) {
                  console.log(`✅ Beautiful downtime email sent to ${owner.email} (Cooldown: ${cooldownMinutes}min)`);
                } else {
                  console.error(`❌ Failed to send downtime email to ${owner.email}:`, result.error);
                }
              })
              .catch(emailError => {
                console.error(`❌ Error sending downtime email to ${owner.email}:`, emailError);
              });
          })
          .catch(alertError => {
            console.error(`❌ Failed to create email alert record for ${owner.email}:`, alertError);
          })
      );
    }

    if (preferences.telegram && owner.telegramChatId) {
      alertPromises.push(
        createAlertRecord(website.id, owner.id, 'telegram', telegramMessage)
          .then(() => {
            return sendTelegramAlert(owner.telegramChatId, telegramMessage)
              .then(result => {
                if (result.success) {
                  console.log(`✅ Beautiful downtime Telegram sent to ${owner.telegramChatId} (Cooldown: ${cooldownMinutes}min)`);
                } else {
                  console.error(`❌ Failed to send downtime Telegram to ${owner.telegramChatId}:`, result.error);
                }
              })
              .catch(telegramError => {
                console.error(`❌ Error sending downtime Telegram to ${owner.telegramChatId}:`, telegramError);
              });
          })
          .catch(alertError => {
            console.error(`❌ Failed to create Telegram alert record for ${owner.telegramChatId}:`, alertError);
          })
      );
    }

    // Wait for all alert operations to complete
    await Promise.allSettled(alertPromises);

  } catch (error) {
    console.error('Error in handleDowntime:', error);
  }
}

// Also update handleRecovery function with cooldown check
async function handleRecovery(website, responseTime) {
  try {
    // ALWAYS fetch fresh user data from database
    const owner = await User.findByPk(website.userId, {
      attributes: ['id', 'username', 'email', 'telegramChatId', 'alertPreferences']
    });
    
    if (!owner) {
      console.error(`Owner not found for website ${website.url}`);
      return;
    }

    // Use fresh preferences from database
    const preferences = owner.alertPreferences || {
      email: true,
      telegram: false,
      minUptime: 99.5,
      notifyOnUp: true,
      notifyOnDown: true,
      alertCooldown: 30,
      quietHours: { enabled: false, start: '22:00', end: '06:00' }
    };

    // Check if recovery notifications are enabled
    if (preferences.notifyOnUp === false) {
      console.log(`Recovery notifications disabled for ${owner.username}`);
      return;
    }

    // Check quiet hours
    if (isInQuietHours(preferences.quietHours)) {
      console.log(`Quiet hours active for ${owner.username}`);
      return;
    }

    // CONFIGURABLE Alert cooldown check for recovery too
    const cooldownMinutes = preferences.alertCooldown || 30;
    const cooldownTimeAgo = new Date(Date.now() - cooldownMinutes * 60 * 1000);
    
    const recentRecoveryAlert = await Alert.findOne({
      where: {
        websiteId: website.id,
        type: { [Op.in]: ['email', 'telegram'] },
        message: { [Op.like]: '%RECOVERED%' },
        sentAt: { [Op.gte]: cooldownTimeAgo }
      }
    });

    if (recentRecoveryAlert) {
      console.log(`Recovery alert cooldown active for ${website.url}. Next alert in ${cooldownMinutes} minutes.`);
      return;
    }

    const method = website.httpMethod === 'CUSTOM_CURL' 
      ? 'CUSTOM CURL' 
      : website.httpMethod.startsWith('CURL_') 
        ? `CURL ${website.httpMethod.replace('CURL_', '')}` 
        : website.httpMethod;

    // Get beautiful recovery messages
    const emailTemplate = messageTemplates.recovery.email;
    const telegramTemplate = messageTemplates.recovery.telegram;

    const emailSubject = emailTemplate.subject(website);
    const emailHtml = emailTemplate.html(website, responseTime, method);
    const emailText = emailTemplate.text(website, responseTime, method);
    const telegramMessage = telegramTemplate(website, responseTime, method);

    // Store recovery alerts in database FIRST, then try to send
    const alertPromises = [];

    if (preferences.email && owner.email) {
      alertPromises.push(
        createAlertRecord(website.id, owner.id, 'email', emailText)
          .then(() => {
            return sendEmailAlert(owner.email, emailSubject, emailText, emailHtml)
              .then(result => {
                if (result.success) {
                  console.log(`✅ Beautiful recovery email sent to ${owner.email} (Cooldown: ${cooldownMinutes}min)`);
                } else {
                  console.error(`❌ Failed to send recovery email to ${owner.email}:`, result.error);
                }
              })
              .catch(emailError => {
                console.error(`❌ Error sending recovery email to ${owner.email}:`, emailError);
              });
          })
          .catch(alertError => {
            console.error(`❌ Failed to create recovery email alert record for ${owner.email}:`, alertError);
          })
      );
    }

    if (preferences.telegram && owner.telegramChatId) {
      alertPromises.push(
        createAlertRecord(website.id, owner.id, 'telegram', telegramMessage)
          .then(() => {
            return sendTelegramAlert(owner.telegramChatId, telegramMessage)
              .then(result => {
                if (result.success) {
                  console.log(`✅ Beautiful recovery Telegram sent to ${owner.telegramChatId} (Cooldown: ${cooldownMinutes}min)`);
                } else {
                  console.error(`❌ Failed to send recovery Telegram to ${owner.telegramChatId}:`, result.error);
                }
              })
              .catch(telegramError => {
                console.error(`❌ Error sending recovery Telegram to ${owner.telegramChatId}:`, telegramError);
              });
          })
          .catch(alertError => {
            console.error(`❌ Failed to create recovery Telegram alert record for ${owner.telegramChatId}:`, alertError);
          })
      );
    }

    // Wait for all recovery alert operations to complete
    await Promise.allSettled(alertPromises);

  } catch (error) {
    console.error('Error in handleRecovery:', error);
  }
}

module.exports = {
  sendEmailAlert,
  sendTelegramAlert,
  handleDowntime,
  handleRecovery,
  messageTemplates,
  createAlertRecord
};