const dataStore = require('./dataStore');
const stockService = require('./stockService');

class BotService {
  constructor() {
    this.io = null;
    this.lastRun = {};
  }

  initialize(io) {
    this.io = io;
  }

  async runBots() {
    const bots = dataStore.getAllBots();
    
    for (const bot of bots) {
      try {
        // Check if bot should run (different intervals for different bots)
        if (this.shouldBotRun(bot)) {
          await this.runBot(bot);
          this.lastRun[bot.id] = Date.now();
        }
      } catch (error) {
        console.error(`Error running bot ${bot.id}:`, error);
      }
    }
  }

  shouldBotRun(bot) {
    const now = Date.now();
    const lastRunTime = this.lastRun[bot.id] || 0;
    const intervals = {
      'market_overview': 60000, // 1 minute
      'top_movers': 120000, // 2 minutes
      'news': 180000, // 3 minutes
      'technical': 300000, // 5 minutes
      'sentiment': 300000, // 5 minutes
      'volume': 120000, // 2 minutes
      'breakout': 180000, // 3 minutes
      'dividend': 600000 // 10 minutes
    };
    
    return now - lastRunTime >= (intervals[bot.type] || 300000);
  }

  async runBot(bot) {
    let tweetContent = null;
    let stocks = [];

    switch (bot.type) {
      case 'market_overview':
        const marketData = await this.generateMarketOverview();
        tweetContent = marketData.content;
        stocks = marketData.stocks;
        break;

      case 'top_movers':
        const moversData = await this.generateTopMovers();
        tweetContent = moversData.content;
        stocks = moversData.stocks;
        break;

      case 'news':
        tweetContent = this.generateNewsUpdate();
        break;

      case 'technical':
        const techData = await this.generateTechnicalAnalysis();
        tweetContent = techData.content;
        stocks = techData.stocks;
        break;

      case 'sentiment':
        tweetContent = this.generateSentimentAnalysis();
        break;

      case 'volume':
        const volumeData = await this.generateVolumeAlert();
        tweetContent = volumeData.content;
        stocks = volumeData.stocks;
        break;

      case 'breakout':
        const breakoutData = await this.generateBreakoutAlert();
        tweetContent = breakoutData.content;
        stocks = breakoutData.stocks;
        break;

      case 'dividend':
        tweetContent = this.generateDividendUpdate();
        break;
    }

    if (tweetContent) {
      const tweet = dataStore.addTweet({
        content: tweetContent,
        authorId: bot.id,
        authorName: bot.name,
        authorHandle: bot.handle,
        authorAvatar: bot.avatar,
        stocks: stocks,
        isBot: true
      });

      // Emit to all connected clients
      if (this.io) {
        this.io.emit('newTweet', tweet);
      }
    }
  }

  async generateMarketOverview() {
    // Simulate market data
    const nifty = 21500 + (Math.random() - 0.5) * 200;
    const niftyChange = ((Math.random() - 0.5) * 2).toFixed(2);
    const sensex = 72000 + (Math.random() - 0.5) * 500;
    const sensexChange = ((Math.random() - 0.5) * 2).toFixed(2);

    const content = `📊 Market Update:\n\nNIFTY 50: ${nifty.toFixed(2)} (${niftyChange > 0 ? '+' : ''}${niftyChange}%)\nSENSEX: ${sensex.toFixed(2)} (${sensexChange > 0 ? '+' : ''}${sensexChange}%)\n\n${niftyChange > 0 && sensexChange > 0 ? '🟢 Bulls in control!' : niftyChange < 0 && sensexChange < 0 ? '🔴 Bears dominating!' : '🟡 Mixed signals in the market'}`;

    return { content, stocks: ['NIFTY', 'SENSEX'] };
  }

  async generateTopMovers() {
    const topGainers = [
      { symbol: 'RELIANCE', change: (Math.random() * 5 + 1).toFixed(2) },
      { symbol: 'TCS', change: (Math.random() * 4 + 1).toFixed(2) },
      { symbol: 'HDFCBANK', change: (Math.random() * 3 + 1).toFixed(2) }
    ];

    const topLosers = [
      { symbol: 'INFY', change: -(Math.random() * 4 + 1).toFixed(2) },
      { symbol: 'WIPRO', change: -(Math.random() * 3 + 1).toFixed(2) }
    ];

    let content = '🚀 TOP GAINERS:\n';
    topGainers.forEach(stock => {
      content += `${stock.symbol}: +${stock.change}%\n`;
    });

    content += '\n📉 TOP LOSERS:\n';
    topLosers.forEach(stock => {
      content += `${stock.symbol}: ${stock.change}%\n`;
    });

    const stocks = [...topGainers.map(g => g.symbol), ...topLosers.map(l => l.symbol)];
    return { content, stocks };
  }

  generateNewsUpdate() {
    const news = [
      "RBI keeps repo rate unchanged at 6.5% in latest monetary policy review",
      "Foreign investors pump ₹15,000 crore into Indian equities this month",
      "Auto sector sees strong growth with 15% YoY increase in sales",
      "IT companies face headwinds as global recession fears loom",
      "Government announces infrastructure boost with ₹2 lakh crore investment"
    ];

    const randomNews = news[Math.floor(Math.random() * news.length)];
    return `📰 Breaking: ${randomNews}\n\n#StockMarket #IndianMarkets`;
  }

  async generateTechnicalAnalysis() {
    const stocks = ['RELIANCE', 'TCS', 'HDFCBANK', 'INFY', 'ITC'];
    const stock = stocks[Math.floor(Math.random() * stocks.length)];
    const price = (1000 + Math.random() * 2000).toFixed(2);
    
    const patterns = [
      'forming a bullish flag pattern',
      'breaking above 50-day moving average',
      'showing strong support at current levels',
      'RSI indicating oversold conditions',
      'MACD showing bullish crossover'
    ];

    const pattern = patterns[Math.floor(Math.random() * patterns.length)];

    const content = `📈 Technical Alert: ${stock} @ ₹${price}\n\n${pattern}. Watch for potential breakout!\n\n⚡ Key Levels:\nSupport: ₹${(price * 0.97).toFixed(2)}\nResistance: ₹${(price * 1.03).toFixed(2)}`;

    return { content, stocks: [stock] };
  }

  generateSentimentAnalysis() {
    const fearGreedIndex = Math.floor(Math.random() * 100);
    let sentiment = '';
    let emoji = '';

    if (fearGreedIndex < 20) {
      sentiment = 'Extreme Fear';
      emoji = '😱';
    } else if (fearGreedIndex < 40) {
      sentiment = 'Fear';
      emoji = '😨';
    } else if (fearGreedIndex < 60) {
      sentiment = 'Neutral';
      emoji = '😐';
    } else if (fearGreedIndex < 80) {
      sentiment = 'Greed';
      emoji = '😊';
    } else {
      sentiment = 'Extreme Greed';
      emoji = '🤑';
    }

    return `🎭 Market Sentiment Analysis:\n\nFear & Greed Index: ${fearGreedIndex}/100\nCurrent Mood: ${sentiment} ${emoji}\n\n${fearGreedIndex < 40 ? '💡 Tip: Could be a good time to accumulate quality stocks' : fearGreedIndex > 70 ? '⚠️ Caution: Markets might be overheated' : '📊 Markets in balanced state'}`;
  }

  async generateVolumeAlert() {
    const stocks = ['RELIANCE', 'TCS', 'HDFCBANK', 'INFY', 'BHARTIARTL', 'ICICIBANK'];
    const stock = stocks[Math.floor(Math.random() * stocks.length)];
    const volumeIncrease = (100 + Math.random() * 200).toFixed(0);

    const content = `📢 Volume Alert!\n\n${stock} showing ${volumeIncrease}% increase in volume compared to 10-day average.\n\nThis could indicate:\n• Institutional buying/selling\n• Upcoming news/events\n• Trend reversal\n\nKeep on watchlist! 👀`;

    return { content, stocks: [stock] };
  }

  async generateBreakoutAlert() {
    const stocks = ['TATASTEEL', 'SBIN', 'AXISBANK', 'MARUTI', 'POWERGRID'];
    const stock = stocks[Math.floor(Math.random() * stocks.length)];
    const price = (500 + Math.random() * 1500).toFixed(2);
    const breakoutLevel = (price * 0.95).toFixed(2);

    const content = `💥 BREAKOUT ALERT!\n\n${stock} breaks above ₹${breakoutLevel} resistance with strong volume!\n\nCurrent Price: ₹${price}\nNext Target: ₹${(price * 1.05).toFixed(2)}\nStop Loss: ₹${breakoutLevel}\n\n🎯 Risk-Reward looks favorable!`;

    return { content, stocks: [stock] };
  }

  generateDividendUpdate() {
    const dividends = [
      { company: 'ITC', dividend: '6.75', record: '5 days' },
      { company: 'COALINDIA', dividend: '15.00', record: '7 days' },
      { company: 'POWERGRID', dividend: '4.50', record: '10 days' },
      { company: 'ONGC', dividend: '3.25', record: '3 days' }
    ];

    const announcement = dividends[Math.floor(Math.random() * dividends.length)];

    return `💰 Dividend Alert!\n\n${announcement.company} announces dividend of ₹${announcement.dividend} per share.\n\n📅 Record Date: ${announcement.record} from now\n\nDividend Yield: ~${(Math.random() * 2 + 2).toFixed(2)}%\n\n#Dividends #PassiveIncome`;
  }
}

module.exports = new BotService(); 