class DataStore {
  constructor() {
    this.tweets = [];
    this.bots = [];
    this.follows = new Map(); // userId -> Set of botIds
    this.stockData = new Map(); // symbol -> latest data
    this.tweetIdCounter = 1;
    this.botIdCounter = 1;
  }

  init() {
    // Initialize with predefined bots
    this.bots = [
      {
        id: 'bot_1',
        name: 'Market Pulse Bot',
        handle: '@market_pulse',
        avatar: '📊',
        description: 'Real-time market updates and indices movements',
        type: 'market_overview',
        followers: 0
      },
      {
        id: 'bot_2',
        name: 'Top Movers Bot',
        handle: '@top_movers',
        avatar: '🚀',
        description: 'Tracks top gainers and losers of the day',
        type: 'top_movers',
        followers: 0
      },
      {
        id: 'bot_3',
        name: 'News Aggregator',
        handle: '@stock_news',
        avatar: '📰',
        description: 'Latest news affecting Indian stock market',
        type: 'news',
        followers: 0
      },
      {
        id: 'bot_4',
        name: 'Technical Analysis Bot',
        handle: '@tech_analysis',
        avatar: '📈',
        description: 'Technical indicators and chart patterns',
        type: 'technical',
        followers: 0
      },
      {
        id: 'bot_5',
        name: 'Sentiment Analyzer',
        handle: '@market_mood',
        avatar: '🎭',
        description: 'Market sentiment and fear/greed index',
        type: 'sentiment',
        followers: 0
      },
      {
        id: 'bot_6',
        name: 'Volume Alert Bot',
        handle: '@volume_tracker',
        avatar: '📢',
        description: 'Unusual volume activity alerts',
        type: 'volume',
        followers: 0
      },
      {
        id: 'bot_7',
        name: 'Breakout Scanner',
        handle: '@breakouts',
        avatar: '💥',
        description: 'Stocks breaking key resistance/support levels',
        type: 'breakout',
        followers: 0
      },
      {
        id: 'bot_8',
        name: 'Dividend Tracker',
        handle: '@dividend_alerts',
        avatar: '💰',
        description: 'Upcoming dividends and bonus announcements',
        type: 'dividend',
        followers: 0
      }
    ];
  }

  // Tweet methods
  addTweet(tweet) {
    const newTweet = {
      id: `tweet_${this.tweetIdCounter++}`,
      ...tweet,
      timestamp: new Date(),
      likes: 0,
      retweets: 0,
      replies: 0
    };
    this.tweets.unshift(newTweet);
    
    // Keep only last 1000 tweets in memory
    if (this.tweets.length > 1000) {
      this.tweets = this.tweets.slice(0, 1000);
    }
    
    return newTweet;
  }

  getTweets(limit = 50, offset = 0) {
    return this.tweets.slice(offset, offset + limit);
  }

  getTweetsByBot(botId, limit = 50) {
    return this.tweets
      .filter(tweet => tweet.authorId === botId)
      .slice(0, limit);
  }

  getTweetsByStock(symbol, limit = 50) {
    return this.tweets
      .filter(tweet => tweet.stocks && tweet.stocks.includes(symbol))
      .slice(0, limit);
  }

  // Bot methods
  getAllBots() {
    return this.bots;
  }

  getBot(botId) {
    return this.bots.find(bot => bot.id === botId);
  }

  // Follow methods
  followBot(userId, botId) {
    if (!this.follows.has(userId)) {
      this.follows.set(userId, new Set());
    }
    this.follows.get(userId).add(botId);
    
    // Update bot followers count
    const bot = this.getBot(botId);
    if (bot) {
      bot.followers++;
    }
  }

  unfollowBot(userId, botId) {
    if (this.follows.has(userId)) {
      this.follows.get(userId).delete(botId);
      
      // Update bot followers count
      const bot = this.getBot(botId);
      if (bot) {
        bot.followers = Math.max(0, bot.followers - 1);
      }
    }
  }

  getFollowedBots(userId) {
    return Array.from(this.follows.get(userId) || []);
  }

  // Feed methods
  getFeed(userId, limit = 50, offset = 0) {
    const followedBots = this.getFollowedBots(userId);
    
    // If not following anyone, show all tweets
    if (followedBots.length === 0) {
      return this.getTweets(limit, offset);
    }
    
    // Filter tweets from followed bots
    const feedTweets = this.tweets
      .filter(tweet => followedBots.includes(tweet.authorId))
      .slice(offset, offset + limit);
    
    return feedTweets;
  }

  // Stock data methods
  updateStockData(symbol, data) {
    this.stockData.set(symbol, {
      ...data,
      lastUpdated: new Date()
    });
  }

  getStockData(symbol) {
    return this.stockData.get(symbol);
  }

  getAllStockData() {
    return Array.from(this.stockData.entries()).map(([symbol, data]) => ({
      symbol,
      ...data
    }));
  }

  // Like/Unlike methods
  likeTweet(tweetId, userId) {
    const tweet = this.tweets.find(t => t.id === tweetId);
    if (tweet) {
      if (!tweet.likedBy) tweet.likedBy = new Set();
      if (!tweet.likedBy.has(userId)) {
        tweet.likedBy.add(userId);
        tweet.likes++;
      }
    }
  }

  unlikeTweet(tweetId, userId) {
    const tweet = this.tweets.find(t => t.id === tweetId);
    if (tweet && tweet.likedBy && tweet.likedBy.has(userId)) {
      tweet.likedBy.delete(userId);
      tweet.likes = Math.max(0, tweet.likes - 1);
    }
  }

  // Search methods
  searchTweets(query) {
    const lowerQuery = query.toLowerCase();
    return this.tweets.filter(tweet => 
      tweet.content.toLowerCase().includes(lowerQuery) ||
      (tweet.stocks && tweet.stocks.some(stock => stock.toLowerCase().includes(lowerQuery)))
    );
  }
}

module.exports = new DataStore(); 