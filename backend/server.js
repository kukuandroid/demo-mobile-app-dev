const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const app = express();
const server = http.createServer(app);

// Allow connections from any origin (for emulator compatibility)
const io = socketIo(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});

// Middleware
app.use(cors({
  origin: '*', // Allow all origins for emulator/device access
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Database connection
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/cinema-booking', {
  useNewUrlParser: true,
  useUnifiedTopology: true
})
.then(() => console.log('Connected to MongoDB'))
.catch(err => console.error('MongoDB connection error:', err));

// Routes
app.use('/api/cinemas', require('./src/routes/cinemaRoutes'));
app.use('/api/halls', require('./src/routes/hallRoutes'));
app.use('/api/seats', require('./src/routes/seatRoutes'));
app.use('/api/bookings', require('./src/routes/bookingRoutes'));
app.use('/api/auth', require('./src/routes/authRoutes'));

// Socket.IO connection handling
io.on('connection', (socket) => {
  console.log('User connected:', socket.id);

  // Join specific hall room
  socket.on('join-hall', (hallId) => {
    socket.join(hallId);
    console.log(`User ${socket.id} joined hall ${hallId}`);
  });

  // Handle seat locking
  socket.on('lock-seat', async (data) => {
    const { seatId, userId, hallId } = data;
    try {
      // Emit to all users in the hall
      socket.to(hallId).emit('seat-locked', { seatId, userId });
      socket.emit('seat-locked-success', { seatId });
    } catch (error) {
      socket.emit('error', { message: 'Failed to lock seat' });
    }
  });

  // Handle seat unlocking
  socket.on('unlock-seat', async (data) => {
    const { seatId, userId, hallId } = data;
    try {
      socket.to(hallId).emit('seat-unlocked', { seatId });
      socket.emit('seat-unlocked-success', { seatId });
    } catch (error) {
      socket.emit('error', { message: 'Failed to unlock seat' });
    }
  });

  // Handle booking confirmation
  socket.on('confirm-booking', async (data) => {
    const { seats, userId, hallId } = data;
    try {
      socket.to(hallId).emit('seats-booked', { seats, userId });
      socket.emit('booking-confirmed', { seats });
    } catch (error) {
      socket.emit('error', { message: 'Failed to confirm booking' });
    }
  });

  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

// Listen on all interfaces for emulator/device access
const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0';
server.listen(PORT, HOST, () => {
  console.log(`Server running on http://${HOST}:${PORT}`);
});