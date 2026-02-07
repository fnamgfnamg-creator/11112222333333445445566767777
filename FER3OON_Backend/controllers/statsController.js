const User = require('../models/user');

exports.getStats = async (req, res) => {
  try {
    const totalUsers = await User.countDocuments();
    const pendingUsers = await User.countDocuments({ status: 'PENDING' });
    const approvedUsers = await User.countDocuments({ status: 'APPROVED' });
    const blockedUsers = await User.countDocuments({ status: 'BLOCKED' });

    // Recent users (last 7 days)
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
    const recentUsers = await User.countDocuments({
      createdAt: { $gte: sevenDaysAgo }
    });

    // Active users (logged in last 24 hours)
    const oneDayAgo = new Date();
    oneDayAgo.setDate(oneDayAgo.getDate() - 1);
    const activeUsers = await User.countDocuments({
      lastLogin: { $gte: oneDayAgo },
      status: 'APPROVED'
    });

    res.json({
      success: true,
      stats: {
        total: totalUsers,
        pending: pendingUsers,
        approved: approvedUsers,
        blocked: blockedUsers,
        recentSignups: recentUsers,
        activeToday: activeUsers
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
