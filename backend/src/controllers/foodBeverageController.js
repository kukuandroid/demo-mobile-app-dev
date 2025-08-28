const foodAndBeverages = require('../../foodAndBeverages.json');
const logger = require('../config/logger');

const getFoodAndBeverages = (req, res, next) => {
  try {
    logger.info('Fetching all food and beverages');
    res.json({
      status: 'success',
      results: foodAndBeverages.length,
      data: {
        items: foodAndBeverages
      }
    });
  } catch (error) {
    next(error);
  }
};

const getFoodAndBeverageById = (req, res, next) => {
  try {
    const item = foodAndBeverages.find(item => item.id === parseInt(req.params.id));
    
    if (!item) {
      const error = new Error('Food or beverage item not found');
      error.statusCode = 404;
      throw error;
    }
    
    logger.info(`Fetching food/beverage item with ID: ${req.params.id}`);
    res.json({
      status: 'success',
      data: {
        item
      }
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getFoodAndBeverages,
  getFoodAndBeverageById
};
