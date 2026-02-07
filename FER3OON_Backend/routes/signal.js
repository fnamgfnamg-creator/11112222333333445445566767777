const express = require('express');
const router = express.Router();
const usersController = require('../controllers/usersController');

// Generate signal for user
router.post('/generate', usersController.generateSignal);

module.exports = router;
