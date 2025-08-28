
const express = require('express');
const app = express();
const port = 3000;

const movies = require('./movies.json');
const foodAndBeverages = require('./foodAndBeverages.json');

app.get('/movies', (req, res) => {
  res.json(movies);
});

app.get('/food-beverages', (req, res) => {
  res.json(foodAndBeverages);
});

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
