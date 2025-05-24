const express = require('express');
const router = express.Router();
const dataStore = require('../services/dataStore');

// Get user feed
router.get('/', (req, res) => {
  const { userId = 'user_default' } = req.query;
  const limit = parseInt(req.query.limit) || 50;
  const offset = parseInt(req.query.offset) || 0;
  
  const feed = dataStore.getFeed(userId, limit, offset);
  const followedBots = dataStore.getFollowedBots(userId);
  
  res.json({ 
    feed, 
    followedBots,
    hasMore: feed.length === limit 
  });
});

// Get discover feed (all tweets)
router.get('/discover', (req, res) => {
  const limit = parseInt(req.query.limit) || 50;
  const offset = parseInt(req.query.offset) || 0;
  
  const tweets = dataStore.getTweets(limit, offset);
  
  res.json({ 
    tweets,
    hasMore: tweets.length === limit 
  });
});

// Get popular tweets
router.get('/popular', (req, res) => {
  const limit = parseInt(req.query.limit) || 50;
  
  // Get all tweets and sort by engagement (likes + retweets)
  const allTweets = dataStore.getTweets(200);
  const popularTweets = allTweets
    .sort((a, b) => (b.likes + b.retweets) - (a.likes + a.retweets))
    .slice(0, limit);
  
  res.json({ tweets: popularTweets });
});

// Get latest bot tweets
router.get('/bots/latest', (req, res) => {
  const limit = parseInt(req.query.limit) || 20;
  
  const botTweets = dataStore.getTweets(100)
    .filter(tweet => tweet.isBot)
    .slice(0, limit);
  
  res.json({ tweets: botTweets });
});

module.exports = router; 