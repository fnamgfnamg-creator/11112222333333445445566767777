const mongoose = require('mongoose');

const signalHistorySchema = new mongoose.Schema({
  signal: {
    type: String,
    enum: ['CALL', 'PUT'],
    required: true
  },
  timestamp: {
    type: Date,
    default: Date.now
  }
});

const userSchema = new mongoose.Schema({
  uid: {
    type: String,
    required: true,
    unique: true,
    trim: true
  },
  deviceId: {
    type: String,
    required: true,
    trim: true
  },
  status: {
    type: String,
    enum: ['PENDING', 'APPROVED', 'BLOCKED'],
    default: 'PENDING'
  },
  signalHistory: [signalHistorySchema],
  createdAt: {
    type: Date,
    default: Date.now
  },
  lastLogin: {
    type: Date,
    default: Date.now
  },
  deviceHistory: [{
    deviceId: String,
    loginAt: {
      type: Date,
      default: Date.now
    }
  }]
}, {
  timestamps: true
});

// Index for faster queries
userSchema.index({ uid: 1 });
userSchema.index({ status: 1 });
userSchema.index({ deviceId: 1 });

module.exports = mongoose.model('User', userSchema);
