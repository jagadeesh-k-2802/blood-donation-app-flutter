const mv = require('mv');
const path = require('path');
const crypto = require('crypto');
const { formidable } = require('formidable');
const User = require('../models/User');
const catchAsync = require('../utils/catchAsync');
const ErrorResponse = require('../utils/errorResponse');
const Email = require('../utils/email');
const { isAuthenticated } = require('../middlewares/auth');
const { bytesToMB } = require('../utils/functions');

/**
 * @route POST /api/auth/login
 * @desc let the user login
 * @secure false
 */
exports.login = catchAsync(async (req, res, next) => {
  const { email, password, fcmToken } = req.body;

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

  await User.findByIdAndUpdate(user.id, { fcmToken });
  sendTokenResponse(user, 200, res);
});

/**
 * @route POST /api/auth/register
 * @desc let the user register
 * @secure false
 */
exports.register = catchAsync(async (req, res) => {
  const {
    name,
    avatar = 'default-avatar.jpg',
    email,
    password,
    phone,
    bloodType,
    address,
    coordinates,
    fcmToken
  } = req.body;

  const user = await User.create({
    name: name,
    avatar,
    email: email,
    phone: phone,
    address: address,
    locationCoordinates: {
      type: 'Point',
      coordinates: coordinates.reverse()
    },
    fcmToken: fcmToken,
    bloodType: bloodType,
    password: password
  });

  await new Email(user, {}).sendWelcome();
  sendTokenResponse(user, 200, res);
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
  const user = req.user;
  await User.findByIdAndUpdate(user.id, { fcmToken: null });

  res.status(200).json({
    success: true,
    message: 'Logout Sucessful'
  });
});

/**
 * @route POST /api/auth/update-details
 * @desc Let a user update their details
 * @secure true
 */
exports.updateDetails = catchAsync(async (req, res, next) => {
  const { name, email, phone, bloodType, address, coordinates } = req.body;
  const user = req.user;

  let fieldsToUpdate = {
    name,
    email,
    phone,
    bloodType,
    address
  };

  if (coordinates.length > 0) {
    fieldsToUpdate = {
      ...fieldsToUpdate,
      locationCoordinates: {
        type: 'Point',
        coordinates: coordinates.reverse()
      }
    };
  }

  await User.findByIdAndUpdate(user.id, fieldsToUpdate, {
    new: true,
    runValidators: true
  });

  res.status(200).json({
    success: true,
    message: 'Profile Details Updated Sucessfully'
  });
});

/**
 * @route POST /api/auth/update-password
 * @desc Let a user update their password
 * @secure true
 */
exports.updatePassword = catchAsync(async (req, res, next) => {
  const { currentPassword, newPassword } = req.body;
  const user = await User.findById(req.user.id).select('+password');

  // Check current password
  if (!(await user.matchPassword(currentPassword))) {
    return next(new ErrorResponse('Password is incorrect', 401));
  }

  // Check whether new password matches current password
  if (await user.matchPassword(newPassword)) {
    return next(
      new ErrorResponse(
        'This password is already in use, Kindly create another one',
        401
      )
    );
  }

  user.password = newPassword;
  await user.save();
  sendTokenResponse(user, 200, res);
});

/**
 * @route POST /api/auth/update-avatar
 * @desc Let a user update their profile picture
 * @secure true
 */
exports.updateAvatar = catchAsync(async (req, res, next) => {
  const form = formidable();
  const user = req.user;
  const filename = `${user.name.replace(' ', '-')}.jpg`;

  // Move The File From Temp To Avatar Dir
  const moveFromTemp = async file => {
    try {
      const dest = path.join(__dirname, '../public/avatar', filename);
      mv(file.avatar[0].filepath, dest, { mkdirp: true }, err => {});
    } catch (err) {
      next(err);
    }
  };

  // Parse form
  form.parse(req, async (err, fields, file) => {
    const size = bytesToMB(file.avatar[0].size);

    if (size > 3) {
      return next(
        new ErrorResponse('File size cannot be greater than 3 MB', 401)
      );
    }

    if (err) {
      return next(err);
    }

    moveFromTemp(file);
    const fieldsToUpdate = { avatar: filename };

    // Update user in DB
    await User.findByIdAndUpdate(user.id, fieldsToUpdate, {
      new: true,
      runValidators: true
    });

    res.status(200).json({
      success: true,
      message: 'Profile Photo Updated Sucessfully'
    });
  });
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
  await new Email(user, { otp: token }).sendPasswordReset();

  try {
    res.status(200).json({
      success: true,
      message: 'Password reset OTP sent to your E-mail ID'
    });
  } catch (err) {
    user.resetPasswordToken = undefined;
    user.resetPasswordExpire = undefined;
    await user.save();
    return next(new ErrorResponse('Could not send email', 500));
  }

  await user.save();
});

/**
 * @route POST /api/auth/reset-password/
 * @desc Resets a user's password when requested with right reset token
 * @secure false
 */
exports.resetPassword = catchAsync(async (req, res, next) => {
  const { token, password } = req.body;

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
    return next(new ErrorResponse('Invalid or Expired OTP', 404));
  }

  // Update user with new password
  user.password = password;
  user.resetPasswordToken = undefined;
  user.resetPasswordExpire = undefined;
  await user.save();

  res.status(200).json({
    success: true,
    message: 'Password has been changed, Use your new password to login'
  });
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
