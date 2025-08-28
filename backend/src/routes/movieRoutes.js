const express = require('express');
const router = express.Router();
const movieController = require('../controllers/movieController');
const { validateIdParam } = require('../middlewares/validation');

// GET /api/movies - Get all movies
router.get('/', movieController.getMovies);

// GET /api/movies/:id - Get a single movie by ID
router.get('/:id', validateIdParam, movieController.getMovieById);

module.exports = router;
