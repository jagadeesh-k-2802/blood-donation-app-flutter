const express = require('express');
const router = express.Router();
const authControllers = require('../controllers/auth');
const { protect } = require('../middlewares/auth');

router.post('/login', authControllers.login);
router.post('/register', authControllers.register);
router.post('/update-details', protect, authControllers.updateDetails);
router.post('/update-password', protect, authControllers.updatePassword);
router.post('/update-avatar', protect, authControllers.updateAvatar);
router.post('/forgot-password', authControllers.forgotPassword);
router.post('/reset-password', authControllers.resetPassword);
router.get('/me', authControllers.getCurrentUser);
router.get('/logout', protect, authControllers.logout);

module.exports = router;
