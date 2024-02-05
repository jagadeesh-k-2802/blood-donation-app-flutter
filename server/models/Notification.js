const mongoose = require('mongoose');

const Notification = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, 'Title is required']
    },
    description: {
      type: String,
      maxlength: 300,
      default: ''
    },
    read: {
      type: Boolean,
      default: false
    },
    notificationType: {
      type: String,
      enum: [
        'message',
        'donation-request',
        'donation-accepted',
        'donation-completed',
        'nearby-donation-request'
      ],
      default: 'message'
    },
    itemId: {
      type: String
    },
    profileId: {
      type: String,
      default: ''
    },
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    createdAt: { type: Date, default: Date.now }
  },
  { toJSON: { virtuals: true } }
);

module.exports = mongoose.model('Notification', Notification);
