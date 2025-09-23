const express = require('express');
const router = express.Router();
const cinemaController = require('../controllers/cinemaController');

// GET /api/cinemas - Get all cinema locations
router.get('/', cinemaController.getAllCinemas);

// GET /api/cinemas/city/:city - Get cinemas by city
router.get('/city/:city', cinemaController.getCinemasByCity);

module.exports = router;