const movies = require('../../movies.json');
const logger = require('../config/logger');

const getMovies = (req, res, next) => {
  try {
    logger.info('Fetching all movies');
    res.json({
      status: 'success',
      results: movies.length,
      data: {
        movies
      }
    });
  } catch (error) {
    next(error);
  }
};

const getMovieById = (req, res, next) => {
  try {
    const movie = movies.find(m => m.id === parseInt(req.params.id));
    
    if (!movie) {
      const error = new Error('Movie not found');
      error.statusCode = 404;
      throw error;
    }
    
    logger.info(`Fetching movie with ID: ${req.params.id}`);
    res.json({
      status: 'success',
      data: {
        movie
      }
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getMovies,
  getMovieById
};
