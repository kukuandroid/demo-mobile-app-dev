import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import { nanoid } from 'nanoid';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

const DATA_DIR = path.join(__dirname, 'data');
const FILES = {
  movies: path.join(DATA_DIR, 'movies.json'),
  showtimes: path.join(DATA_DIR, 'showtimes.json'),
  halls: path.join(DATA_DIR, 'halls.json'),
  reservations: path.join(DATA_DIR, 'reservations.json'),
  versions: path.join(DATA_DIR, 'seat_versions.json')
};

async function ensureDataDir() {
  await fs.mkdir(DATA_DIR, { recursive: true });
}

async function readJson(file, fallback) {
  try {
    const raw = await fs.readFile(file, 'utf-8');
    return JSON.parse(raw);
  } catch (e) {
    if (fallback !== undefined) return fallback;
    throw e;
  }
}

async function writeJson(file, data) {
  await fs.writeFile(file, JSON.stringify(data, null, 2));
}

function seatIdFrom(rowIndex, colIndex) {
  const rowChar = String.fromCharCode('A'.charCodeAt(0) + rowIndex);
  return `${rowChar}${colIndex + 1}`;
}

function makeSeatIds(rows, cols) {
  const ids = [];
  for (let r = 0; r < rows; r++) {
    for (let c = 0; c < cols; c++) {
      ids.push(seatIdFrom(r, c));
    }
  }
  return ids;
}

function now() {
  return Date.now();
}

function isExpired(res) {
  return res.status === 'held' && res.expiresAt && res.expiresAt <= now();
}

async function loadState() {
  await ensureDataDir();
  const [movies, showtimes, halls, reservations, versions] = await Promise.all([
    readJson(FILES.movies, []),
    readJson(FILES.showtimes, []),
    readJson(FILES.halls, []),
    readJson(FILES.reservations, []),
    readJson(FILES.versions, {})
  ]);
  return { movies, showtimes, halls, reservations, versions };
}

async function saveReservations(reservations) {
  await writeJson(FILES.reservations, reservations);
}

async function saveVersions(versions) {
  await writeJson(FILES.versions, versions);
}

function idxById(arr) {
  const map = new Map();
  arr.forEach((item, idx) => map.set(item.id, idx));
  return map;
}

function getHall(halls, hallId) {
  return halls.find(h => h.id === hallId);
}

function computeSeatMapForShowtime({ halls, hallId, showtimeId, reservations }) {
  const hall = getHall(halls, hallId);
  if (!hall) throw new Error('Hall not found');
  const { rows, cols } = hall.layout;
  const seats = Object.fromEntries(makeSeatIds(rows, cols).map(id => [id, { id, status: 'available' }]));

  // Apply reservations (held or booked), skipping expired holds
  for (const r of reservations) {
    if (r.showtimeId !== showtimeId || r.hallId !== hallId) continue;
    if (r.status === 'held' && isExpired(r)) continue;
    for (const sid of r.seats) {
      if (seats[sid]) {
        seats[sid] = { id: sid, status: r.status === 'booked' ? 'booked' : 'held', reservationId: r.id };
      }
    }
  }
  return { layout: hall.layout, seats };
}

function bumpVersion(versions, showtimeId, hallId) {
  const key = `${showtimeId}:${hallId}`;
  versions[key] = (versions[key] || 0) + 1;
  return versions[key];
}

function getVersion(versions, showtimeId, hallId) {
  const key = `${showtimeId}:${hallId}`;
  return versions[key] || 0;
}

// Prune expired holds periodically
async function pruneExpiredHolds(state) {
  const before = state.reservations.length;
  state.reservations = state.reservations.filter(r => !(r.status === 'held' && isExpired(r)));
  const after = state.reservations.length;
  if (after !== before) {
    // We don't know which showtime/hall changed; conservatively bump for all pairs in removed holds
    bumpAllVersionsForRemovedHolds(state);
    await saveReservations(state.reservations);
    await saveVersions(state.versions);
  }
}

function bumpAllVersionsForRemovedHolds(state) {
  // Not ideal; for simplicity bump everything referenced by removed holds
  // In real system, track by pair
  for (const st of state.showtimes) {
    for (const hall of state.halls) {
      const key = `${st.id}:${hall.id}`;
      state.versions[key] = (state.versions[key] || 0) + 1;
    }
  }
}

// Routes
app.get('/api/health', (req, res) => res.json({ ok: true }));

app.get('/api/movies', async (req, res) => {
  const state = await loadState();
  res.json(state.movies);
});

app.get('/api/movies/:id', async (req, res) => {
  const state = await loadState();
  const movie = state.movies.find(m => m.id === req.params.id);
  if (!movie) return res.status(404).json({ error: 'Movie not found' });
  res.json(movie);
});

app.get('/api/showtimes', async (req, res) => {
  const state = await loadState();
  const { movieId } = req.query;
  const items = movieId ? state.showtimes.filter(s => s.movieId === movieId) : state.showtimes;
  res.json(items);
});

app.get('/api/showtimes/:id', async (req, res) => {
  const state = await loadState();
  const st = state.showtimes.find(s => s.id === req.params.id);
  if (!st) return res.status(404).json({ error: 'Showtime not found' });
  res.json(st);
});

app.get('/api/halls/:hallId/seatmap', async (req, res) => {
  const state = await loadState();
  const { hallId } = req.params;
  const { showtimeId, sinceVersion } = req.query;
  if (!showtimeId) return res.status(400).json({ error: 'showtimeId is required' });
  const map = computeSeatMapForShowtime({ halls: state.halls, hallId, showtimeId, reservations: state.reservations });
  const version = getVersion(state.versions, showtimeId, hallId);
  res.json({ version, ...map });
});

app.post('/api/reserve', async (req, res) => {
  const state = await loadState();
  const { showtimeId, hallId, seats, action, reservationId } = req.body || {};
  if (!showtimeId || !hallId || !Array.isArray(seats) || seats.length === 0)
    return res.status(400).json({ error: 'showtimeId, hallId and non-empty seats are required' });

  const hall = getHall(state.halls, hallId);
  if (!hall) return res.status(404).json({ error: 'Hall not found' });

  // Recompute current seat status
  const seatMap = computeSeatMapForShowtime({ halls: state.halls, hallId, showtimeId, reservations: state.reservations });

  if (action === 'hold' || !action) {
    // Seats must all be available
    const unavailable = seats.filter(sid => seatMap.seats[sid]?.status !== 'available');
    if (unavailable.length) return res.status(409).json({ error: 'Some seats are not available', seats: unavailable });

    const id = nanoid();
    const holdMins = 2; // hold for 2 minutes
    const expiresAt = now() + holdMins * 60 * 1000;
    const reservation = { id, showtimeId, hallId, seats, status: 'held', createdAt: now(), expiresAt };
    state.reservations.push(reservation);
    bumpVersion(state.versions, showtimeId, hallId);
    await saveReservations(state.reservations);
    await saveVersions(state.versions);
    return res.status(201).json({ reservation });
  }

  if (action === 'confirm') {
    if (!reservationId) return res.status(400).json({ error: 'reservationId is required to confirm' });
    const idx = state.reservations.findIndex(r => r.id === reservationId && r.showtimeId === showtimeId && r.hallId === hallId);
    if (idx === -1) return res.status(404).json({ error: 'Reservation not found' });
    const r = state.reservations[idx];
    if (r.status !== 'held' || isExpired(r)) return res.status(409).json({ error: 'Reservation not holdable/expired' });
    // Ensure seats unchanged
    const stillAvailableForUs = r.seats.every(sid => seatMap.seats[sid]?.reservationId === r.id || seatMap.seats[sid]?.status === 'available');
    if (!stillAvailableForUs) return res.status(409).json({ error: 'Seats no longer available' });
    state.reservations[idx] = { ...r, status: 'booked', confirmedAt: now(), expiresAt: undefined };
    bumpVersion(state.versions, showtimeId, hallId);
    await saveReservations(state.reservations);
    await saveVersions(state.versions);
    return res.json({ reservation: state.reservations[idx] });
  }

  if (action === 'release') {
    if (!reservationId) return res.status(400).json({ error: 'reservationId is required to release' });
    const before = state.reservations.length;
    const target = state.reservations.find(r => r.id === reservationId);
    if (!target) return res.status(404).json({ error: 'Reservation not found' });
    state.reservations = state.reservations.filter(r => r.id !== reservationId);
    if (state.reservations.length !== before) {
      bumpVersion(state.versions, showtimeId, hallId);
      await saveReservations(state.reservations);
      await saveVersions(state.versions);
    }
    return res.json({ ok: true });
  }

  return res.status(400).json({ error: 'Unknown action' });
});

// Bootstrap + timers
const PORT = process.env.PORT || 4000;
const TICK_MS = 15 * 1000; // prune every 15s

let timer = null;

async function start() {
  const state = await loadState();
  // Start pruning loop
  timer = setInterval(() => pruneExpiredHolds(state).catch(err => console.error('prune error', err)), TICK_MS);
  app.listen(PORT, () => console.log(`Fake backend listening on http://localhost:${PORT}`));
}

start();
