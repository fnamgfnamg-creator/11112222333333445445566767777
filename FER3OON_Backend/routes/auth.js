const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// Admin login
router.post('/admin/login', authController.adminLogin);

// User registration
router.post('/register', authController.registerUser);

// Check user status
router.post('/status', authController.checkStatus);

module.exports = router;
