const BloodRequest = require('../models/BloodRequest');
const Notification = require('../models/Notification');
const catchAsync = require('../utils/catchAsync');
const ErrorResponse = require('../utils/errorResponse');

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

  res.status(200).json({ success: true, data: requests });
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

  res.status(200).json({ success: true, data: request });
});

/**
 * @route GET /api/blood-request/nearby
 * @desc Get blood requests that are nearby to user
 * @secure true
 */
exports.getBloodRequestsNearby = catchAsync(async (req, res, next) => {
  const user = req.user;
  const userCoordinates = user.locationCoordinates.coordinates;
  const searchRadiusInKilometres = 100 / 6378.1;
  const limit = 30;

  const bloodRequests = await BloodRequest.find({
    locationCoordinates: {
      $geoWithin: {
        $centerSphere: [userCoordinates, searchRadiusInKilometres]
      }
    },
    status: { $eq: 'active' },
    timeUntil: { $gte: Date.now() },
    createdBy: { $ne: user.id }
  }).limit(limit);

  res.status(200).json({ success: true, data: bloodRequests });
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
    acceptedBy: { $eq: userId },
    status: { $eq: 'completed' }
  });

  const data = {
    totalRequests: userBloodRequestsCount,
    totalDonated: userBloodDonatedCount
  };

  return res.status(200).json({ success: true, data });
});

/**
 * @route GET /api/blood-request/donate/:id
 * @desc Get Stats about blood requests
 * @secure true
 */
exports.donateRequest = catchAsync(async (req, res, next) => {
  const { id } = req.params;
  const user = req.user;

  const bloodRequest = await BloodRequest.findById(id)
    .populate('createdBy')
    .populate('acceptedBy');

  if (!bloodRequest) {
    return next(new ErrorResponse('Blood request not found', 404));
  }

  if (bloodRequest.createdBy === user.id) {
    return next(new ErrorResponse('Cannot donate to your own request', 401));
  }

  await BloodRequest.findByIdAndUpdate(id, {
    acceptedBy: user.id,
    status: 'pending'
  });

  await Notification.create({
    title: 'New Donate Request',
    description: `${user.name} has accepted to donate for ${bloodRequest.patientName}`,
    notificationType: 'donation-request',
    data: bloodRequest.id,
    user: bloodRequest.createdBy
  });

  // TODO: Send Push Notificaton to User about New Request

  res
    .status(200)
    .json({ success: true, message: 'Donate request sent sucessfully' });
});

/**
 * @route GET /api/blood-request/complete/:id
 * @desc Complete a blood request
 * @secure true
 */
exports.completeRequest = catchAsync(async (req, res, next) => {
  const { id } = req.params;
  const { coordinates } = req.body;
  const user = req.user;
  const searchRadiusInKilometres = 0.4 / 6378.1;

  const bloodRequest = await BloodRequest.findById(id)
    .populate('createdBy')
    .populate('acceptedBy');

  if (!bloodRequest) {
    return next(new ErrorResponse('Blood request not found', 404));
  }

  const isUserWithinLocation = await BloodRequest.exists({
    id: id,
    locationCoordinates: {
      $geoWithin: {
        $centerSphere: [coordinates.reverse(), searchRadiusInKilometres]
      }
    }
  });

  if (!isUserWithinLocation) {
    return next(
      new ErrorResponse('Please be near the hospital to complete request', 401)
    );
  }

  // TODO: Send Push Notification

  await Notification.create({
    title: 'Donation Completed Successfully',
    description: `your request for ${bloodRequest.patientName} has been sucessfully served.`,
    user: bloodRequest.createdBy
  });

  await BloodRequest.findByIdAndUpdate(id, { status: 'completed' });

  res.status(200).json({
    success: true,
    message: 'Donation Completed Sucessfully'
  });
});

/**
 * @route PUT /api/blood-request/reply/:id
 * @desc Accept or reject a donate request
 * @secure true
 */
exports.replyToRequest = catchAsync(async (req, res, next) => {
  const { accept, notificationId } = req.body;
  const { id } = req.params;
  const user = req.user;

  const bloodRequest = await BloodRequest.findById(id)
    .populate('createdBy')
    .populate('acceptedBy');

  if (!bloodRequest) {
    return next(new ErrorResponse('Blood request not found', 404));
  }

  // TODO: Send Push Notificaton to User about Request Accept/Reject
  if (accept) {
    await Notification.create({
      title: 'Donate Request Accepted',
      description: `your donate request for ${bloodRequest.patientName} has been accepted`,
      user: bloodRequest.acceptedBy
    });

    await Notification.findByIdAndUpdate(notificationId, {
      description: `You have Accepted donation request from ${bloodRequest.acceptedBy.name}`,
      notificationType: 'donation-accepted',
      data: bloodRequest.id
    });

    await BloodRequest.findByIdAndUpdate(id, {
      acceptedBy: user.id,
      status: 'accepted'
    });
  } else {
    await Notification.create({
      title: 'Donate Request Rejected',
      description: `your donate request for ${bloodRequest.patientName} has been rejected`,
      user: bloodRequest.acceptedBy
    });

    await Notification.findByIdAndUpdate(notificationId, {
      description: `You have rejected donation request from ${bloodRequest.acceptedBy.name}`,
      notificationType: 'message'
    });

    await BloodRequest.findByIdAndUpdate(id, {
      acceptedBy: null,
      status: 'active'
    });
  }

  res.status(200).json({ success: true, message: 'Reply sent sucessfully' });
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

  await BloodRequest.findByIdAndUpdate(id, {
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
  });

  res.status(200).json({
    success: true,
    message: 'Request Updated Successfully.'
  });
});

/**
 * @route DELETE /api/blood-request/:id
 * @desc Delete a blood request
 * @secure true
 */
exports.deleteRequest = catchAsync(async (req, res, next) => {
  const { id } = req.params;
  const user = req.user;
  const bloodRequest = await BloodRequest.findById(id).populate('createdBy');

  if (!bloodRequest) {
    return next(new ErrorResponse('Blood request not found', 404));
  }

  if (bloodRequest.createdBy.id !== user.id) {
    return next(new ErrorResponse('Unauthorized Access', 401));
  }

  await BloodRequest.findByIdAndDelete(id);
  res
    .status(200)
    .json({ success: true, message: 'Blood request deleted sucessfully' });
});
