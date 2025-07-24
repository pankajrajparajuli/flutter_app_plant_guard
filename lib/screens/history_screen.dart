import 'package:flutter/material.dart';
import 'package:plant_guard/screens/preventive_tips_screen.dart';
import 'package:plant_guard/screens/solutions_screen.dart';
import 'package:plant_guard/services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> historyData = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await ApiService().getHistory();
      if (data == null || data.isEmpty) {
        setState(() {
          historyData = [];
          isLoading = false;
        });
      } else {
        setState(() {
          historyData = data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load history: $e';
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(errorMessage!)));
        }
      });
    }
  }

  Future<void> clearHistory() async {
    try {
      await ApiService().clearHistory();
      await fetchHistory(); // Refresh the history after clearing
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to clear history: $e')),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear History',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Clear History'),
                      content: const Text(
                        'Are you sure you want to clear all history?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
              );
              if (confirmed == true) {
                await clearHistory(); // Ensure async execution
              }
            },
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : historyData.isEmpty
              ? const Center(child: Text('No history found.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final item = historyData[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading:
                          item['image'] != null &&
                                  (item['image'] as String).isNotEmpty
                              ? Image.network(
                                item['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                    ),
                              )
                              : const Icon(Icons.image_not_supported, size: 50),
                      title: Text(item['disease'] ?? 'Unknown Disease'),
                      subtitle: Text(item['timestamp']?.toString() ?? ''),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => PreventiveTipsScreen(
                                  predictionId: item['id'].toString(),
                                ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        tooltip: 'View Solutions',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => SolutionsScreen(
                                    predictionId: item['id'].toString(),
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
