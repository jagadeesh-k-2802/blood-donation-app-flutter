const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notification');
const { protect } = require('../middlewares/auth');

router.get('/', protect, notificationController.getAllNotifications);
router.get('/count', protect, notificationController.getUnreadCount);

module.exports = router;
