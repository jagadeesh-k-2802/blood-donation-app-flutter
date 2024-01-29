const express = require('express');
const router = express.Router();
const notificationControllers = require('../controllers/notification');
const { protect } = require('../middlewares/auth');

router.get('/', protect, notificationControllers.getAllNotifications);
router.get('/count', protect, notificationControllers.getUnreadCount);

module.exports = router;
