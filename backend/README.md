# Cinema Fake Backend (Node.js + JSON files)

A simple Express server that serves movies, showtimes, and cinema hall seat maps. It supports seat holds and booking with optimistic concurrency and exposes polling-friendly endpoints by returning a `version` for each hall+showtime seat map.

Data is stored in JSON files under `data/`.

## Endpoints

- `GET /api/health`
- `GET /api/movies`
- `GET /api/movies/:id`
- `GET /api/showtimes?movieId=...` (optional filter by `movieId`)
- `GET /api/showtimes/:id`
- `GET /api/halls/:hallId/seatmap?showtimeId=...`
  - Returns `{ version, layout: { rows, cols }, seats: { A1: { id, status }, ... } }`
  - `status` is `available`, `held`, or `booked`
- `POST /api/reserve`
  - Body for hold:
    ```json
    { "action": "hold", "showtimeId": "s1", "hallId": "h1", "seats": ["A1","A2"] }
    ```
    Response: `{ reservation: { id, status: "held", expiresAt, ... } }`
  - Body for confirm:
    ```json
    { "action": "confirm", "reservationId": "<id>", "showtimeId": "s1", "hallId": "h1", "seats": ["A1","A2"] }
    ```
  - Body for release:
    ```json
    { "action": "release", "reservationId": "<id>", "showtimeId": "s1", "hallId": "h1", "seats": ["A1","A2"] }
    ```

Notes:
- Holds expire automatically after 2 minutes and are pruned every 15 seconds.
- Each change to a seat map bumps a `{showtimeId}:{hallId}` version. Clients can poll and compare version numbers to update the UI.

## Run locally

Requirements: Node.js 18+

```bash
# Install
npm install

# Start (http://localhost:4000)
npm start
```

## Data files

- `data/movies.json`
- `data/showtimes.json`
- `data/halls.json`
- `data/reservations.json`
- `data/seat_versions.json`

You can edit the seed files and restart the server.
