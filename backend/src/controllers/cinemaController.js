const fs = require('fs').promises;
const path = require('path');
const cinemas = require('../../data/cinema_location.json');

const getAllCinemas = async (req, res) => {
  try {
    res.status(200).json({
      status: 'success',
      data: {
        cinemas
      }
    });
  } catch (error) {
    console.error('Error reading cinema locations:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch cinema locations'
    });
  }
};

const getCinemasByCity = async (req, res) => {
  try {
    const { city } = req.params;


    const filteredCinemas = cinemas.filter(cinema =>
      cinema.city.toLowerCase() === city.toLowerCase()
    );

    res.status(200).json({
      status: 'success',
      data: {
        cinemas: filteredCinemas
      }
    });
  } catch (error) {
    console.error('Error filtering cinemas by city:', error);
    res.status(500).json({
      status: 'error',
      message: 'Failed to fetch cinemas for the specified city'
    });
  }
};

module.exports = {
  getAllCinemas,
  getCinemasByCity
};