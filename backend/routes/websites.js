const express = require('express');
const { Website, MonitorLog, Alert } = require('../models');
const { authenticate, authorize } = require('../middleware/auth');
const monitorService = require('../services/monitorService');
const { Op } = require('sequelize');

const router = express.Router();

// Get all websites for the authenticated user
router.get('/', authenticate, async (req, res) => {
  try {
    const whereClause = {};
    
    // Admin can see all websites, users only see their own
    if (req.user.role !== 'admin') {
      whereClause.userId = req.user.id;
    }
    
    const websites = await Website.findAll({ where: whereClause });
    res.json(websites);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get a specific website
router.get('/:id', authenticate, async (req, res) => {
  try {
    const website = await Website.findOne({
      where: { id: req.params.id },
      include: [MonitorLog, Alert]
    });
    
    if (!website) {
      return res.status(404).json({ error: 'Website not found' });
    }
    
    // Check if user has access to this website
    if (req.user.role !== 'admin' && website.userId !== req.user.id) {
      return res.status(403).json({ error: 'Access denied' });
    }
    
    res.json(website);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create a new website
router.post('/', authenticate, authorize('admin', 'user'), async (req, res) => {
  try {
    const website = await Website.create({
      ...req.body,
      userId: req.user.id
    });
    
    // Start monitoring the new website if it's active
    if (website.isActive) {
      monitorService.startMonitoring(website);
    }
    
    res.status(201).json(website);
  } catch (error) {
    console.error('Error creating website:', error);
    res.status(500).json({ error: error.message });
  }
});

// Update a website
router.put('/:id', authenticate, async (req, res) => {
  try {
    const website = await Website.findByPk(req.params.id);
    
    if (!website) {
      return res.status(404).json({ error: 'Website not found' });
    }
    
    // Check if user has access to this website
    if (req.user.role !== 'admin' && website.userId !== req.user.id) {
      return res.status(403).json({ error: 'Access denied' });
    }
    
    const wasActive = website.isActive;
    await website.update(req.body);
    
    // Update monitoring if activity status changed
    if (wasActive !== website.isActive) {
      if (website.isActive) {
        monitorService.startMonitoring(website);
      } else {
        monitorService.stopMonitoring(website.id);
      }
    } else if (website.isActive) {
      // If still active but settings changed, restart monitoring
      monitorService.stopMonitoring(website.id);
      monitorService.startMonitoring(website);
    }
    
    res.json(website);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Delete a website
router.delete('/:id', authenticate, async (req, res) => {
  try {
    const website = await Website.findByPk(req.params.id);
    
    if (!website) {
      return res.status(404).json({ error: 'Website not found' });
    }
    
    // Check if user has access to this website
    if (req.user.role !== 'admin' && website.userId !== req.user.id) {
      return res.status(403).json({ error: 'Access denied' });
    }
    
    // Stop monitoring before deletion
    monitorService.stopMonitoring(website.id);
    await website.destroy();
    
    res.json({ message: 'Website deleted successfully' });
  } catch (error) {
    console.error('Error deleting website:', error);
    res.status(500).json({ error: 'Failed to delete website: ' + error.message });
  }
});

// Manually check a website
router.post('/:id/check', authenticate, async (req, res) => {
  try {
    const website = await Website.findByPk(req.params.id);
    
    if (!website) {
      return res.status(404).json({ error: 'Website not found' });
    }
    
    // Check if user has access to this website
    if (req.user.role !== 'admin' && website.userId !== req.user.id) {
      return res.status(403).json({ error: 'Access denied' });
    }
    
    const result = await monitorService.checkWebsite(website);
    res.json(result);
  } catch (error) {
    console.error('Error in manual check:', error);
    
    // Provide more specific error messages for CURL commands
    if (error.message.includes('curl') || error.message.includes('command')) {
      res.status(400).json({ 
        error: 'CURL command error: ' + error.message 
      });
    } else {
      res.status(500).json({ error: error.message });
    }
  }
});

// Test CURL command endpoint
router.post('/test-curl', authenticate, async (req, res) => {
  try {
    const { command } = req.body;
    
    if (!command || !command.trim()) {
      return res.status(400).json({ error: 'CURL command is required' });
    }
    
    // Basic security check
    if (!command.toLowerCase().startsWith('curl')) {
      return res.status(400).json({ error: 'Command must start with curl' });
    }
    
    const { exec } = require('child_process');
    const { promisify } = require('util');
    const execPromise = promisify(exec);
    
    const safeCommand = command + ' --max-time 30';
    const { stdout, stderr } = await execPromise(safeCommand);
    
    res.json({
      success: true,
      output: stdout,
      error: stderr
    });
    
  } catch (error) {
    console.error('CURL test error:', error);
    res.status(400).json({ 
      error: 'CURL command failed: ' + error.message 
    });
  }
});

// Get monitoring statistics for a website
router.get('/:id/stats', authenticate, async (req, res) => {
  try {
    const website = await Website.findByPk(req.params.id);
    
    if (!website) {
      return res.status(404).json({ error: 'Website not found' });
    }
    
    // Check if user has access to this website
    if (req.user.role !== 'admin' && website.userId !== req.user.id) {
      return res.status(403).json({ error: 'Access denied' });
    }
    
    // Calculate uptime statistics for the last 60 days
    const sixtyDaysAgo = new Date();
    sixtyDaysAgo.setDate(sixtyDaysAgo.getDate() - 60);
    
    const logs = await MonitorLog.findAll({
      where: {
        websiteId: website.id,
        createdAt: { [Op.gte]: sixtyDaysAgo }
      },
      order: [['createdAt', 'ASC']]
    });
    
    // Calculate uptime percentage
    const totalChecks = logs.length;
    const upChecks = logs.filter(log => log.status === 'up').length;
    const uptimePercentage = totalChecks > 0 ? (upChecks / totalChecks) * 100 : 0;
    
    // Calculate average response time
    const responseTimes = logs.map(log => log.responseTime).filter(time => time !== null);
    const avgResponseTime = responseTimes.length > 0 
      ? responseTimes.reduce((sum, time) => sum + time, 0) / responseTimes.length 
      : 0;
    
    // Group by day for chart data
    const dailyStats = {};
    logs.forEach(log => {
      const day = log.createdAt.toISOString().split('T')[0];
      if (!dailyStats[day]) {
        dailyStats[day] = { checks: 0, up: 0, totalResponseTime: 0 };
      }
      
      dailyStats[day].checks++;
      if (log.status === 'up') dailyStats[day].up++;
      if (log.responseTime) dailyStats[day].totalResponseTime += log.responseTime;
    });
    
    const chartData = Object.keys(dailyStats).map(day => ({
      date: day,
      uptime: (dailyStats[day].up / dailyStats[day].checks) * 100,
      avgResponseTime: dailyStats[day].up > 0 
        ? dailyStats[day].totalResponseTime / dailyStats[day].up 
        : 0
    }));
    
    res.json({
      uptimePercentage: parseFloat(uptimePercentage.toFixed(2)),
      avgResponseTime: parseFloat(avgResponseTime.toFixed(2)),
      totalChecks,
      upChecks,
      downChecks: totalChecks - upChecks,
      chartData
    });
  } catch (error) {
    console.error('Error getting stats:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;