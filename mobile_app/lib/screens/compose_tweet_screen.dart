import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/stock.dart';
import '../services/api_service.dart';
import '../utils/theme.dart';

class ComposeTweetScreen extends StatefulWidget {
  const ComposeTweetScreen({super.key});

  @override
  State<ComposeTweetScreen> createState() => _ComposeTweetScreenState();
}

class _ComposeTweetScreenState extends State<ComposeTweetScreen> {
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _stockSearchController = TextEditingController();
  final List<String> _selectedStocks = [];
  List<Stock> _searchResults = [];
  bool _isPosting = false;
  bool _isSearching = false;

  int get _remainingCharacters => 280 - _contentController.text.length;

  @override
  void dispose() {
    _contentController.dispose();
    _stockSearchController.dispose();
    super.dispose();
  }

  Future<void> _searchStocks(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final results = await ApiService.searchStocks(query);
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _postTweet() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some content'),
          backgroundColor: AppTheme.dangerColor,
        ),
      );
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      await context.read<AppProvider>().createTweet(
        _contentController.text.trim(),
        _selectedStocks,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tweet posted successfully!'),
            backgroundColor: AppTheme.secondaryColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to post tweet: ${e.toString()}'),
          backgroundColor: AppTheme.dangerColor,
        ),
      );
    } finally {
      setState(() {
        _isPosting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compose Tweet'),
        actions: [
          TextButton(
            onPressed: _isPosting ? null : _postTweet,
            child: _isPosting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Post',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Center(
                          child: Text('👤', style: TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Stock Trader',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '@stock_trader',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Tweet content
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    maxLength: 280,
                    decoration: const InputDecoration(
                      hintText: "What's happening in the market?",
                      border: InputBorder.none,
                      counterText: '',
                    ),
                    style: const TextStyle(fontSize: 18),
                    onChanged: (_) => setState(() {}),
                  ),
                  // Selected stocks
                  if (_selectedStocks.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: _selectedStocks.map((stock) {
                        return Chip(
                          label: Text('\$$stock'),
                          onDeleted: () {
                            setState(() {
                              _selectedStocks.remove(stock);
                            });
                          },
                          backgroundColor: AppTheme.primaryColor.withOpacity(
                            0.1,
                          ),
                          labelStyle: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Bottom toolbar
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!, width: 0.5),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Add stock button
                IconButton(
                  icon: const Icon(Icons.show_chart),
                  onPressed: () {
                    _showStockSearchDialog();
                  },
                  color: AppTheme.primaryColor,
                ),
                const Spacer(),
                // Character count
                Text(
                  _remainingCharacters.toString(),
                  style: TextStyle(
                    color: _remainingCharacters < 0
                        ? AppTheme.dangerColor
                        : _remainingCharacters < 20
                        ? Colors.orange
                        : AppTheme.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStockSearchDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.7,
              minChildSize: 0.5,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _stockSearchController,
                          decoration: const InputDecoration(
                            hintText: 'Search stocks...',
                            prefixIcon: Icon(Icons.search),
                          ),
                          onChanged: (value) async {
                            await _searchStocks(value);
                            setModalState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: _isSearching
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  final stock = _searchResults[index];
                                  final isSelected = _selectedStocks.contains(
                                    stock.symbol,
                                  );

                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: AppTheme.primaryColor
                                          .withOpacity(0.1),
                                      child: Text(
                                        stock.symbol[0],
                                        style: const TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(stock.symbol),
                                    subtitle: Text(stock.name),
                                    trailing: isSelected
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: AppTheme.primaryColor,
                                          )
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        if (isSelected) {
                                          _selectedStocks.remove(stock.symbol);
                                        } else {
                                          _selectedStocks.add(stock.symbol);
                                        }
                                      });
                                      setModalState(() {});
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
