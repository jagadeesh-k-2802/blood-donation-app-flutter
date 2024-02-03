const express = require('express');
const router = express.Router();
const bloodRequestControllers = require('../controllers/blood-request');
const { protect } = require('../middlewares/auth');

router.get('/', protect, bloodRequestControllers.getBloodRequests);
router.get('/nearby', protect, bloodRequestControllers.getBloodRequestsNearby);
router.get('/stats', protect, bloodRequestControllers.getBloodRequestStats);
router.get('/:id', protect, bloodRequestControllers.getBloodRequest);
router.post('/', protect, bloodRequestControllers.createBloodRequest);
router.put('/:id', protect, bloodRequestControllers.updateBloodRequest);

module.exports = router;
