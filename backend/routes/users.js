const { Op } = require('sequelize');
const express = require('express');
const { User, Website, Alert } = require('../models');
const { authenticate, authorize } = require('../middleware/auth');
const bcrypt = require('bcryptjs');

const router = express.Router();

// Get all users (admin only)
router.get('/', authenticate, authorize('admin'), async (req, res) => {
  try {
    const users = await User.findAll({
      attributes: { exclude: ['password'] },
      order: [['createdAt', 'DESC']]
    });
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Create a new user (admin only) - UPDATED: Include personal info
router.post('/', authenticate, authorize('admin'), async (req, res) => {
  try {
    const { 
      username, 
      email, 
      password, 
      role, 
      telegramChatId, 
      isActive = true,
      firstName,
      lastName,
      phone
    } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({
      where: {
        [Op.or]: [{ email }, { username }]
      }
    });

    if (existingUser) {
      return res.status(400).json({ error: 'User with this email or username already exists' });
    }

    // Create user - let the model hooks handle password hashing
    const user = await User.create({
      username,
      email,
      password, // Pass plain password, let hook hash it
      firstName,
      lastName,
      phone,
      role: role || 'user',
      telegramChatId: telegramChatId || null,
      isActive
    });

    res.status(201).json({
      id: user.id,
      username: user.username,
      email: user.email,
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
      role: user.role,
      telegramChatId: user.telegramChatId,
      isActive: user.isActive,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt
    });
  } catch (error) {
    if (error.name === 'SequelizeValidationError') {
      return res.status(400).json({ error: error.errors.map(e => e.message).join(', ') });
    }
    res.status(500).json({ error: error.message });
  }
});

// Update a user - UPDATED: Include personal info
router.put('/:id', authenticate, async (req, res) => {
  try {
    const { id } = req.params;
    
    // Users can only update themselves, admin can update anyone
    if (req.user.role !== 'admin' && req.user.id !== parseInt(id)) {
      return res.status(403).json({ error: 'Access denied' });
    }
    
    const user = await User.findByPk(id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    // Don't allow non-admins to change roles or activate/deactivate
    if (req.user.role !== 'admin') {
      if (req.body.role && req.body.role !== user.role) {
        return res.status(403).json({ error: 'Cannot change role' });
      }
      if (req.body.isActive !== undefined && req.body.isActive !== user.isActive) {
        return res.status(403).json({ error: 'Cannot change activation status' });
      }
    }

    // Check if username is being changed and if it's already taken
    if (req.body.username && req.body.username !== user.username) {
      const existingUser = await User.findOne({ 
        where: { 
          username: req.body.username,
          id: { [Op.ne]: id }
        } 
      });
      if (existingUser) {
        return res.status(400).json({ error: 'Username already taken' });
      }
    }

    // Prepare update data - let the model handle password hashing
    const updateData = { ...req.body };
    
    // If password is provided, it will be hashed by the model hook
    // If not provided, remove it from update data to avoid issues
    if (!updateData.password) {
      delete updateData.password;
    }

    await user.update(updateData);
    
    // Return user without password
    const updatedUser = await User.findByPk(id, {
      attributes: { exclude: ['password'] }
    });
    
    res.json(updatedUser);
  } catch (error) {
    if (error.name === 'SequelizeValidationError') {
      return res.status(400).json({ error: error.errors.map(e => e.message).join(', ') });
    }
    res.status(500).json({ error: error.message });
  }
});

// Delete a user (admin only)
router.delete('/:id', authenticate, authorize('admin'), async (req, res) => {
  try {
    const user = await User.findByPk(req.params.id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    
    // Prevent admin from deleting themselves
    if (user.id === req.user.id) {
      return res.status(400).json({ error: 'Cannot delete your own account' });
    }
    
    await user.destroy();
    res.json({ message: 'User deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;