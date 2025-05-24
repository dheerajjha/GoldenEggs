# Stock Pulse - Mobile App

A Twitter-like Flutter mobile application for the Indian stock market. Follow AI-powered bots that provide real-time market insights, technical analysis, and trading updates.

## Features

### Core Features
- **Real-time Feed**: Live tweet updates via Socket.IO
- **Market Bots**: 8 specialized AI bots providing different market insights:
  - Market Pulse Bot - Real-time indices updates
  - Top Movers Bot - Daily gainers and losers
  - News Aggregator - Market news and updates
  - Technical Analysis Bot - Chart patterns and indicators
  - Sentiment Analyzer - Market mood tracking
  - Volume Alert Bot - Unusual volume detection
  - Breakout Scanner - Support/resistance breaks
  - Dividend Tracker - Dividend announcements

### User Features
- Post tweets about stocks
- Tag stocks in tweets (e.g., $RELIANCE, $TCS)
- Like/Unlike tweets
- Follow/Unfollow bots
- Search stocks when composing tweets
- View trending stocks based on mentions
- Pull-to-refresh on feeds
- Real-time updates without refresh

### UI/UX
- Modern Material Design 3
- Beautiful animations
- Smooth scrolling
- Responsive layouts
- Custom theme with stock market colors
- Shimmer loading effects
- Swipeable actions

## Screenshots

### Main Features:
1. **Feed Tab**: View tweets from followed bots
2. **Bots Tab**: Discover and follow market bots
3. **Trending Tab**: See most mentioned stocks
4. **Compose Tweet**: Post with stock tags

## Setup

### Prerequisites
- Flutter SDK (3.5.4 or higher)
- Dart SDK
- iOS Simulator/Android Emulator or physical device

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Make sure the backend server is running on `http://localhost:5500`

3. Run the app:
```bash
# For iOS
flutter run -d ios

# For Android
flutter run -d android

# For web (if needed)
flutter run -d chrome
```

## Architecture

### State Management
- **Provider**: For global state management
- **ChangeNotifier**: For reactive UI updates

### Networking
- **HTTP**: RESTful API calls
- **Socket.IO**: Real-time updates

### Project Structure
```
lib/
├── models/          # Data models
│   ├── tweet.dart
│   ├── bot.dart
│   └── stock.dart
├── services/        # API and Socket services
│   ├── api_service.dart
│   └── socket_service.dart
├── providers/       # State management
│   └── app_provider.dart
├── screens/         # UI screens
│   ├── home_screen.dart
│   ├── feed_tab.dart
│   ├── bots_tab.dart
│   ├── trending_tab.dart
│   └── compose_tweet_screen.dart
├── widgets/         # Reusable widgets
│   └── tweet_card.dart
├── utils/           # Utilities
│   └── theme.dart
└── main.dart        # App entry point
```

## API Integration

The app connects to the backend API at `http://localhost:5500/api` with the following endpoints:

- **Tweets**: Create, read, like tweets
- **Bots**: List bots, follow/unfollow
- **Stocks**: Search stocks, get trending
- **Feed**: Get personalized feed

## Key Packages

- `provider`: State management
- `http`: API calls
- `socket_io_client`: Real-time updates
- `intl`: Date formatting
- `pull_to_refresh`: Pull-to-refresh functionality
- `shimmer`: Loading animations
- `flutter_slidable`: Swipeable actions
- `badges`: Notification badges
- `fluttertoast`: Toast messages

## Development

### Adding New Features
1. Create model in `models/`
2. Add API methods in `services/api_service.dart`
3. Update provider in `providers/app_provider.dart`
4. Create UI in `screens/` or `widgets/`

### Testing
```bash
flutter test
```

### Building for Production
```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Android App Bundle
flutter build appbundle
```

## Configuration

### Change API URL
Update the `baseUrl` in `lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://your-server-url/api';
```

### Socket URL
Update socket URL in `lib/services/socket_service.dart`:
```dart
_socket = IO.io('http://your-server-url', ...);
```

## Performance Optimizations

- Lazy loading for feed items
- Image caching with CachedNetworkImage
- Debounced search
- Optimistic UI updates
- Efficient state management

## Future Enhancements

- Push notifications
- Dark mode
- User authentication
- Direct messaging
- Stock price charts
- Portfolio tracking
- Watchlist feature
- Price alerts
