const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth');
const { protect } = require('../middlewares/auth');

router.post('/login', authController.login);
router.post('/register', authController.register);
router.post('/update-details', protect, authController.updateDetails);
router.post('/update-password', protect, authController.updatePassword);
router.post('/update-avatar', protect, authController.updateAvatar);
router.post('/forgot-password', authController.forgotPassword);
router.post('/reset-password', authController.resetPassword);
router.get('/me', authController.getCurrentUser);
router.get('/logout', protect, authController.logout);

module.exports = router;
