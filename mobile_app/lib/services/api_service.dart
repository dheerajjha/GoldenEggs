import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tweet.dart';
import '../models/bot.dart';
import '../models/stock.dart';

class ApiService {
  static const String baseUrl = 'http://20.193.143.179:5500/api';
  static const String userId = 'user_default';
  static const String userName = 'Stock Trader';

  // Tweet APIs
  static Future<Map<String, dynamic>> getTweets({
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tweets?limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'tweets': (data['tweets'] as List)
            .map((e) => Tweet.fromJson(e))
            .toList(),
        'total': data['total'],
      };
    } else {
      throw Exception('Failed to load tweets');
    }
  }

  static Future<Tweet> createTweet(String content, List<String> stocks) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tweets'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'content': content,
        'userId': userId,
        'userName': userName,
        'stocks': stocks,
      }),
    );

    if (response.statusCode == 201) {
      return Tweet.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create tweet');
    }
  }

  static Future<void> likeTweet(String tweetId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tweets/$tweetId/like'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to like tweet');
    }
  }

  static Future<void> unlikeTweet(String tweetId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/tweets/$tweetId/like'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unlike tweet');
    }
  }

  static Future<List<Tweet>> searchTweets(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/tweets/search?q=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['tweets'] as List).map((e) => Tweet.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search tweets');
    }
  }

  // Bot APIs
  static Future<List<Bot>> getBots() async {
    final response = await http.get(Uri.parse('$baseUrl/bots'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final followedBots = await getFollowedBots();
      final followedIds = followedBots.map((b) => b.id).toSet();

      return (data['bots'] as List).map((e) {
        final bot = Bot.fromJson(e);
        return bot.copyWith(isFollowing: followedIds.contains(bot.id));
      }).toList();
    } else {
      throw Exception('Failed to load bots');
    }
  }

  static Future<void> followBot(String botId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bots/$botId/follow'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to follow bot');
    }
  }

  static Future<void> unfollowBot(String botId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/bots/$botId/follow'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unfollow bot');
    }
  }

  static Future<List<Bot>> getFollowedBots() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bots/user/$userId/following'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['followedBots'] as List)
          .map((e) => Bot.fromJson(e)..isFollowing = true)
          .toList();
    } else {
      throw Exception('Failed to load followed bots');
    }
  }

  // Stock APIs
  static Future<List<Stock>> searchStocks(String query) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stocks/search?q=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['stocks'] as List).map((e) => Stock.fromJson(e)).toList();
    } else {
      throw Exception('Failed to search stocks');
    }
  }

  static Future<Stock> getStockQuote(String symbol) async {
    final response = await http.get(Uri.parse('$baseUrl/stocks/$symbol/quote'));

    if (response.statusCode == 200) {
      return Stock.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get stock quote');
    }
  }

  static Future<List<TrendingStock>> getTrendingStocks() async {
    final response = await http.get(Uri.parse('$baseUrl/stocks/trending'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['trending'] as List)
          .map((e) => TrendingStock.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to get trending stocks');
    }
  }

  // Feed APIs
  static Future<Map<String, dynamic>> getFeed({
    int limit = 50,
    int offset = 0,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/feed?userId=$userId&limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'feed': (data['feed'] as List).map((e) => Tweet.fromJson(e)).toList(),
        'hasMore': data['hasMore'],
      };
    } else {
      throw Exception('Failed to load feed');
    }
  }

  static Future<List<Tweet>> getPopularTweets() async {
    final response = await http.get(Uri.parse('$baseUrl/feed/popular'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['tweets'] as List).map((e) => Tweet.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load popular tweets');
    }
  }
}
