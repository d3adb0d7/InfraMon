const express = require('express');
const { Website, MonitorLog, Alert, User } = require('../models');
const { authenticate, authorize } = require('../middleware/auth');
const { Op, Sequelize } = require('sequelize');

const router = express.Router();

// Get overall statistics - FIXED DATE RANGE
router.get('/overview', authenticate, async (req, res) => {
  try {
    const { startDate, endDate } = req.query;
    
    // Calculate date range (default: last 30 days) - FIXED: Include entire end date
    const defaultStartDate = new Date();
    defaultStartDate.setDate(defaultStartDate.getDate() - 30);
    
    // FIX: Set start date to beginning of day, end date to end of day
    const start = startDate ? new Date(startDate) : defaultStartDate;
    start.setHours(0, 0, 0, 0); // Start of day
    
    const end = endDate ? new Date(endDate) : new Date();
    end.setHours(23, 59, 59, 999); // End of day

    console.log('Date range for overview:', {
      start: start.toISOString(),
      end: end.toISOString(),
      startDate: req.query.startDate,
      endDate: req.query.endDate
    });

    // Build where clause based on user role
    const websiteWhereClause = {};
    if (req.user.role !== 'admin') {
      websiteWhereClause.userId = req.user.id;
    }

    // Get websites for the user
    const websites = await Website.findAll({ 
      where: websiteWhereClause,
      include: [{
        model: User,
        attributes: ['id', 'username']
      }]
    });

    const websiteIds = websites.map(w => w.id);

    if (websiteIds.length === 0) {
      return res.json({
        totalWebsites: 0,
        totalChecks: 0,
        uptimePercentage: 0,
        avgResponseTime: 0,
        alertsCount: 0,
        statusDistribution: { up: 0, down: 0, unknown: 0 },
        dailyStats: []
      });
    }

    // Get monitoring logs for the date range - FIXED: Use proper date range
    const logs = await MonitorLog.findAll({
      where: {
        websiteId: { [Op.in]: websiteIds },
        createdAt: { [Op.between]: [start, end] }
      },
      order: [['createdAt', 'ASC']]
    });

    console.log(`Found ${logs.length} logs for date range`);

    // Get alerts for the date range - FIXED: Use proper date range
    const alerts = await Alert.findAll({
      where: {
        websiteId: { [Op.in]: websiteIds },
        sentAt: { [Op.between]: [start, end] }
      }
    });

    console.log(`Found ${alerts.length} alerts for date range`);

    // Calculate overall statistics
    const totalChecks = logs.length;
    const upChecks = logs.filter(log => log.status === 'up').length;
    const uptimePercentage = totalChecks > 0 ? (upChecks / totalChecks) * 100 : 0;

    // Calculate average response time
    const responseTimes = logs.map(log => log.responseTime).filter(time => time !== null);
    const avgResponseTime = responseTimes.length > 0 
      ? responseTimes.reduce((sum, time) => sum + time, 0) / responseTimes.length 
      : 0;

    // Calculate status distribution for current status
    const currentStatuses = {};
    websites.forEach(website => {
      const latestLog = logs.filter(log => log.websiteId === website.id).pop();
      const status = latestLog ? latestLog.status : 'unknown';
      currentStatuses[status] = (currentStatuses[status] || 0) + 1;
    });

    // Calculate daily statistics - FIXED: Better date grouping
    const dailyStats = {};
    logs.forEach(log => {
      const day = log.createdAt.toISOString().split('T')[0];
      if (!dailyStats[day]) {
        dailyStats[day] = { checks: 0, up: 0, totalResponseTime: 0, websites: new Set() };
      }
      dailyStats[day].checks++;
      dailyStats[day].websites.add(log.websiteId);
      if (log.status === 'up') dailyStats[day].up++;
      if (log.responseTime) dailyStats[day].totalResponseTime += log.responseTime;
    });

    const dailyStatsArray = Object.keys(dailyStats).map(day => ({
      date: day,
      checks: dailyStats[day].checks,
      upChecks: dailyStats[day].up,
      uniqueWebsites: dailyStats[day].websites.size,
      uptime: dailyStats[day].checks > 0 ? (dailyStats[day].up / dailyStats[day].checks) * 100 : 0,
      avgResponseTime: dailyStats[day].up > 0 
        ? dailyStats[day].totalResponseTime / dailyStats[day].up 
        : 0
    })).sort((a, b) => a.date.localeCompare(b.date));

    const responseData = {
      totalWebsites: websites.length,
      totalChecks,
      uptimePercentage: parseFloat(uptimePercentage.toFixed(2)),
      avgResponseTime: parseFloat(avgResponseTime.toFixed(2)),
      alertsCount: alerts.length,
      statusDistribution: currentStatuses,
      dailyStats: dailyStatsArray,
      dateRange: {
        start: start.toISOString().split('T')[0],
        end: end.toISOString().split('T')[0]
      },
      debug: {
        logsCount: logs.length,
        alertsCount: alerts.length,
        queryStart: start.toISOString(),
        queryEnd: end.toISOString()
      }
    };

    console.log('Overview response data:', {
      totalWebsites: responseData.totalWebsites,
      totalChecks: responseData.totalChecks,
      uptimePercentage: responseData.uptimePercentage,
      alertsCount: responseData.alertsCount
    });

    res.json(responseData);
  } catch (error) {
    console.error('Error generating overview report:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get website-specific report - FIXED DATE RANGE
router.get('/website/:id', authenticate, async (req, res) => {
  try {
    const { id } = req.params;
    const { startDate, endDate } = req.query;

    // Get website
    const website = await Website.findByPk(id);
    if (!website) {
      return res.status(404).json({ error: 'Website not found' });
    }

    // Check permissions
    if (req.user.role !== 'admin' && website.userId !== req.user.id) {
      return res.status(403).json({ error: 'Access denied' });
    }

    // Calculate date range (default: last 30 days) - FIXED: Include entire end date
    const defaultStartDate = new Date();
    defaultStartDate.setDate(defaultStartDate.getDate() - 30);
    
    // FIX: Set start date to beginning of day, end date to end of day
    const start = startDate ? new Date(startDate) : defaultStartDate;
    start.setHours(0, 0, 0, 0);
    
    const end = endDate ? new Date(endDate) : new Date();
    end.setHours(23, 59, 59, 999);

    console.log('Date range for website report:', {
      websiteId: id,
      start: start.toISOString(),
      end: end.toISOString()
    });

    // Get monitoring logs - FIXED: Use proper date range
    const logs = await MonitorLog.findAll({
      where: {
        websiteId: id,
        createdAt: { [Op.between]: [start, end] }
      },
      order: [['createdAt', 'ASC']]
    });

    console.log(`Found ${logs.length} logs for website ${id}`);

    // Get alerts - FIXED: Use proper date range
    const alerts = await Alert.findAll({
      where: {
        websiteId: id,
        sentAt: { [Op.between]: [start, end] }
      },
      order: [['sentAt', 'DESC']]
    });

    // Calculate statistics
    const totalChecks = logs.length;
    const upChecks = logs.filter(log => log.status === 'up').length;
    const uptimePercentage = totalChecks > 0 ? (upChecks / totalChecks) * 100 : 0;

    const responseTimes = logs.map(log => log.responseTime).filter(time => time !== null);
    const avgResponseTime = responseTimes.length > 0 
      ? responseTimes.reduce((sum, time) => sum + time, 0) / responseTimes.length 
      : 0;

    // Calculate hourly statistics
    const hourlyStats = {};
    logs.forEach(log => {
      const hour = log.createdAt.toISOString().slice(0, 13) + ':00:00';
      if (!hourlyStats[hour]) {
        hourlyStats[hour] = { checks: 0, up: 0, totalResponseTime: 0 };
      }
      hourlyStats[hour].checks++;
      if (log.status === 'up') hourlyStats[hour].up++;
      if (log.responseTime) hourlyStats[hour].totalResponseTime += log.responseTime;
    });

    const hourlyStatsArray = Object.keys(hourlyStats).map(hour => ({
      hour,
      checks: hourlyStats[hour].checks,
      uptime: hourlyStats[hour].checks > 0 ? (hourlyStats[hour].up / hourlyStats[hour].checks) * 100 : 0,
      avgResponseTime: hourlyStats[hour].up > 0 
        ? hourlyStats[hour].totalResponseTime / hourlyStats[hour].up 
        : 0
    })).sort((a, b) => a.hour.localeCompare(b.hour));

    // Response time distribution
    const responseTimeRanges = {
      '0-100': 0,
      '101-200': 0,
      '201-300': 0,
      '301-500': 0,
      '500+': 0
    };

    responseTimes.forEach(time => {
      if (time <= 100) responseTimeRanges['0-100']++;
      else if (time <= 200) responseTimeRanges['101-200']++;
      else if (time <= 300) responseTimeRanges['201-300']++;
      else if (time <= 500) responseTimeRanges['301-500']++;
      else responseTimeRanges['500+']++;
    });

    const responseData = {
      website: {
        id: website.id,
        name: website.name,
        url: website.url,
        interval: website.interval,
        httpMethod: website.httpMethod
      },
      statistics: {
        totalChecks,
        upChecks,
        downChecks: totalChecks - upChecks,
        uptimePercentage: parseFloat(uptimePercentage.toFixed(2)),
        avgResponseTime: parseFloat(avgResponseTime.toFixed(2)),
        minResponseTime: responseTimes.length > 0 ? Math.min(...responseTimes) : 0,
        maxResponseTime: responseTimes.length > 0 ? Math.max(...responseTimes) : 0
      },
      hourlyStats: hourlyStatsArray,
      responseTimeDistribution: responseTimeRanges,
      recentAlerts: alerts.slice(0, 10),
      dateRange: {
        start: start.toISOString().split('T')[0],
        end: end.toISOString().split('T')[0]
      },
      debug: {
        logsCount: logs.length,
        alertsCount: alerts.length
      }
    };

    res.json(responseData);
  } catch (error) {
    console.error('Error generating website report:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get alerts report - FIXED DATE RANGE
router.get('/alerts', authenticate, async (req, res) => {
  try {
    const { startDate, endDate, type } = req.query;
    
    // FIX: Set proper date ranges
    const defaultStartDate = new Date();
    defaultStartDate.setDate(defaultStartDate.getDate() - 30);
    
    const start = startDate ? new Date(startDate) : defaultStartDate;
    start.setHours(0, 0, 0, 0);
    
    const end = endDate ? new Date(endDate) : new Date();
    end.setHours(23, 59, 59, 999);

    console.log('Date range for alerts report:', {
      start: start.toISOString(),
      end: end.toISOString(),
      type: type
    });

    // Build where clause
    const whereClause = {
      sentAt: { [Op.between]: [start, end] }
    };

    if (type && type !== 'all') {
      whereClause.type = type;
    }

    // For non-admin users, only show their alerts
    if (req.user.role !== 'admin') {
      whereClause.userId = req.user.id;
    }

    const alerts = await Alert.findAll({
      where: whereClause,
      include: [{
        model: Website,
        attributes: ['id', 'name', 'url'],
        include: [{
          model: User,
          attributes: ['id', 'username']
        }]
      }],
      order: [['sentAt', 'DESC']]
    });

    console.log(`Found ${alerts.length} alerts for report`);

    // Group alerts by type and website
    const alertStats = {
      total: alerts.length,
      byType: {},
      byWebsite: {},
      dailyCount: {}
    };

    alerts.forEach(alert => {
      // Count by type
      alertStats.byType[alert.type] = (alertStats.byType[alert.type] || 0) + 1;
      
      // Count by website
      const websiteName = alert.Website?.name || alert.Website?.url || 'Unknown';
      alertStats.byWebsite[websiteName] = (alertStats.byWebsite[websiteName] || 0) + 1;
      
      // Count by day
      const day = alert.sentAt.toISOString().split('T')[0];
      alertStats.dailyCount[day] = (alertStats.dailyCount[day] || 0) + 1;
    });

    const responseData = {
      alerts,
      statistics: alertStats,
      dateRange: {
        start: start.toISOString().split('T')[0],
        end: end.toISOString().split('T')[0]
      },
      debug: {
        alertsCount: alerts.length
      }
    };

    res.json(responseData);
  } catch (error) {
    console.error('Error generating alerts report:', error);
    res.status(500).json({ error: error.message });
  }
});

// Export data as CSV - FIXED DATE RANGE
router.get('/export', authenticate, async (req, res) => {
  try {
    const { type, startDate, endDate } = req.query;
    
    if (!['monitoring', 'alerts'].includes(type)) {
      return res.status(400).json({ error: 'Invalid export type' });
    }

    // FIX: Set proper date ranges
    const defaultStartDate = new Date();
    defaultStartDate.setDate(defaultStartDate.getDate() - 30);
    
    const start = startDate ? new Date(startDate) : defaultStartDate;
    start.setHours(0, 0, 0, 0);
    
    const end = endDate ? new Date(endDate) : new Date();
    end.setHours(23, 59, 59, 999);

    console.log('Export data with date range:', {
      type,
      start: start.toISOString(),
      end: end.toISOString()
    });

    // Build website where clause
    const websiteWhereClause = {};
    if (req.user.role !== 'admin') {
      websiteWhereClause.userId = req.user.id;
    }

    const websites = await Website.findAll({ where: websiteWhereClause });
    const websiteIds = websites.map(w => w.id);

    if (type === 'monitoring') {
      const logs = await MonitorLog.findAll({
        where: {
          websiteId: { [Op.in]: websiteIds },
          createdAt: { [Op.between]: [start, end] }
        },
        include: [{
          model: Website,
          attributes: ['name', 'url'],
          include: [{
            model: User,
            attributes: ['username']
          }]
        }],
        order: [['createdAt', 'DESC']]
      });

      let csv = 'Date,Time,Website,URL,Status,Response Time (ms),Status Code,Message\n';
      logs.forEach(log => {
        const date = log.createdAt.toISOString().split('T')[0];
        const time = log.createdAt.toISOString().split('T')[1].split('.')[0];
        csv += `"${date}","${time}","${log.Website.name || log.Website.url}","${log.Website.url}","${log.status}","${log.responseTime || ''}","${log.statusCode || ''}","${log.message || ''}"\n`;
      });

      res.setHeader('Content-Type', 'text/csv');
      res.setHeader('Content-Disposition', `attachment; filename=monitoring-export-${new Date().toISOString().split('T')[0]}.csv`);
      res.send(csv);

    } else if (type === 'alerts') {
      const alerts = await Alert.findAll({
        where: {
          websiteId: { [Op.in]: websiteIds },
          sentAt: { [Op.between]: [start, end] }
        },
        include: [{
          model: Website,
          attributes: ['name', 'url']
        }, {
          model: User,
          attributes: ['username']
        }],
        order: [['sentAt', 'DESC']]
      });

      let csv = 'Date,Time,Type,Website,URL,Message,User\n';
      alerts.forEach(alert => {
        const date = alert.sentAt.toISOString().split('T')[0];
        const time = alert.sentAt.toISOString().split('T')[1].split('.')[0];
        csv += `"${date}","${time}","${alert.type}","${alert.Website.name || alert.Website.url}","${alert.Website.url}","${alert.message}","${alert.User.username}"\n`;
      });

      res.setHeader('Content-Type', 'text/csv');
      res.setHeader('Content-Disposition', `attachment; filename=alerts-export-${new Date().toISOString().split('T')[0]}.csv`);
      res.send(csv);
    }
  } catch (error) {
    console.error('Error exporting data:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;