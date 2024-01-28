const ErrorResponse = require('../utils/errorResponse');

const errorHandler = (err, req, res, next) => {
  console.log(err.message.red);

  let error = { ...err };
  error.message = err.message;

  // Bad ObjectId For Mongoose
  if (error.kind === 'ObjectId') {
    const message = `Resource not found`;
    error = new ErrorResponse(message, 404);
  }

  // Mongoose Duplicate Key
  if (err.code === 11000) {
    const message = `${JSON.stringify(error.keyValue)} already exists`;
    error = new ErrorResponse(message, 400);
  }

  // Mongoose Validation Error
  if (err.name === 'ValidationError') {
    const message = Object.values(err.errors)
      .map(val => val.message)
      .toString();

    error = new ErrorResponse(message, 400);
  }

  const statusCode = error.statusCode ?? 500;
  const errorMsg = error.message ?? 'Internal Server Error';
  res.status(statusCode).json({ success: false, error: errorMsg });
};

module.exports = errorHandler;
