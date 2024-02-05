const express = require('express');
const router = express.Router();
const userController = require('../controllers/user');
const { protect } = require('../middlewares/auth');

router.get('/:id', protect, userController.getProfile);

module.exports = router;
