const User = require('../models/user');

// Get all users
exports.getAllUsers = async (req, res) => {
  try {
    const { status } = req.query;
    
    let query = {};
    if (status && ['PENDING', 'APPROVED', 'BLOCKED'].includes(status)) {
      query.status = status;
    }

    const users = await User.find(query)
      .sort({ createdAt: -1 })
      .select('-signalHistory -__v');

    res.json({
      success: true,
      count: users.length,
      users
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Get user by UID
exports.getUserByUID = async (req, res) => {
  try {
    const { uid } = req.params;

    const user = await User.findOne({ uid });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    res.json({
      success: true,
      user
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Update user status
exports.updateUserStatus = async (req, res) => {
  try {
    const { uid } = req.params;
    const { status } = req.body;

    if (!['PENDING', 'APPROVED', 'BLOCKED'].includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid status'
      });
    }

    const user = await User.findOne({ uid });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    user.status = status;
    await user.save();

    res.json({
      success: true,
      message: `User status updated to ${status}`,
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

// Delete user
exports.deleteUser = async (req, res) => {
  try {
    const { uid } = req.params;

    const user = await User.findOneAndDelete({ uid });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    res.json({
      success: true,
      message: 'User deleted successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};

// Signal Generation (Hour-based bias system)
let currentHourBias = null;
let lastHourCheck = null;

exports.generateSignal = async (req, res) => {
  try {
    const { uid } = req.body;

    if (!uid) {
      return res.status(400).json({
        success: false,
        message: 'UID is required'
      });
    }

    // Check user exists and is approved
    const user = await User.findOne({ uid });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    if (user.status !== 'APPROVED') {
      return res.status(403).json({
        success: false,
        message: 'User not approved'
      });
    }

    const now = new Date();
    const currentSecond = now.getSeconds();

    // Only generate signal at the start of a new minute (0-5 seconds)
    if (currentSecond > 5) {
      return res.status(400).json({
        success: false,
        message: 'Signal can only be generated at the start of a new minute'
      });
    }

    // Check hour-based bias
    const currentHour = now.getHours();
    
    // If hour changed, switch bias
    if (lastHourCheck !== currentHour) {
      // Alternate between CALL-heavy and PUT-heavy hours
      currentHourBias = (currentHour % 2 === 0) ? 'CALL' : 'PUT';
      lastHourCheck = currentHour;
    }

    // Generate signal based on bias
    // 60% bias direction, 40% opposite
    let signal;
    const random = Math.random();
    
    if (currentHourBias === 'CALL') {
      signal = random < 0.6 ? 'CALL' : 'PUT';
    } else {
      signal = random < 0.6 ? 'PUT' : 'CALL';
    }

    // Save signal to history
    user.signalHistory.push({
      signal,
      timestamp: now
    });
    await user.save();

    res.json({
      success: true,
      signal,
      timestamp: now.toISOString(),
      duration: 60
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error',
      error: error.message
    });
  }
};
