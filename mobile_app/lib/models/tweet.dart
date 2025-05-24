class Tweet {
  final String id;
  final String content;
  final String authorId;
  final String authorName;
  final String authorHandle;
  final String authorAvatar;
  final DateTime timestamp;
  final int likes;
  final int retweets;
  final int replies;
  final List<String> stocks;
  final bool isBot;
  bool isLiked;

  Tweet({
    required this.id,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.authorHandle,
    required this.authorAvatar,
    required this.timestamp,
    required this.likes,
    required this.retweets,
    required this.replies,
    required this.stocks,
    required this.isBot,
    this.isLiked = false,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      id: json['id'],
      content: json['content'],
      authorId: json['authorId'],
      authorName: json['authorName'],
      authorHandle: json['authorHandle'],
      authorAvatar: json['authorAvatar'],
      timestamp: DateTime.parse(json['timestamp']),
      likes: json['likes'] ?? 0,
      retweets: json['retweets'] ?? 0,
      replies: json['replies'] ?? 0,
      stocks: List<String>.from(json['stocks'] ?? []),
      isBot: json['isBot'] ?? false,
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'authorId': authorId,
      'authorName': authorName,
      'authorHandle': authorHandle,
      'authorAvatar': authorAvatar,
      'timestamp': timestamp.toIso8601String(),
      'likes': likes,
      'retweets': retweets,
      'replies': replies,
      'stocks': stocks,
      'isBot': isBot,
      'isLiked': isLiked,
    };
  }

  Tweet copyWith({
    String? id,
    String? content,
    String? authorId,
    String? authorName,
    String? authorHandle,
    String? authorAvatar,
    DateTime? timestamp,
    int? likes,
    int? retweets,
    int? replies,
    List<String>? stocks,
    bool? isBot,
    bool? isLiked,
  }) {
    return Tweet(
      id: id ?? this.id,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorHandle: authorHandle ?? this.authorHandle,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      retweets: retweets ?? this.retweets,
      replies: replies ?? this.replies,
      stocks: stocks ?? this.stocks,
      isBot: isBot ?? this.isBot,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
