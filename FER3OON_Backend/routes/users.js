const express = require('express');
const router = express.Router();
const usersController = require('../controllers/usersController');
const authMiddleware = require('../middleware/auth');

// All routes require admin authentication
router.use(authMiddleware);

// Get all users (with optional status filter)
router.get('/', usersController.getAllUsers);

// Get user by UID
router.get('/:uid', usersController.getUserByUID);

// Update user status
router.patch('/:uid/status', usersController.updateUserStatus);

// Delete user
router.delete('/:uid', usersController.deleteUser);

module.exports = router;
