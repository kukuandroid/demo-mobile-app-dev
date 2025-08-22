# Flutter Cinema Booking (MVVM, feature-based)

This Flutter app consumes the fake backend in `../backend` and demonstrates a complete booking flow:

1. Movies list with showtimes
2. Seat selection with real-time updates via polling
3. Food & Beverages selection
4. Mock payment and confirmation

Architecture: MVVM using Provider, feature-based folders under `lib/src/features/`.

## Prereqs
- Flutter SDK 3.22+ (Dart 3.3+)
- Backend running at `http://localhost:4000`

## First-time setup
This repo contains only the `lib/` and `pubspec.yaml`. Generate platform folders and fetch packages:

```bash
# from frontend/
flutter create .
flutter pub get
```

If running on a real device or emulator that does not resolve `localhost` to your Dev machine, set the base URL in `lib/src/core/config.dart` to your machine IP, e.g. `http://192.168.1.10:4000`.

## Run
```bash
flutter run
```

## Structure
- `lib/src/core/` shared config and API client
- `lib/src/features/movies/` list screen, models, service, viewmodel
- `lib/src/features/booking/` seat map models/service/viewmodel and screen
- `lib/src/features/fnb/` local-only mock F&B
- `lib/src/features/payment/` mock payment

## Polling behavior
- `BookingViewModel` refreshes the seat map every 2s via `BookingService.fetchSeatMap()`.
- The backend returns a `version` per hall+showtime; the sample app refreshes always for simplicity. You can optimize by skipping UI updates if version unchanged.
