# Cinema App

A modern cinema booking application with a Flutter frontend and Node.js backend API.

## Project Structure

```
cinemaapp/
├── frontend/          # Flutter mobile application
└── backend/           # Node.js API server
```

## Features

- **Movie browsing and selection**
- **Seat selection and booking**
- **Food & beverage ordering**
- **Booking summary and confirmation**
- **Cross-platform support (iOS, Android, Web)**
- **RESTful API with data persistence**

## Tech Stack

### Frontend (Flutter)
- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **GetX** - State management and navigation
- **HTTP** - API communication
- **Intl** - Internationalization
- **Flutter Rating Bar** - Rating display component

### Backend (Node.js)
- **Node.js** - JavaScript runtime
- **Express.js** - Web application framework
- **Morgan** - HTTP request logger
- **Helmet** - Security middleware
- **CORS** - Cross-origin resource sharing
- **Express-validator** - Request validation
- **Winston** - Logging
- **Jest** - Testing framework
- **ESLint & Prettier** - Code quality tools

## Getting Started

### Prerequisites

- **Flutter SDK** (3.9.0 or higher)
- **Node.js** (18+ LTS recommended)
- **npm** (comes with Node.js)

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file with your environment variables:
   ```env
   NODE_ENV=development
   PORT=3000
   CORS_ORIGIN=*
   ```

4. Start the development server:
   ```bash
   npm run dev
   ```

The API will be available at `http://localhost:3000`

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd frontend
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

## API Endpoints

### Movies
- `GET /api/movies` - Get all movies
- `GET /api/movies/:id` - Get a single movie by ID

### Food & Beverages
- `GET /api/food-beverages` - Get all food and beverage items
- `GET /api/food-beverages/:id` - Get a single food/beverage item by ID

## Development Scripts

### Backend
- `npm start` - Start production server
- `npm run dev` - Start development server with hot-reload
- `npm test` - Run tests
- `npm run lint` - Run ESLint
- `npm run format` - Format code with Prettier

### Frontend
- `flutter run` - Run the application
- `flutter test` - Run tests
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app

## Project Structure Details

### Backend Structure
```
backend/
├── src/
│   ├── config/           # Configuration files
│   ├── controllers/      # Route controllers
│   ├── middlewares/      # Custom middlewares
│   ├── routes/          # API routes
│   ├── services/        # Business logic
│   ├── utils/           # Utility functions
│   └── index.js         # Application entry point
├── data/                # Sample data files
└── test/                # Test files
```

### Frontend Structure
```
frontend/
├── lib/
│   ├── screens/         # Screen components
│   ├── widgets/         # Reusable widgets
│   ├── models/          # Data models
│   ├── services/        # API services
│   └── utils/           # Utility functions
├── assets/              # Images and assets
└── test/                # Test files
```

## Environment Variables

### Backend
Create a `.env` file in the backend directory:
```env
NODE_ENV=development
PORT=3000
CORS_ORIGIN=*
```

## Contributing

1. Fork the repository
2. Create a new branch for your feature:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add your feature description"
   ```
4. Push to the branch:
   ```bash
   git push origin feature/your-feature-name
   ```
5. Create a new Pull Request

## License

This project is licensed under the ISC License.

## Support

For support and questions, please open an issue in the repository.