const mongoose = require('mongoose');

const Rating = new mongoose.Schema(
  {
    rating: {
      type: Number,
      min: 1,
      max: 5,
      required: [true, 'rating is required']
    },
    review: {
      type: String,
      maxlength: 400,
      default: ''
    },
    itemId: { type: mongoose.Schema.Types.ObjectId, ref: 'BloodRequest' },
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    createdAt: { type: Date, default: Date.now }
  },
  { toJSON: { virtuals: true } }
);

module.exports = mongoose.model('Rating', Rating);
