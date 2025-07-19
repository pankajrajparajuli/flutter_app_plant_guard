import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../api_constants.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> _history = [];
  bool _isLoading = true;
  String? _error;
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final url = Uri.parse('$baseUrl/api/detection/history/');
    final access = await _storage.read(key: 'access');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $access'},
      );
      if (response.statusCode == 200) {
        setState(() {
          _history = jsonDecode(response.body);
        });
      } else {
        setState(() {
          _error = 'Failed to load history.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteRecord(int id) async {
    final url = Uri.parse('$baseUrl/api/detection/history/$id/delete/');
    final access = await _storage.read(key: 'access');
    try {
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $access'},
      );
      if (response.statusCode == 204) {
        _fetchHistory();
      } else {
        setState(() {
          _error = 'Failed to delete record.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Network error. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Prediction History')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            )
          : _history.isEmpty
          ? const Center(child: Text('No prediction history.'))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: item['image'] != null
                        ? Image.network(
                            item['image'],
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image),
                    title: Text(item['disease'] ?? 'Unknown Disease'),
                    subtitle: Text(
                      'Confidence: ${item['confidence'] ?? item['confi dence']}, Remedy: ${item['remedy'] ?? ''}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteRecord(item['id']),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(item['disease'] ?? 'Prediction Detail'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item['image'] != null)
                                Image.network(item['image'], height: 120),
                              Text(
                                'Confidence: ${item['confidence'] ?? item['confi dence']}',
                              ),
                              Text('Remedy: ${item['remedy'] ?? ''}'),
                              Text('Timestamp: ${item['timestamp'] ?? ''}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
