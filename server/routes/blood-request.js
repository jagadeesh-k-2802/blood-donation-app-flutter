const express = require('express');
const router = express.Router();
const bloodRequestControllers = require('../controllers/blood-request');
const { protect } = require('../middlewares/auth');

router.get('/', protect, bloodRequestControllers.getBloodRequests);
router.get('/nearby', protect, bloodRequestControllers.getBloodRequestsNearby);
router.get('/stats', protect, bloodRequestControllers.getBloodRequestStats);
router.get('/donate/:id', protect, bloodRequestControllers.donateRequest);
router.put('/reply/:id', protect, bloodRequestControllers.replyToRequest);
router.put('/complete/:id', protect, bloodRequestControllers.completeRequest);
router.get('/:id', protect, bloodRequestControllers.getBloodRequest);
router.post('/', protect, bloodRequestControllers.createBloodRequest);
router.put('/:id', protect, bloodRequestControllers.updateBloodRequest);
router.delete('/:id', protect, bloodRequestControllers.deleteRequest);

module.exports = router;
