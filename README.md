# Stock Pulse - Twitter for Indian Stock Market

A comprehensive social media platform focused on the Indian stock market, featuring AI-powered bots, real-time updates, and market insights. Built with Flutter, Node.js, and React.

## 🚀 Project Overview

Stock Pulse is a Twitter-like platform designed specifically for stock market enthusiasts. It features:

- **8 Specialized AI Bots** providing real-time market insights
- **Real-time Tweet Updates** via WebSocket connections
- **Stock Tagging System** for tracking specific stocks
- **Trending Stocks** based on social mentions
- **Beautiful Mobile App** built with Flutter
- **Powerful Admin Panel** for platform management
- **RESTful Backend API** with Node.js

## 📱 Mobile App (Flutter)

The mobile app provides a seamless experience for users to:
- Follow market bots for automated insights
- Post tweets about stocks
- View personalized feed
- Track trending stocks
- Like and interact with content

[View Mobile App README](./mobile_app/README.md)

### Key Features:
- Real-time feed updates
- Beautiful Material Design 3 UI
- Stock search and tagging
- Bot following system
- Pull-to-refresh functionality

## 🖥️ Backend (Node.js)

The backend powers the entire platform with:
- RESTful API endpoints
- WebSocket support for real-time updates
- In-memory data storage
- Automated bot posting system
- Stock data integration ready

[View Backend README](./backend/README.md)

### API Endpoints:
- `/api/tweets` - Tweet management
- `/api/bots` - Bot operations
- `/api/stocks` - Stock data and search
- `/api/feed` - Personalized feeds

## 🌐 Web Admin Panel (React)

A comprehensive admin dashboard for:
- Monitoring platform statistics
- Managing tweets and content
- Configuring bots
- User management
- Analytics and insights

[View Admin Panel README](./web_admin/README.md)

### Admin Features:
- Real-time dashboard
- Tweet moderation
- Bot configuration
- Analytics charts
- User management

## 🤖 Market Bots

The platform features 8 specialized bots:

1. **Market Pulse Bot** - Real-time market indices updates
2. **Top Movers Bot** - Daily gainers and losers
3. **News Aggregator** - Latest market news
4. **Technical Analysis Bot** - Chart patterns and indicators
5. **Sentiment Analyzer** - Market mood tracking
6. **Volume Alert Bot** - Unusual volume detection
7. **Breakout Scanner** - Support/resistance breaks
8. **Dividend Tracker** - Dividend announcements

## 🚀 Quick Start

### Prerequisites
- Node.js 16+
- Flutter SDK 3.5.4+
- npm or yarn

### Backend Setup
```bash
cd backend
npm install
npm start
```
Server runs on `http://localhost:5500`

### Mobile App Setup
```bash
cd mobile_app
flutter pub get
flutter run
```

### Admin Panel Setup
```bash
cd web_admin
npm install
npm run dev
```
Admin panel runs on `http://localhost:5173`

## 🏗️ Architecture

```
GoldenEggs/
├── backend/            # Node.js backend server
│   ├── routes/        # API routes
│   ├── services/      # Business logic
│   └── server.js      # Main server file
├── mobile_app/        # Flutter mobile application
│   ├── lib/          # Dart source code
│   ├── assets/       # App assets
│   └── pubspec.yaml  # Dependencies
└── web_admin/        # React admin panel
    ├── src/          # React source code
    └── package.json  # Dependencies
```

## 🔧 Technology Stack

### Backend
- Node.js & Express.js
- Socket.IO for real-time
- Axios for HTTP requests
- Node-cron for scheduling

### Mobile App
- Flutter & Dart
- Provider for state management
- Socket.IO client
- HTTP package for API calls

### Admin Panel
- React 18 with Vite
- Tailwind CSS for styling
- Recharts for data visualization
- React Router for navigation

## 📊 Future Enhancements

- **User Authentication** - Secure login/signup
- **Push Notifications** - Real-time alerts
- **Upstox API Integration** - Live market data
- **Portfolio Tracking** - Personal portfolio management
- **Advanced Analytics** - ML-based predictions
- **Dark Mode** - Theme customization
- **Multi-language Support** - Hindi, regional languages
- **Database Integration** - PostgreSQL/MongoDB

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- Inspired by Twitter's design and functionality
- Built for the Indian stock market community
- Uses simulated data for demonstration

---

**Note**: This is a demonstration project. For production use, implement proper authentication, database storage, and integrate with real stock market APIs like Upstox. 