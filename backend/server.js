const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const http = require('http');
const socketIo = require('socket.io');
const cron = require('node-cron');
require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: ["http://localhost:3000", "http://localhost:8080"],
    methods: ["GET", "POST"]
  }
});

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Import routes
const tweetsRoutes = require('./routes/tweets');
const botsRoutes = require('./routes/bots');
const stocksRoutes = require('./routes/stocks');
const feedRoutes = require('./routes/feed');

// Import services
const botService = require('./services/botService');
const dataStore = require('./services/dataStore');

// Initialize data store
dataStore.init();

// Routes
app.use('/api/tweets', tweetsRoutes);
app.use('/api/bots', botsRoutes);
app.use('/api/stocks', stocksRoutes);
app.use('/api/feed', feedRoutes);

// Socket.io connection
io.on('connection', (socket) => {
  console.log('New client connected');
  
  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });
});

// Make io accessible to routes
app.set('io', io);

// Initialize bot service
botService.initialize(io);

// Start cron jobs for bots
cron.schedule('*/30 * * * * *', () => {
  botService.runBots();
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date() });
});

const PORT = process.env.PORT || 5500;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = { app, io }; 