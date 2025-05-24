class Stock {
  final String symbol;
  final String name;
  final double lastPrice;
  final double change;
  final double changePercent;
  final int volume;
  final DateTime? lastUpdated;

  Stock({
    required this.symbol,
    required this.name,
    required this.lastPrice,
    required this.change,
    required this.changePercent,
    required this.volume,
    this.lastUpdated,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'],
      name: json['name'] ?? json['symbol'],
      lastPrice: (json['last_price'] ?? json['lastPrice'] ?? 0).toDouble(),
      change: (json['change'] ?? 0).toDouble(),
      changePercent: (json['change_percent'] ?? json['changePercent'] ?? 0)
          .toDouble(),
      volume: json['volume'] ?? 0,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'lastPrice': lastPrice,
      'change': change,
      'changePercent': changePercent,
      'volume': volume,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  bool get isPositive => change >= 0;

  String get formattedPrice => '₹${lastPrice.toStringAsFixed(2)}';
  String get formattedChange =>
      '${change >= 0 ? '+' : ''}${change.toStringAsFixed(2)}';
  String get formattedChangePercent =>
      '${changePercent >= 0 ? '+' : ''}${changePercent.toStringAsFixed(2)}%';
}

class TrendingStock {
  final String symbol;
  final int mentions;
  final String trend;

  TrendingStock({
    required this.symbol,
    required this.mentions,
    required this.trend,
  });

  factory TrendingStock.fromJson(Map<String, dynamic> json) {
    return TrendingStock(
      symbol: json['symbol'],
      mentions: json['mentions'],
      trend: json['trend'],
    );
  }
}
