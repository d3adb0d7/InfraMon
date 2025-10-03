const express = require('express');
const { Alert, Website, User, sequelize } = require('../models'); // Added sequelize import
const { authenticate, authorize } = require('../middleware/auth');
const { Op } = require('sequelize');
const { sendEmailAlert, sendTelegramAlert } = require('../services/alertService');

const router = express.Router();

// Get all alerts with pagination and filtering
router.get('/', authenticate, async (req, res) => {
  try {
    const { 
      page = 1, 
      limit = 20, 
      type, 
      websiteId, 
      startDate, 
      endDate,
      search 
    } = req.query;

    console.log('Alerts query parameters:', {
      page, limit, type, websiteId, startDate, endDate, search
    });

    const whereClause = {};
    
    if (req.user.role !== 'admin') {
      whereClause.userId = req.user.id;
    }

    if (type && type !== 'all') {
      whereClause.type = type;
    }

    if (websiteId && websiteId !== 'all') {
      whereClause.websiteId = websiteId;
    }

    // FIX: Set proper date ranges (include entire end date)
    if (startDate || endDate) {
      whereClause.sentAt = {};
      
      if (startDate) {
        const start = new Date(startDate);
        start.setHours(0, 0, 0, 0); // Start of day
        whereClause.sentAt[Op.gte] = start;
      }
      
      if (endDate) {
        const end = new Date(endDate);
        end.setHours(23, 59, 59, 999); // End of day
        whereClause.sentAt[Op.lte] = end;
      }
    }

    console.log('Alerts date range filter:', whereClause.sentAt);

    if (search) {
      whereClause[Op.or] = [
        { message: { [Op.iLike]: `%${search}%` } },
        { '$Website.name$': { [Op.iLike]: `%${search}%` } },
        { '$Website.url$': { [Op.iLike]: `%${search}%` } }
      ];
    }

    const offset = (page - 1) * limit;

    const { count, rows: alerts } = await Alert.findAndCountAll({
      where: whereClause,
      include: [
        {
          model: Website,
          attributes: ['id', 'name', 'url', 'isActive'],
          include: [{
            model: User,
            attributes: ['id', 'username']
          }]
        },
        {
          model: User,
          attributes: ['id', 'username', 'email']
        }
      ],
      order: [['sentAt', 'DESC']],
      limit: parseInt(limit),
      offset: parseInt(offset)
    });

    console.log(`Found ${alerts.length} alerts out of ${count} total`);

    res.json({
      alerts,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(count / limit),
        totalItems: count,
        itemsPerPage: parseInt(limit)
      },
      debug: {
        queryParams: { page, limit, type, websiteId, startDate, endDate, search },
        dateRange: whereClause.sentAt,
        alertsCount: alerts.length,
        totalCount: count
      }
    });
  } catch (error) {
    console.error('Error fetching alerts:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get alert statistics
router.get('/stats', authenticate, async (req, res) => {
  try {
    const { startDate, endDate } = req.query;

    console.log('Alert stats query parameters:', { startDate, endDate });

    const whereClause = {};
    if (req.user.role !== 'admin') {
      whereClause.userId = req.user.id;
    }

    // FIX: Set proper date ranges (include entire end date)
    if (startDate || endDate) {
      whereClause.sentAt = {};
      
      if (startDate) {
        const start = new Date(startDate);
        start.setHours(0, 0, 0, 0); // Start of day
        whereClause.sentAt[Op.gte] = start;
      }
      
      if (endDate) {
        const end = new Date(endDate);
        end.setHours(23, 59, 59, 999); // End of day
        whereClause.sentAt[Op.lte] = end;
      }
    }

    // If no date range provided, default to last 30 days
    if (!startDate && !endDate) {
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
      thirtyDaysAgo.setHours(0, 0, 0, 0);
      
      const now = new Date();
      now.setHours(23, 59, 59, 999);
      
      whereClause.sentAt = { 
        [Op.between]: [thirtyDaysAgo, now] 
      };
    }

    console.log('Alert stats date range filter:', whereClause.sentAt);

    const alerts = await Alert.findAll({
      where: whereClause,
      include: [{
        model: Website,
        attributes: ['id', 'name', 'url']
      }]
    });

    console.log(`Found ${alerts.length} alerts for stats`);

    const stats = {
      total: alerts.length,
      byType: {
        email: alerts.filter(a => a.type === 'email').length,
        telegram: alerts.filter(a => a.type === 'telegram').length
      },
      byWebsite: {},
      dailyCount: {},
      recentAlerts: alerts.slice(0, 10).map(alert => ({
        id: alert.id,
        type: alert.type,
        message: alert.message,
        sentAt: alert.sentAt,
        website: alert.Website?.name || alert.Website?.url
      }))
    };

    alerts.forEach(alert => {
      const websiteName = alert.Website?.name || alert.Website?.url || 'Unknown';
      stats.byWebsite[websiteName] = (stats.byWebsite[websiteName] || 0) + 1;
      
      const day = alert.sentAt.toISOString().split('T')[0];
      stats.dailyCount[day] = (stats.dailyCount[day] || 0) + 1;
    });

    res.json({
      ...stats,
      debug: {
        dateRange: whereClause.sentAt,
        alertsCount: alerts.length
      }
    });
  } catch (error) {
    console.error('Error fetching alert statistics:', error);
    res.status(500).json({ error: error.message });
  }
});

// Get alert settings (user preferences) - SIMPLIFIED VERSION
router.get('/settings/preferences', authenticate, async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id, {
      attributes: ['id', 'email', 'telegramChatId', 'alertPreferences']
    });
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    res.json({
      email: user.email,
      telegramChatId: user.telegramChatId,
      preferences: user.alertPreferences
    });
  } catch (error) {
    console.error('Error fetching alert preferences:', error);
    res.status(500).json({ error: error.message });
  }
});

// Update alert settings - SIMPLIFIED VERSION
router.put('/settings/preferences', authenticate, async (req, res) => {
  try {
    const { email, telegramChatId, preferences } = req.body;

    console.log('Updating alert settings for user:', req.user.id);
    console.log('Settings data:', { email, telegramChatId, preferences });

    const user = await User.findByPk(req.user.id);
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    // Validate email if provided
    if (email && !/\S+@\S+\.\S+/.test(email)) {
      return res.status(400).json({ error: 'Invalid email format' });
    }

    // Update user settings
    await user.update({
      email: email || user.email,
      telegramChatId: telegramChatId !== undefined ? telegramChatId : user.telegramChatId,
      alertPreferences: preferences || user.alertPreferences
    });
    
    console.log('Alert settings updated successfully');
    
    res.json({
      message: 'Alert preferences updated successfully',
      user: {
        email: user.email,
        telegramChatId: user.telegramChatId,
        preferences: user.alertPreferences
      }
    });
    
  } catch (error) {
    console.error('Error updating alert preferences:', error);
    
    if (error.name === 'SequelizeValidationError') {
      return res.status(400).json({ error: error.errors.map(e => e.message).join(', ') });
    }
    
    res.status(500).json({ error: error.message });
  }
});

// Bulk delete alerts
router.post('/bulk-delete', authenticate, async (req, res) => {
  try {
    console.log('=== BULK DELETE REQUEST ===');
    console.log('Request body:', req.body);
    
    const { alertIds } = req.body;
    
    if (!alertIds || !Array.isArray(alertIds)) {
      return res.status(400).json({ error: 'Alert IDs array is required' });
    }
    
    if (alertIds.length === 0) {
      return res.status(400).json({ error: 'Alert IDs array cannot be empty' });
    }
    
    // Convert to numbers and filter invalid ones
    const validAlertIds = alertIds.map(id => parseInt(id)).filter(id => !isNaN(id));
    
    if (validAlertIds.length === 0) {
      return res.status(400).json({ error: 'No valid alert IDs found' });
    }
    
    // Build where clause based on user role
    const whereClause = { id: { [Op.in]: validAlertIds } };
    
    if (req.user.role !== 'admin') {
      whereClause.userId = req.user.id;
    }
    
    console.log('Deleting alerts with IDs:', validAlertIds);
    
    const result = await Alert.destroy({ where: whereClause });
    
    console.log('✅ Delete successful. Deleted count:', result);
    
    res.json({ 
      success: true,
      message: `Successfully deleted ${result} alert(s)`,
      deletedCount: result
    });
    
  } catch (error) {
    console.error('❌ Bulk delete error:', error);
    res.status(500).json({ error: error.message });
  }
});

// Test alert notification
// Test alert notification
router.post('/test', authenticate, async (req, res) => {
  try {
    const { type } = req.body;
    const user = await User.findByPk(req.user.id);

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    const testMessage = `Test alert from InfraMon\nTime: ${new Date().toLocaleString()}\nThis is a test notification to verify your alert settings.`;

    let result;

    if (type === 'email') {
      if (!user.email) {
        return res.status(400).json({ error: 'Email address not configured' });
      }
      result = await sendEmailAlert(user.email, 'InfraMon Test Alert', testMessage);
    } else if (type === 'telegram') {
      if (!user.telegramChatId) {
        return res.status(400).json({ error: 'Telegram chat ID not configured' });
      }
      result = await sendTelegramAlert(user.telegramChatId, testMessage);
    } else {
      return res.status(400).json({ error: 'Invalid alert type' });
    }

    if (!result.success) {
      return res.status(400).json({ error: result.error || `Failed to send ${type} test alert` });
    }

    // Log the test alert
    await Alert.create({
      type,
      message: testMessage,
      userId: user.id,
      websiteId: null
    });

    res.json({ message: 'Test alert sent successfully' });
  } catch (error) {
    console.error('Error sending test alert:', error);
    res.status(500).json({ error: error.message });
  }
});

// Delete a single alert
router.delete('/:id', authenticate, async (req, res) => {
  try {
    const alert = await Alert.findByPk(req.params.id);
    
    if (!alert) {
      return res.status(404).json({ error: 'Alert not found' });
    }

    if (req.user.role !== 'admin' && alert.userId !== req.user.id) {
      return res.status(403).json({ error: 'Access denied' });
    }

    await alert.destroy();
    
    res.json({ message: 'Alert deleted successfully' });
  } catch (error) {
    console.error('Error deleting alert:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;