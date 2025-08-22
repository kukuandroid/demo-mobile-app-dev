# HOWTO

1. Thoroughly document your code with clear comments and explanations.
2. Contain both the frontend and backend repositories.
3. To run the backend:
   - Navigate to the backend directory: `cd backend`
   - Install dependencies: `npm install`
   - Start the server: `npm start`
   - The backend will run at `http://localhost:4000`
4. To run the frontend in simulator mode:
   - Navigate to the frontend directory: `cd frontend`
   - Install dependencies: `flutter pub get`
   - For Android Studio:
     - Open the project and launch an Android emulator.
     - Run: `flutter run`
   - For Xcode:
     - Open the project in Xcode and launch an iOS simulator.
     - Run: `flutter run`
   - Ensure the frontend is configured to communicate with the backend at `http://localhost:4000`
