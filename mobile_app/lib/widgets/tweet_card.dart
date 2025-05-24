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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!, width: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info
            Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: tweet.isBot
                        ? AppTheme.primaryColor.withOpacity(0.1)
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      tweet.authorAvatar,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Name and handle
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
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (tweet.isBot) ...[
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'BOT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        '${tweet.authorHandle} · ${_formatTime(tweet.timestamp)}',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // More button
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                  color: AppTheme.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Tweet content
            Text(
              tweet.content,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            if (tweet.stocks.isNotEmpty) ...[
              const SizedBox(height: 12),
              // Stock tags
              Wrap(
                spacing: 8,
                children: tweet.stocks.map((stock) {
                  return ActionChip(
                    label: Text(
                      '\$$stock',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    onPressed: () {
                      // Navigate to stock details
                    },
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            // Engagement buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Like button
                InkWell(
                  onTap: onLike,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(
                          tweet.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: tweet.isLiked
                              ? Colors.red
                              : AppTheme.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tweet.likes > 0 ? tweet.likes.toString() : '',
                          style: TextStyle(
                            color: tweet.isLiked
                                ? Colors.red
                                : AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Retweet button
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.repeat,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tweet.retweets > 0 ? tweet.retweets.toString() : '',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Reply button
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: AppTheme.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tweet.replies > 0 ? tweet.replies.toString() : '',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Share button
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.share_outlined,
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
