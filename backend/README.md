# Stock Market Social Media - Backend

A Node.js backend for a Twitter-like social media platform focused on the Indian stock market.

## Features

- Real-time tweet streaming via Socket.io
- 8 specialized bots providing market insights:
  - Market Pulse Bot - Real-time market updates
  - Top Movers Bot - Tracks gainers/losers
  - News Aggregator - Latest market news
  - Technical Analysis Bot - Chart patterns and indicators
  - Sentiment Analyzer - Market mood tracking
  - Volume Alert Bot - Unusual volume activity
  - Breakout Scanner - Key level breakouts
  - Dividend Tracker - Dividend announcements
- RESTful API endpoints
- In-memory data storage
- Automatic bot posting with different intervals

## API Endpoints

### Tweets
- `GET /api/tweets` - Get all tweets
- `POST /api/tweets` - Create a new tweet
- `GET /api/tweets/stock/:symbol` - Get tweets for a specific stock
- `GET /api/tweets/bot/:botId` - Get tweets from a specific bot
- `POST /api/tweets/:tweetId/like` - Like a tweet
- `DELETE /api/tweets/:tweetId/like` - Unlike a tweet
- `GET /api/tweets/search?q=query` - Search tweets

### Bots
- `GET /api/bots` - Get all bots
- `GET /api/bots/:botId` - Get a specific bot
- `POST /api/bots/:botId/follow` - Follow a bot
- `DELETE /api/bots/:botId/follow` - Unfollow a bot
- `GET /api/bots/user/:userId/following` - Get followed bots

### Stocks
- `GET /api/stocks/search?q=query` - Search stocks
- `GET /api/stocks/:symbol/quote` - Get stock quote
- `GET /api/stocks/tracked` - Get all tracked stocks
- `GET /api/stocks/trending` - Get trending stocks

### Feed
- `GET /api/feed?userId=user_id` - Get personalized feed
- `GET /api/feed/discover` - Get discover feed
- `GET /api/feed/popular` - Get popular tweets
- `GET /api/feed/bots/latest` - Get latest bot tweets

## Setup

1. Install dependencies:
```bash
npm install
```

2. Create a `.env` file:
```
PORT=5500
UPSTOX_API_KEY=your_api_key_here
UPSTOX_API_SECRET=your_api_secret_here
```

3. Run the server:
```bash
npm start
```

The server will run on port 5500 by default.

## WebSocket Events

- `connection` - Client connected
- `disconnect` - Client disconnected
- `newTweet` - New tweet posted (emitted to all clients)

## Bot Posting Intervals

- Market Overview: Every 1 minute
- Top Movers: Every 2 minutes
- News: Every 3 minutes
- Technical Analysis: Every 5 minutes
- Sentiment Analysis: Every 5 minutes
- Volume Alerts: Every 2 minutes
- Breakout Scanner: Every 3 minutes
- Dividend Tracker: Every 10 minutes 