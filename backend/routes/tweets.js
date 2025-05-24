const express = require('express');
const router = express.Router();
const dataStore = require('../services/dataStore');

// Get all tweets
router.get('/', (req, res) => {
  const limit = parseInt(req.query.limit) || 50;
  const offset = parseInt(req.query.offset) || 0;
  
  const tweets = dataStore.getTweets(limit, offset);
  res.json({ tweets, total: dataStore.tweets.length });
});

// Create a new tweet
router.post('/', (req, res) => {
  const { content, userId = 'user_default', userName = 'Anonymous User', stocks = [] } = req.body;
  
  if (!content || content.trim().length === 0) {
    return res.status(400).json({ error: 'Tweet content is required' });
  }

  if (content.length > 280) {
    return res.status(400).json({ error: 'Tweet must be 280 characters or less' });
  }

  const tweet = dataStore.addTweet({
    content,
    authorId: userId,
    authorName: userName,
    authorHandle: `@${userName.toLowerCase().replace(/\s+/g, '_')}`,
    authorAvatar: '👤',
    stocks,
    isBot: false
  });

  // Emit to all connected clients
  const io = req.app.get('io');
  if (io) {
    io.emit('newTweet', tweet);
  }

  res.status(201).json(tweet);
});

// Get tweets by stock symbol
router.get('/stock/:symbol', (req, res) => {
  const { symbol } = req.params;
  const limit = parseInt(req.query.limit) || 50;
  
  const tweets = dataStore.getTweetsByStock(symbol.toUpperCase(), limit);
  res.json({ tweets, symbol: symbol.toUpperCase() });
});

// Get tweets by bot
router.get('/bot/:botId', (req, res) => {
  const { botId } = req.params;
  const limit = parseInt(req.query.limit) || 50;
  
  const tweets = dataStore.getTweetsByBot(botId, limit);
  const bot = dataStore.getBot(botId);
  
  if (!bot) {
    return res.status(404).json({ error: 'Bot not found' });
  }
  
  res.json({ tweets, bot });
});

// Like a tweet
router.post('/:tweetId/like', (req, res) => {
  const { tweetId } = req.params;
  const { userId = 'user_default' } = req.body;
  
  dataStore.likeTweet(tweetId, userId);
  res.json({ success: true });
});

// Unlike a tweet
router.delete('/:tweetId/like', (req, res) => {
  const { tweetId } = req.params;
  const { userId = 'user_default' } = req.body;
  
  dataStore.unlikeTweet(tweetId, userId);
  res.json({ success: true });
});

// Search tweets
router.get('/search', (req, res) => {
  const { q } = req.query;
  
  if (!q || q.trim().length === 0) {
    return res.status(400).json({ error: 'Search query is required' });
  }
  
  const tweets = dataStore.searchTweets(q);
  res.json({ tweets, query: q });
});

module.exports = router; 