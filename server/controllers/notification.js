const Notification = require('../models/Notification');
const catchAsync = require('../utils/catchAsync');

/**
 * @route POST /api/notification/
 * @desc Get All Notifications
 * @secure true
 */
exports.getAllNotifications = catchAsync(async (req, res, next) => {
  const { page = 1, limit = 10 } = req.query;
  const user = req.user;
  const query = { user: user.id };

  const notifications = await Notification.find(query)
    .skip((page - 1) * limit)
    .sort({ createdAt: -1 })
    .limit(limit);

  await Notification.updateMany(
    query,
    { read: true },
    { limit, skip: (page - 1) * limit, sort: { createdAt: -1 } }
  );

  res.status(200).json({ success: true, data: notifications });
});

/**
 * @route POST /api/notification/count
 * @desc Get Unread Notifications count
 * @secure true
 */
exports.getUnreadCount = catchAsync(async (req, res, next) => {
  const user = req.user;
  const query = { user: user.id, read: false };
  const count = await Notification.find(query).count();
  res.status(200).json({ success: true, data: { count } });
});
