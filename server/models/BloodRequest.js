const mongoose = require('mongoose');

const BloodRequest = new mongoose.Schema(
  {
    patientName: {
      type: String,
      required: [true, 'Patient Name is required']
    },
    age: {
      type: String,
      required: [true, 'Age is required']
    },
    bloodType: {
      type: String,
      required: [true, 'Blood Type is required']
    },
    status: {
      type: String,
      default: 'active',
      enum: ['active', 'pending', 'accepted', 'completed']
    },
    location: {
      type: String,
      maxlength: 120,
      required: [true, 'Location is required']
    },
    locationCoordinates: {
      type: {
        type: String,
        enum: ['Point']
      },
      coordinates: {
        type: [Number],
        index: '2dsphere'
      }
    },
    contactNumber: {
      type: String,
      maxlength: 120,
      required: [true, 'Contact Number is required']
    },
    unitsRequired: {
      type: Number,
      max: [10, 'Maximum units can be only 10'],
      required: [true, 'Contact Number is required']
    },
    timeUntil: {
      type: Date,
      required: [true, 'Please select time until']
    },
    notes: {
      type: String,
      maxlength: 500,
      default: ''
    },
    createdBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    acceptedBy: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
    createdAt: { type: Date, default: Date.now }
  },
  { toJSON: { virtuals: true } }
);

BloodRequest.index({ locationCoordinates: '2dsphere' });
module.exports = mongoose.model('BloodRequest', BloodRequest, 'blood-requests');
