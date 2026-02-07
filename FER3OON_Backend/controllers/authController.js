const jwt = require('jsonwebtoken');
const User = require('../models/user');

// Admin Login
exports.adminLogin = async (req, res) => {
  try {
    const { username, password } = req.body;

    // Hardcoded credentials check
    if (
      username === process.env.ADMIN_USERNAME &&
      password === process.env.ADMIN_PASSWORD
    ) {
      // Generate JWT token
      const token = jwt.sign(
        { username, role: 'admin' },
        process.env.JWT_SECRET,
        { expiresIn: '7d' }
      );

      res.json({
        success: true,
        token,
        admin: {
          username: process.env.ADMIN_USERNAME
        }
      });
    } else {
      res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// User Registration
exports.registerUser = async (req, res) => {
  try {
    const { uid, deviceId } = req.body;

    if (!uid || !deviceId) {
      return res.status(400).json({
        success: false,
        message: 'UID and Device ID are required'
      });
    }

    // Check if user exists
    let user = await User.findOne({ uid });

    if (user) {
      // Check for multiple device login
      if (user.deviceId !== deviceId) {
        // Different device detected - AUTO BLOCK
        user.status = 'BLOCKED';
        
        // Block both devices
        user.deviceHistory.push({
          deviceId: deviceId,
          loginAt: new Date()
        });
        
        await user.save();

        return res.status(403).json({
          success: false,
          message: 'Account blocked due to multiple device login',
          status: 'BLOCKED'
        });
      }

      // Same device - update last login
      user.lastLogin = new Date();
      await user.save();

      return res.json({
        success: true,
        message: 'User already exists',
        status: user.status,
        user: {
          uid: user.uid,
          status: user.status
        }
      });
    }

    // Create new user
    user = new User({
      uid,
      deviceId,
      status: 'PENDING',
      deviceHistory: [{
        deviceId,
        loginAt: new Date()
      }]
    });

    await user.save();

    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      status: 'PENDING',
      user: {
        uid: user.uid,
        status: user.status
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Check User Status
exports.checkStatus = async (req, res) => {
  try {
    const { uid, deviceId } = req.body;

    if (!uid || !deviceId) {
      return res.status(400).json({
        success: false,
        message: 'UID and Device ID are required'
      });
    }

    const user = await User.findOne({ uid });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    // Check device match
    if (user.deviceId !== deviceId) {
      return res.status(403).json({
        success: false,
        message: 'Device mismatch',
        status: 'BLOCKED'
      });
    }

    // Update last login
    user.lastLogin = new Date();
    await user.save();

    res.json({
      success: true,
      status: user.status,
      user: {
        uid: user.uid,
        status: user.status,
        lastLogin: user.lastLogin
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};
