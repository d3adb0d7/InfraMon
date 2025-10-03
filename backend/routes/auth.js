const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { sequelize } = require('../models'); // Added sequelize import
const { User } = require('../models');
const { authenticate } = require('../middleware/auth');

const router = express.Router();

// Login
router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;
    
    console.log('Login attempt for username:', username); // Debug log
    
    // Validate input
    if (!username || !password) {
      return res.status(400).json({ error: 'Username and password are required' });
    }
    
    // Find user using User model instead of raw query
    const user = await User.findOne({
      where: { username }
    });
    
    console.log('User found:', user ? 'Yes' : 'No'); // Debug log
    
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }
    
    console.log('User details:', { 
      id: user.id, 
      username: user.username, 
      role: user.role,
      passwordHash: user.password ? 'Present' : 'Missing'
    }); // Debug log
    
    // Check password
    const isPasswordValid = await bcrypt.compare(password, user.password);
    console.log('Password valid:', isPasswordValid); // Debug log
    
    if (!isPasswordValid) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    if (!user.isActive) {
      return res.status(401).json({ error: 'Account is deactivated' });
    }

    const token = jwt.sign(
      { id: user.id, username: user.username, role: user.role },
      process.env.JWT_SECRET || 'fallback-secret-key', // Fallback for development
      { expiresIn: '24h' }
    );

    console.log('Login successful for user:', user.username); // Debug log
    
    res.json({
      token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        phone: user.phone,
        role: user.role,
        telegramChatId: user.telegramChatId,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt
      }
    });
  } catch (error) {
    console.error('Login error details:', error);
    res.status(500).json({ error: 'Internal server error: ' + error.message });
  }
});

// Change password - FIXED: Remove manual hashing, let model hook handle it
router.post('/change-password', authenticate, async (req, res) => {
  try {
    const { currentPassword, newPassword } = req.body;
    
    // Validate input
    if (!currentPassword || !newPassword) {
      return res.status(400).json({ error: 'Current password and new password are required' });
    }
    
    if (newPassword.length < 6) {
      return res.status(400).json({ error: 'New password must be at least 6 characters long' });
    }
    
    const user = await User.findByPk(req.user.id);
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    // Verify current password
    if (!(await bcrypt.compare(currentPassword, user.password))) {
      return res.status(401).json({ error: 'Current password is incorrect' });
    }

    // Update password - let the model hook handle hashing automatically
    // Just set the plain password, the beforeUpdate hook will hash it
    await user.update({
      password: newPassword
    });

    res.json({ message: 'Password changed successfully' });
  } catch (error) {
    console.error('Change password error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get current user profile
router.get('/profile', authenticate, async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id, {
      attributes: { exclude: ['password'] }
    });
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    res.json(user);
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Update user profile - UPDATED: Include personal information fields
router.put('/profile', authenticate, async (req, res) => {
  try {
    const { email, telegramChatId, firstName, lastName, phone, username } = req.body;
    const user = await User.findByPk(req.user.id);
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    // Validate email if provided
    if (email && !/\S+@\S+\.\S+/.test(email)) {
      return res.status(400).json({ error: 'Invalid email format' });
    }

    // Check if username is being changed and if it's already taken
    if (username && username !== user.username) {
      const existingUser = await User.findOne({ where: { username } });
      if (existingUser) {
        return res.status(400).json({ error: 'Username already taken' });
      }
    }
    
    await user.update({
      email: email || user.email,
      username: username || user.username,
      telegramChatId: telegramChatId !== undefined ? telegramChatId : user.telegramChatId,
      firstName: firstName !== undefined ? firstName : user.firstName,
      lastName: lastName !== undefined ? lastName : user.lastName,
      phone: phone !== undefined ? phone : user.phone
    });

    // Return updated user without password
    const updatedUser = await User.findByPk(req.user.id, {
      attributes: { exclude: ['password'] }
    });

    res.json(updatedUser);
  } catch (error) {
    console.error('Update profile error:', error);
    if (error.name === 'SequelizeValidationError') {
      return res.status(400).json({ error: error.errors.map(e => e.message).join(', ') });
    }
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Verify token (for frontend to check if token is still valid)
router.get('/verify', authenticate, async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id, {
      attributes: { exclude: ['password'] }
    });
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({
      valid: true,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        phone: user.phone,
        role: user.role,
        telegramChatId: user.telegramChatId,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt
      }
    });
  } catch (error) {
    console.error('Verify token error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Debug endpoint to manually create admin user
router.post('/debug/create-admin', async (req, res) => {
  try {
    // Use User model to create admin - let hooks handle password hashing
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
      res.json({ message: 'Admin user created successfully' });
    } else {
      // Update existing admin password - let hook handle hashing
      await adminUser.update({ password: 'admin' });
      res.json({ message: 'Admin user password reset to "admin"' });
    }
  } catch (error) {
    console.error('Create admin error:', error);
    res.status(500).json({ error: error.message });
  }
});

// Temporary endpoint to fix double-hashed passwords
router.post('/debug/fix-passwords', async (req, res) => {
  try {
    const { username, newPassword } = req.body;
    
    if (!username || !newPassword) {
      return res.status(400).json({ error: 'Username and newPassword are required' });
    }
    
    const user = await User.findOne({ where: { username } });
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    // Reset password - let the model hook hash it properly
    await user.update({ password: newPassword });
    
    res.json({ message: `Password reset for user ${username}` });
  } catch (error) {
    console.error('Fix passwords error:', error);
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;