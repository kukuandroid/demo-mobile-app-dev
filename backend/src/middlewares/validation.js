const { validationResult } = require('express-validator');
const { ApiError } = require('./errorHandler');

const validateRequest = (req, res, next) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    throw new ApiError(400, 'Validation failed', true, errors.array());
  }
  next();
};

const validateIdParam = (req, res, next) => {
  const id = parseInt(req.params.id);
  if (isNaN(id) || id <= 0) {
    throw new ApiError(400, 'Invalid ID parameter', true);
  }
  next();
};

module.exports = {
  validateRequest,
  validateIdParam
};
