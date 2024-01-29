const BloodRequest = require('../models/BloodRequest');
const catchAsync = require('../utils/catchAsync');

/**
 * @route POST /api/blood-request
 * @desc Create a new blood request
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
