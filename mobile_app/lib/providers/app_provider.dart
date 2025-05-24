import 'package:flutter/foundation.dart';
import '../models/tweet.dart';
import '../models/bot.dart';
import '../models/stock.dart';
import '../services/api_service.dart';
import '../services/socket_service.dart';

class AppProvider extends ChangeNotifier {
  List<Tweet> _tweets = [];
  List<Tweet> _feedTweets = [];
  List<Bot> _bots = [];
  List<TrendingStock> _trendingStocks = [];
  bool _isLoading = false;
  String _error = '';

  List<Tweet> get tweets => _tweets;
  List<Tweet> get feedTweets => _feedTweets;
  List<Bot> get bots => _bots;
  List<TrendingStock> get trendingStocks => _trendingStocks;
  bool get isLoading => _isLoading;
  String get error => _error;

  AppProvider() {
    _initializeApp();
  }

  void _initializeApp() {
    SocketService.init();
    SocketService.setOnNewTweetCallback(_handleNewTweet);
    loadInitialData();
  }

  void _handleNewTweet(Tweet tweet) {
    _tweets.insert(0, tweet);
    _feedTweets.insert(0, tweet);
    notifyListeners();
  }

  Future<void> loadInitialData() async {
    await Future.wait([loadTweets(), loadBots(), loadTrendingStocks()]);
  }

  Future<void> loadTweets() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final result = await ApiService.getTweets();
      _tweets = result['tweets'];
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFeed() async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = await ApiService.getFeed();
      _feedTweets = result['feed'];
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBots() async {
    try {
      final result = await ApiService.getBots();
      _bots = result;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadTrendingStocks() async {
    try {
      final result = await ApiService.getTrendingStocks();
      _trendingStocks = result;
      notifyListeners();
    } catch (e) {
      print('Error loading trending stocks: $e');
    }
  }

  Future<void> createTweet(String content, List<String> stocks) async {
    try {
      final tweet = await ApiService.createTweet(content, stocks);
      _tweets.insert(0, tweet);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> likeTweet(String tweetId) async {
    try {
      // Optimistically update UI
      final index = _tweets.indexWhere((t) => t.id == tweetId);
      if (index != -1) {
        _tweets[index].isLiked = true;
        _tweets[index] = _tweets[index].copyWith(
          likes: _tweets[index].likes + 1,
          isLiked: true,
        );
        notifyListeners();
      }

      await ApiService.likeTweet(tweetId);
    } catch (e) {
      // Revert on error
      final index = _tweets.indexWhere((t) => t.id == tweetId);
      if (index != -1) {
        _tweets[index].isLiked = false;
        _tweets[index] = _tweets[index].copyWith(
          likes: _tweets[index].likes - 1,
          isLiked: false,
        );
        notifyListeners();
      }
      throw e;
    }
  }

  Future<void> unlikeTweet(String tweetId) async {
    try {
      // Optimistically update UI
      final index = _tweets.indexWhere((t) => t.id == tweetId);
      if (index != -1) {
        _tweets[index].isLiked = false;
        _tweets[index] = _tweets[index].copyWith(
          likes: _tweets[index].likes - 1,
          isLiked: false,
        );
        notifyListeners();
      }

      await ApiService.unlikeTweet(tweetId);
    } catch (e) {
      // Revert on error
      final index = _tweets.indexWhere((t) => t.id == tweetId);
      if (index != -1) {
        _tweets[index].isLiked = true;
        _tweets[index] = _tweets[index].copyWith(
          likes: _tweets[index].likes + 1,
          isLiked: true,
        );
        notifyListeners();
      }
      throw e;
    }
  }

  Future<void> followBot(String botId) async {
    try {
      // Optimistically update UI
      final index = _bots.indexWhere((b) => b.id == botId);
      if (index != -1) {
        _bots[index] = _bots[index].copyWith(
          isFollowing: true,
          followers: _bots[index].followers + 1,
        );
        notifyListeners();
      }

      await ApiService.followBot(botId);
      await loadFeed(); // Reload feed to get tweets from newly followed bot
    } catch (e) {
      // Revert on error
      final index = _bots.indexWhere((b) => b.id == botId);
      if (index != -1) {
        _bots[index] = _bots[index].copyWith(
          isFollowing: false,
          followers: _bots[index].followers - 1,
        );
        notifyListeners();
      }
      throw e;
    }
  }

  Future<void> unfollowBot(String botId) async {
    try {
      // Optimistically update UI
      final index = _bots.indexWhere((b) => b.id == botId);
      if (index != -1) {
        _bots[index] = _bots[index].copyWith(
          isFollowing: false,
          followers: _bots[index].followers - 1,
        );
        notifyListeners();
      }

      await ApiService.unfollowBot(botId);
      await loadFeed(); // Reload feed to remove tweets from unfollowed bot
    } catch (e) {
      // Revert on error
      final index = _bots.indexWhere((b) => b.id == botId);
      if (index != -1) {
        _bots[index] = _bots[index].copyWith(
          isFollowing: true,
          followers: _bots[index].followers + 1,
        );
        notifyListeners();
      }
      throw e;
    }
  }

  Future<List<Tweet>> searchTweets(String query) async {
    try {
      return await ApiService.searchTweets(query);
    } catch (e) {
      throw e;
    }
  }

  Future<List<Stock>> searchStocks(String query) async {
    try {
      return await ApiService.searchStocks(query);
    } catch (e) {
      throw e;
    }
  }

  @override
  void dispose() {
    SocketService.dispose();
    super.dispose();
  }
}
