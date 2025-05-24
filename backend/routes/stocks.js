const express = require('express');
const router = express.Router();
const stockService = require('../services/stockService');
const dataStore = require('../services/dataStore');

// Search stocks
router.get('/search', (req, res) => {
  const { q } = req.query;
  
  if (!q || q.trim().length === 0) {
    return res.status(400).json({ error: 'Search query is required' });
  }
  
  const stocks = stockService.searchStocks(q);
  res.json({ stocks });
});

// Get stock quote
router.get('/:symbol/quote', async (req, res) => {
  const { symbol } = req.params;
  
  try {
    const quote = await stockService.getMarketQuote(symbol.toUpperCase());
    res.json(quote);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch stock quote' });
  }
});

// Get all tracked stocks
router.get('/tracked', (req, res) => {
  const stocks = dataStore.getAllStockData();
  res.json({ stocks });
});

// Get trending stocks (based on tweet mentions)
router.get('/trending', (req, res) => {
  const tweets = dataStore.getTweets(100);
  const stockMentions = {};
  
  tweets.forEach(tweet => {
    if (tweet.stocks) {
      tweet.stocks.forEach(stock => {
        stockMentions[stock] = (stockMentions[stock] || 0) + 1;
      });
    }
  });
  
  const trending = Object.entries(stockMentions)
    .sort(([, a], [, b]) => b - a)
    .slice(0, 10)
    .map(([symbol, mentions]) => ({
      symbol,
      mentions,
      trend: mentions > 5 ? 'hot' : 'warm'
    }));
  
  res.json({ trending });
});

module.exports = router; 