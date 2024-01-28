const crypto = require('crypto');
const User = require('../models/User');
const catchAsync = require('../utils/catchAsync');
const ErrorResponse = require('../utils/errorResponse');
const { isAuthenticated } = require('../middlewares/auth');

/**
 * @route POST /api/auth/login
 * @desc let the user login
 * @secure false
 */
exports.login = catchAsync(async (req, res, next) => {
  const { email, password } = req.body;

  // Validate email & password
  if (!email || !password) {
    return next(new ErrorResponse('Please provide an email and password', 400));
  }

  const user = await User.findOne({ email }).select('+password');

  // User Not Found In DB
  if (!user) {
    return next(new ErrorResponse('Invalid Email Or Password', 401));
  }

  const isPasswordMatched = await user.matchPassword(password);

  // Wrong Password
  if (!isPasswordMatched) {
    return next(new ErrorResponse('Invalid Email Or Password', 401));
  }

  sendTokenResponse(user, 200, res);
});

/**
 * @route POST /api/auth/register
 * @desc let the user register
 * @secure false
 */
exports.register = catchAsync(async (req, res) => {
  const { name, email, phone, address, bloodType, password } = req.body;
  const avatar = `default-avatar.jpg`;

  const user = await User.create({
    name,
    avatar,
    email,
    avatar,
    phone,
    address,
    bloodType,
    password
  });

  sendTokenResponse(user, 200, res);
});

/**
 * @route POST /api/auth/forgot-password
 * @desc Sends a mail with reset token to the given email address
 * @secure false
 */
exports.forgotPassword = catchAsync(async (req, res, next) => {
  const { email } = req.body;
  const user = await User.findOne({ email });

  if (!user) {
    return next(
      new ErrorResponse('No User found with that email address', 404)
    );
  }

  const token = user.getResetPasswordToken();

  try {
    res.status(200).json({ success: true, msg: 'Password reset request sent' });
  } catch (err) {
    user.resetPasswordToken = undefined;
    user.resetPasswordExpire = undefined;
    await user.save();
    return next(new ErrorResponse('Could not send email', 500));
  }

  await user.save();
});

/**
 * @route POST /api/auth/reset-password/:token
 * @desc Resets a user's password when requested with right reset token
 * @secure false
 */
exports.resetPassword = catchAsync(async (req, res, next) => {
  const { token } = req.params;
  const { password } = req.body;

  const resetPasswordToken = crypto
    .createHash('sha256')
    .update(token)
    .digest('hex');

  // Find The Hashed version
  const user = await User.findOne({
    resetPasswordToken,
    resetPasswordExpire: { $gt: Date.now() }
  });

  // Token expired or invalid token
  if (!user) {
    return next(
      new ErrorResponse('Invalid token maybe your time expired', 404)
    );
  }

  // Update user with new password
  user.password = password;
  user.resetPasswordToken = undefined;
  user.resetPasswordExpire = undefined;
  await user.save();
  res.status(200).json({ success: true });
});

/**
 * @route GET /api/auth/logout
 * @desc Returns the current user
 * @secure false
 */
exports.getCurrentUser = catchAsync(async (req, res, next) => {
  await isAuthenticated(req); // Injects req.user
  res.status(200).json({ success: true, data: req.user });
});

/**
 * @route GET /api/auth/logout
 * @desc let the user logout
 * @secure true
 */
exports.logout = catchAsync(async (req, res, next) => {
  res.status(200).json({ success: true });
});

// Creates a JWT Token and returns it
const sendTokenResponse = (user, statusCode, res) => {
  // Create token
  const token = user.getSignedJwtToken();
  // Remove password before sending
  user.password = undefined;

  res.status(statusCode).json({
    success: true,
    user,
    token
  });
};
