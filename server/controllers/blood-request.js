const BloodRequest = require('../models/BloodRequest');
const catchAsync = require('../utils/catchAsync');

/**
 * @route GET /api/blood-request
 * @desc Get all blood requests paginated and filter by type
 * @secure true
 */
exports.getBloodRequests = catchAsync(async (req, res, next) => {
  const { page = 1, limit = 10 } = req.query;
  const user = req.user;
  const query = { $or: [{ createdBy: user.id }, { acceptedBy: user.id }] };

  const requests = await BloodRequest.find(query)
    .skip((page - 1) * limit)
    .sort({ createdAt: -1 })
    .limit(limit);

  res.json({ success: true, data: requests });
});

/**
 * @route GET /api/blood-request/nearby
 * @desc Get blood requests that are nearby to user
 * @secure true
 */
exports.getBloodRequestsNearby = catchAsync(async (req, res, next) => {
  const user = req.user;
  const userCoordinates = user.locationCoordinates.coordinates;
  const searchRadiusInKilometres = 1000 / 3963.2;
  const limit = 30;

  const bloodRequests = await BloodRequest.find({
    locationCoordinates: {
      $geoWithin: {
        $centerSphere: [userCoordinates, searchRadiusInKilometres]
      }
    },
    createdBy: { $ne: user.id }
  }).limit(limit);

  res.json({ success: true, data: bloodRequests });
});

/**
 * @route POST /api/blood-request/stats
 * @desc Get Stats about blood requests
 * @secure true
 */
exports.getBloodRequestStats = catchAsync(async (req, res, next) => {
  const userId = req.user.id;

  const userBloodRequestsCount = await BloodRequest.count({
    createdBy: { $eq: userId }
  });

  const userBloodDonatedCount = await BloodRequest.count({
    acceptedBy: { $eq: userId }
  });

  const data = {
    totalRequests: userBloodRequestsCount,
    totalDonated: userBloodDonatedCount
  };

  return res.json({ success: true, data });
});

/**
 * @route POST /api/blood-request
 * @desc Create a new blood request
 * @secure true
 */
exports.createBloodRequest = catchAsync(async (req, res, next) => {
  const {
    patientName,
    age,
    bloodType,
    location,
    coordinates,
    contactNumber,
    unitsRequired,
    notes
  } = req.body;

  const user = req.user;

  await BloodRequest.create({
    patientName,
    age,
    bloodType,
    location,
    locationCoordinates: {
      type: 'Point',
      coordinates: coordinates.reverse()
    },
    contactNumber,
    unitsRequired,
    notes,
    createdBy: user
  });

  res.status(200).json({
    success: true,
    message: 'Request Submitted Successfully.'
  });
});
