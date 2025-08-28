const logger = require('../config/logger');
const { NODE_ENV } = require('../config');

class ApiError extends Error {
  constructor(statusCode, message, isOperational = true, stack = '') {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational;
    if (stack) {
      this.stack = stack;
    } else {
      Error.captureStackTrace(this, this.constructor);
    }
  }
}

const errorHandler = (err, req, res, next) => {
  let { statusCode = 500, message } = err;
  
  // Log the error
  logger.error(`Error: ${err.message}`, {
    statusCode,
    stack: err.stack,
    path: req.path,
    method: req.method,
  });

  // Don't leak error details in production
  if (NODE_ENV === 'production' && !err.isOperational) {
    message = 'An unexpected error occurred';
  }

  // Send response
  res.status(statusCode).json({
    status: 'error',
    statusCode,
    message,
    ...(NODE_ENV === 'development' && { stack: err.stack })
  });
};

const notFound = (req, res, next) => {
  const error = new Error(`Not Found - ${req.originalUrl}`);
  res.status(404);
  next(error);
};

module.exports = {
  errorHandler,
  notFound,
  ApiError
};
