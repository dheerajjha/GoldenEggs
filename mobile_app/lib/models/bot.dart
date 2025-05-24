class Bot {
  final String id;
  final String name;
  final String handle;
  final String avatar;
  final String description;
  final String type;
  final int followers;
  bool isFollowing;

  Bot({
    required this.id,
    required this.name,
    required this.handle,
    required this.avatar,
    required this.description,
    required this.type,
    required this.followers,
    this.isFollowing = false,
  });

  factory Bot.fromJson(Map<String, dynamic> json) {
    return Bot(
      id: json['id'],
      name: json['name'],
      handle: json['handle'],
      avatar: json['avatar'],
      description: json['description'],
      type: json['type'],
      followers: json['followers'] ?? 0,
      isFollowing: json['isFollowing'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'handle': handle,
      'avatar': avatar,
      'description': description,
      'type': type,
      'followers': followers,
      'isFollowing': isFollowing,
    };
  }

  Bot copyWith({
    String? id,
    String? name,
    String? handle,
    String? avatar,
    String? description,
    String? type,
    int? followers,
    bool? isFollowing,
  }) {
    return Bot(
      id: id ?? this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      avatar: avatar ?? this.avatar,
      description: description ?? this.description,
      type: type ?? this.type,
      followers: followers ?? this.followers,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
