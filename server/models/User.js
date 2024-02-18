const crypto = require('crypto');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { generateSixDigitRandomNumber } = require('../utils/functions');

const User = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, 'Name is required'],
      maxlength: [20, 'Name should not exceed 16 characters']
    },
    avatar: {
      type: String,
      default: 'default-avatar.jpg'
    },
    email: {
      type: String,
      required: [true, 'Please add an Email'],
      unique: true
    },
    phone: {
      type: String,
      required: [true, 'Please add an Phone Number'],
      unique: true
    },
    password: {
      type: String,
      required: [true, 'Please add a Password'],
      minlength: 6,
      select: false
    },
    bloodType: {
      type: String,
      required: [true, 'Please select Blood Group'],
      default: ''
    },
    address: {
      type: String,
      maxlength: 120,
      default: ''
    },
    locationCoordinates: {
      type: {
        type: String,
        enum: ['Point']
      },
      coordinates: {
        type: [Number],
        index: '2dsphere'
      }
    },
    fcmToken: {
      type: String
    },
    resetPasswordToken: String,
    resetPasswordExpire: Date,
    createdAt: { type: Date, default: Date.now }
  },
  { toJSON: { virtuals: true } }
);

// Hash password using bcrypt before saving
User.pre('save', async function (next) {
  if (!this.isModified('password')) {
    next();
  }

  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
});

// Sign And Return JWT
User.methods.getSignedJwtToken = function () {
  return jwt.sign({ id: this._id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE
  });
};

// Match user entered password to hashed password in database
User.methods.matchPassword = async function (enteredPassword) {
  return await bcrypt.compare(enteredPassword, this.password);
};

// Generate and hash password token
User.methods.getResetPasswordToken = function () {
  const resetToken = generateSixDigitRandomNumber().toString();

  // Hash token and set to resetPasswordToken field
  this.resetPasswordToken = crypto
    .createHash('sha256')
    .update(resetToken)
    .digest('hex');

  // Set expire for 10 mins
  this.resetPasswordExpire = Date.now() + 10 * 60 * 1000;
  return resetToken;
};

module.exports = mongoose.model('User', User);
