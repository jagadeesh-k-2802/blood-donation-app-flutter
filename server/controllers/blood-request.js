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
 * @route GET /api/blood-request/:id
 * @desc Get one blood request by its ID
 * @secure true
 */
exports.getBloodRequest = catchAsync(async (req, res, next) => {
  const { id } = req.params;

  const request = await BloodRequest.findById(id)
    .populate('createdBy')
    .populate('acceptedBy');

  res.json({ success: true, data: request });
});

/**
 * @route GET /api/blood-request/nearby
 * @desc Get blood requests that are nearby to user
 * @secure true
 */
exports.getBloodRequestsNearby = catchAsync(async (req, res, next) => {
  const user = req.user;
  const userCoordinates = user.locationCoordinates.coordinates;
  const searchRadiusInKilometres = 1500 / 3963.2;
  const limit = 30;

  const bloodRequests = await BloodRequest.find({
    locationCoordinates: {
      $geoWithin: {
        $centerSphere: [userCoordinates, searchRadiusInKilometres]
      }
    },
    timeUntil: { $gte: Date.now() },
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
    timeUntil,
    notes
  } = req.body;

  const user = req.user;

  const bloodRequest = await BloodRequest.create({
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
    timeUntil: new Date(timeUntil),
    notes,
    createdBy: user.id
  });

  res.status(200).json({
    success: true,
    data: { id: bloodRequest.id }
  });
});

/**
 * @route PUT /api/blood-request/:id
 * @desc Update a blood request
 * @secure true
 */
exports.updateBloodRequest = catchAsync(async (req, res, next) => {
  const {
    patientName,
    age,
    bloodType,
    location,
    coordinates,
    contactNumber,
    unitsRequired,
    timeUntil,
    notes
  } = req.body;

  const { id } = req.params;

  await BloodRequest.updateOne(
    { id: id },
    {
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
      timeUntil: new Date(timeUntil),
      notes
    }
  );

  res.status(200).json({
    success: true,
    message: 'Request Updated Successfully.'
  });
});
