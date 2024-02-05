const express = require('express');
const router = express.Router();
const bloodRequestController = require('../controllers/blood-request');
const { protect } = require('../middlewares/auth');

router.get('/', protect, bloodRequestController.getBloodRequests);
router.get('/nearby', protect, bloodRequestController.getBloodRequestsNearby);
router.get('/stats', protect, bloodRequestController.getBloodRequestStats);
router.get('/donate/:id', protect, bloodRequestController.donateRequest);
router.put('/reply/:id', protect, bloodRequestController.replyToRequest);
router.put('/complete/:id', protect, bloodRequestController.completeRequest);
router.get('/:id', protect, bloodRequestController.getBloodRequest);
router.post('/', protect, bloodRequestController.createBloodRequest);
router.post('/rate/:id', protect, bloodRequestController.createRating);
router.put('/:id', protect, bloodRequestController.updateBloodRequest);
router.delete('/:id', protect, bloodRequestController.deleteBloodRequest);

module.exports = router;
