# Cinema Backend API

A RESTful API for managing movies and food/beverage items for a cinema application.

## Features

- RESTful API endpoints
- Error handling middleware
- Request validation
- Logging
- Environment configuration
- Security best practices (Helmet, CORS)
- Development tools (Nodemon, ESLint, Prettier)

## Getting Started

### Prerequisites

- Node.js 18+ (LTS recommended)
- npm (comes with Node.js)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file in the root directory and add your environment variables (use `.env.example` as a reference)

### Available Scripts

- `npm start` - Start the production server
- `npm run dev` - Start the development server with hot-reload
- `npm test` - Run tests
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier

## API Endpoints

### Movies

- `GET /api/movies` - Get all movies
- `GET /api/movies/:id` - Get a single movie by ID

### Food & Beverages

- `GET /api/food-beverages` - Get all food and beverage items
- `GET /api/food-beverages/:id` - Get a single food/beverage item by ID

## Environment Variables

Create a `.env` file in the root directory with the following variables:

```
NODE_ENV=development
PORT=3000
CORS_ORIGIN=*
```

## Project Structure

```
src/
  ├── config/           # Configuration files
  ├── controllers/      # Route controllers
  ├── middlewares/      # Custom middlewares
  ├── routes/          # API routes
  ├── services/        # Business logic
  ├── utils/           # Utility classes and functions
  └── index.js         # Application entry point
```

## Contributing

1. Fork the repository
2. Create a new branch for your feature
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

ISC
