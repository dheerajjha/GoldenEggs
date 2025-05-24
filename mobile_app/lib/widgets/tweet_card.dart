import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/tweet.dart';
import '../utils/theme.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;
  final VoidCallback? onLike;
  final VoidCallback? onTap;

  const TweetCard({super.key, required this.tweet, this.onLike, this.onTap});

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return DateFormat('MMM d').format(time);
    }
  }

  Widget _buildStockChip(String stock) {
    // Simulate stock price change for demo
    final isPositive = stock.hashCode % 2 == 0;
    final change = (stock.hashCode % 500) / 100;

    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isPositive
            ? const Color(0xFF00C853).withOpacity(0.1)
            : const Color(0xFFFF1744).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPositive
              ? const Color(0xFF00C853).withOpacity(0.3)
              : const Color(0xFFFF1744).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: 16,
            color:
                isPositive ? const Color(0xFF00C853) : const Color(0xFFFF1744),
          ),
          const SizedBox(width: 4),
          Text(
            '\$$stock',
            style: TextStyle(
              color: isPositive
                  ? const Color(0xFF00C853)
                  : const Color(0xFFFF1744),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${isPositive ? '+' : '-'}${change.toStringAsFixed(1)}%',
            style: TextStyle(
              color: isPositive
                  ? const Color(0xFF00C853)
                  : const Color(0xFFFF1744),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementButton({
    required IconData icon,
    required String count,
    required Color color,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? color : AppTheme.textSecondary,
              size: 18,
            ),
            if (count.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                count,
                style: TextStyle(
                  color: isActive ? color : AppTheme.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info with improved design
            Row(
              children: [
                // Enhanced Avatar with gradient
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: tweet.isBot
                        ? LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(
                            colors: [
                              Colors.grey[300]!,
                              Colors.grey[400]!,
                            ],
                          ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: tweet.isBot
                            ? AppTheme.primaryColor.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      tweet.authorAvatar,
                      style: TextStyle(
                        fontSize: 24,
                        color: tweet.isBot ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Enhanced name and handle section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              tweet.authorName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xFF1A1A1A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (tweet.isBot) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor,
                                    AppTheme.primaryColor.withOpacity(0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppTheme.primaryColor.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.smart_toy,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'AI BOT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            tweet.authorHandle,
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppTheme.textSecondary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Text(
                            _formatTime(tweet.timestamp),
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Enhanced more button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {},
                    color: AppTheme.textSecondary,
                    iconSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Enhanced tweet content with better typography
            Text(
              tweet.content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF2A2A2A),
                fontWeight: FontWeight.w400,
              ),
            ),
            if (tweet.stocks.isNotEmpty) ...[
              const SizedBox(height: 16),
              // Enhanced stock tags with price indicators
              Wrap(
                children: tweet.stocks
                    .map((stock) => _buildStockChip(stock))
                    .toList(),
              ),
            ],
            const SizedBox(height: 16),
            // Enhanced engagement section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildEngagementButton(
                    icon:
                        tweet.isLiked ? Icons.favorite : Icons.favorite_border,
                    count: tweet.likes > 0 ? tweet.likes.toString() : '',
                    color: const Color(0xFFE91E63),
                    onTap: onLike ?? () {},
                    isActive: tweet.isLiked,
                  ),
                  _buildEngagementButton(
                    icon: Icons.chat_bubble_outline,
                    count: tweet.replies > 0 ? tweet.replies.toString() : '',
                    color: const Color(0xFF2196F3),
                    onTap: () {},
                  ),
                  _buildEngagementButton(
                    icon: Icons.repeat,
                    count: tweet.retweets > 0 ? tweet.retweets.toString() : '',
                    color: const Color(0xFF4CAF50),
                    onTap: () {},
                  ),
                  _buildEngagementButton(
                    icon: Icons.bookmark_border,
                    count: '',
                    color: const Color(0xFFFF9800),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
