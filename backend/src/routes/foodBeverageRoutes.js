const express = require('express');
const router = express.Router();
const foodBeverageController = require('../controllers/foodBeverageController');
const { validateIdParam } = require('../middlewares/validation');

// GET /api/food-beverages - Get all food and beverage items
router.get('/', foodBeverageController.getFoodAndBeverages);

// GET /api/food-beverages/:id - Get a single food/beverage item by ID
router.get('/:id', validateIdParam, foodBeverageController.getFoodAndBeverageById);

module.exports = router;
