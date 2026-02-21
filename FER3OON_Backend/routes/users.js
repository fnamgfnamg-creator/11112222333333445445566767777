const express = require('express');
const router = express.Router();
const usersController = require('../controllers/usersController');
const authMiddleware = require('../middleware/auth');

// ========================================
// PUBLIC ROUTES (Mobile App - No Auth)
// ========================================

// Register/Login user
router.post('/register', usersController.registerUser);

// Check user status
router.get('/status', usersController.checkStatus);

// Generate signal
router.post('/signal', usersController.generateSignal);

// ========================================
// ADMIN ROUTES (Dashboard - Auth Required)
// ========================================

// Get all users (with optional status filter)
router.get('/', authMiddleware, usersController.getAllUsers);

// Get user by UID
router.get('/:uid', authMiddleware, usersController.getUserByUID);

// Update user status
router.patch('/:uid/status', authMiddleware, usersController.updateUserStatus);

// Delete user
router.delete('/:uid', authMiddleware, usersController.deleteUser);

module.exports = router;
