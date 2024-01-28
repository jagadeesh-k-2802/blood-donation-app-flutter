const express = require('express');
const router = express.Router();
const authControllers = require('../controllers/auth');
const { protect } = require('../middlewares/auth');

router.post('/login', authControllers.login);
router.post('/register', authControllers.register);
router.post('/forgot-password', authControllers.forgotPassword);
router.post('/reset-password/:token', authControllers.resetPassword);
router.get('/me', authControllers.getCurrentUser);
router.get('/logout', protect, authControllers.logout);

module.exports = router;
