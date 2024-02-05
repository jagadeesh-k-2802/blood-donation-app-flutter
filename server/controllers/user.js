const mongoose = require('mongoose');
const Rating = require('../models/Rating');
const BloodRequest = require('../models/BloodRequest');
const User = require('../models/User');
const catchAsync = require('../utils/catchAsync');
const ErrorResponse = require('../utils/errorResponse');

/**
 * @route GET /api/user/:id
 * @desc Get a user with their stats
 * @secure true
 */
exports.getProfile = catchAsync(async (req, res, next) => {
  const { id } = req.params;
  const user = await User.findById(id).lean();

  if (!user) {
    return next(new ErrorResponse('User not found', 404));
  }

  const userBloodRequestsCount = await BloodRequest.count({
    createdBy: { $eq: user._id }
  });

  const userBloodDonatedCount = await BloodRequest.count({
    acceptedBy: { $eq: user._id },
    status: { $eq: 'completed' }
  });

  const reviews = await Rating.find({ user: user._id })
    .populate('createdBy')
    .lean();

  const averageRating = await Rating.aggregate([
    {
      $match: { user: mongoose.Types.ObjectId(user._id) }
    },
    {
      $group: {
        _id: null,
        averageRating: { $avg: '$rating' }
      }
    }
  ]);

  const data = {
    totalRequests: userBloodRequestsCount,
    totalDonated: userBloodDonatedCount,
    averageRating: averageRating.length > 0 ? averageRating[0].averageRating : 0
  };

  res.status(200).json({
    success: true,
    data: { ...data, ...user, reviews }
  });
});
