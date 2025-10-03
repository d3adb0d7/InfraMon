require('dotenv').config();
const express = require('express');
const cors = require('cors');
const axios = require('axios');
const bcrypt = require('bcryptjs');
const { sequelize } = require('./models');
const monitorService = require('./services/monitorService');

// Import routes
const authRoutes = require('./routes/auth');
const websiteRoutes = require('./routes/websites');
const userRoutes = require('./routes/users');
const reportRoutes = require('./routes/reports');
const alertRoutes = require('./routes/alerts');

// JWT secret fallback for development
if (!process.env.JWT_SECRET) {
  console.log('WARNING: JWT_SECRET not set, using fallback key for development');
  process.env.JWT_SECRET = 'dev-fallback-secret-key-change-in-production';
}

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Request logging
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} - ${req.method} ${req.url}`);
  next();
});

app.use(express.json({ limit: '10mb' })); // For parsing application/json
app.use(express.urlencoded({ extended: true })); // For parsing application/x-www-form-urlencoded

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/websites', websiteRoutes);
app.use('/api/users', userRoutes);
app.use('/api/reports', reportRoutes);
app.use('/api/alerts', alertRoutes);

// Server-Sent Events for real-time status updates
app.get('/api/events', async (req, res) => {
  try {
    // Get token from query parameter
    const token = req.query.token;
    if (!token) {
      return res.status(401).json({ error: 'Access denied. No token provided.' });
    }

    // Verify token
    const jwt = require('jsonwebtoken');
    const { User } = require('./models');
    
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findByPk(decoded.id);
    
    if (!user) {
      return res.status(401).json({ error: 'Invalid token.' });
    }

    console.log('SSE connection established for user:', user.username);
    
    // Set SSE headers
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.flushHeaders();

    // Send initial connection message
    res.write('data: {"type": "connected", "message": "SSE connection established"}\n\n');

    // Function to send status updates
    const sendStatusUpdate = (websiteId, statusData) => {
      try {
        res.write(`data: ${JSON.stringify({
          type: 'status_update',
          websiteId,
          ...statusData
        })}\n\n`);
      } catch (error) {
        console.error('Error sending SSE update:', error);
      }
    };

    // Store the response object for later use
    if (!global.sseConnections) {
      global.sseConnections = new Map();
    }
    global.sseConnections.set(user.id, { res, sendStatusUpdate, user });

    // Handle client disconnect
    req.on('close', () => {
      console.log('SSE connection closed for user:', user.username);
      if (global.sseConnections) {
        global.sseConnections.delete(user.id);
      }
      res.end();
    });

    // Keep connection alive with heartbeat
    const heartbeat = setInterval(() => {
      try {
        res.write(': heartbeat\n\n');
      } catch (error) {
        clearInterval(heartbeat);
      }
    }, 30000);

    // Cleanup on connection close
    req.on('close', () => {
      clearInterval(heartbeat);
      if (global.sseConnections) {
        global.sseConnections.delete(user.id);
      }
    });

  } catch (error) {
    console.error('SSE authentication error:', error);
    res.status(401).json({ error: 'Invalid token' });
  }
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Test endpoint
app.get('/test', (req, res) => {
  res.json({ message: 'Server is working!' });
});

// Error handling middleware
app.use((error, req, res, next) => {
  console.error('Error:', error);
  res.status(500).json({ error: 'Internal server error' });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Initialize database and start server
const PORT = process.env.PORT || 5002;

async function initializeApp() {
  try {
    console.log('Testing database connection...');
    await sequelize.authenticate();
    console.log('Database connection established successfully');
    
    // Sync database
    console.log('Syncing database models...');
    await sequelize.sync({ force: false });
    console.log('Database synchronized successfully');
    
    // Create default admin user if it doesn't exist
    console.log('Checking for admin user...');
    try {
      const { User } = require('./models');
      const [adminUser, created] = await User.findOrCreate({
        where: { username: 'admin' },
        defaults: {
          username: 'admin',
          email: 'admin@InfraMon.app',
          password: 'admin', // Will be hashed by hook
          firstName: 'System',
          lastName: 'Administrator',
          role: 'admin',
          isActive: true
        }
      });
      
      if (created) {
        console.log('Default admin user created successfully');
      } else {
        console.log('Admin user already exists');
      }
    } catch (userError) {
      console.log('Could not check/create admin user:', userError.message);
    }
    
    // Initialize monitoring
    console.log('Initializing monitoring service...');
    await monitorService.initializeMonitoring();
    console.log('Monitoring service initialized');
    
    // Start server
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
      console.log('Default admin credentials:');
      console.log('  Username: admin');
      console.log('  Password: admin');
    });
  } catch (error) {
    console.error('Unable to start server:', error);
    process.exit(1);
  }
}

initializeApp();