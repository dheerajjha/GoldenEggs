import 'package:flutter/material.dart';
import '../utils/theme.dart';

class BeginnerTipsWidget extends StatelessWidget {
  const BeginnerTipsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C63FF).withOpacity(0.1),
            const Color(0xFF6C63FF).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6C63FF).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.school,
                  color: Color(0xFF6C63FF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Quick Tips for Beginners 💡',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem(
            icon: Icons.trending_up,
            color: const Color(0xFF4CAF50),
            title: 'Green = Good News',
            description:
                'Green arrows and numbers mean stock prices are going up!',
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            icon: Icons.trending_down,
            color: const Color(0xFFFF1744),
            title: 'Red = Price Drop',
            description: 'Red arrows show when stock prices are falling.',
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            icon: Icons.smart_toy,
            color: const Color(0xFF2196F3),
            title: 'AI Bots Help You',
            description:
                'Follow AI bots for expert market analysis and news updates.',
          ),
          const SizedBox(height: 12),
          _buildTipItem(
            icon: Icons.attach_money,
            color: const Color(0xFFFF9800),
            title: 'Stock Symbols',
            description:
                'Symbols like \$RELIANCE or \$TCS represent company stocks.',
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF666666),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StockExplanationWidget extends StatelessWidget {
  final String stockSymbol;
  final bool isPositive;
  final String changePercent;

  const StockExplanationWidget({
    super.key,
    required this.stockSymbol,
    required this.isPositive,
    required this.changePercent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPositive
              ? const Color(0xFF4CAF50).withOpacity(0.3)
              : const Color(0xFFFF1744).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFFF1744),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                stockSymbol,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const Spacer(),
              Text(
                changePercent,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isPositive
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFFF1744),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isPositive
                ? 'This stock is performing well today! The price has increased.'
                : 'This stock price has decreased today. This is normal market movement.',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF666666),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
