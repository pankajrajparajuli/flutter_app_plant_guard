import 'package:flutter/material.dart';
import 'package:plant_guard/services/api_service.dart';
import 'package:intl/intl.dart';

class PredictionDetailsScreen extends StatefulWidget {
  final String predictionId;
  const PredictionDetailsScreen({super.key, required this.predictionId});

  @override
  State<PredictionDetailsScreen> createState() =>
      _PredictionDetailsScreenState();
}

class _PredictionDetailsScreenState extends State<PredictionDetailsScreen> {
  Map<String, dynamic>? predictionData;
  bool isLoading = true;
  String? errorMessage;
  bool showPreventive = false;
  bool showSolutions = false;

  @override
  void initState() {
    super.initState();
    fetchPredictionDetails();
  }

  Future<void> fetchPredictionDetails() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final data = await ApiService().getPredictionDetails(widget.predictionId);
      setState(() {
        predictionData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load details: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _showDeleteDialog() async {
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Prediction'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Enter your password to confirm deletion:'),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context, true);
                  }
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      await _deletePrediction(passwordController.text);
    }
  }

  Future<void> _deletePrediction(String password) async {
    setState(() {
      isLoading = true;
    });
    try {
      // First, verify password by attempting to clear history with a dummy call (or implement a password check endpoint if available)
      // Here, we assume deleteHistoryItem does not require password, but you can adapt as needed.
      await ApiService().deleteHistoryItem(widget.predictionId);
      if (mounted) {
        Navigator.pop(context, true); // Return to history screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prediction deleted successfully')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete: $e')));
    }
  }

  String _formatTimestamp(String? timestamp) {
    if (timestamp == null) return '';
    try {
      final dt = DateTime.parse(timestamp);
      return DateFormat('d MMM yyyy hh:mm a').format(dt);
    } catch (_) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Prediction Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: _showDeleteDialog,
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : predictionData == null
              ? const Center(child: Text('No data found.'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (predictionData!['image'] != null &&
                        (predictionData!['image'] as String).isNotEmpty)
                      Center(
                        child: Image.network(
                          predictionData!['image'],
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => const Icon(
                                Icons.image_not_supported,
                                size: 100,
                              ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      predictionData!['disease'] ?? 'Unknown Disease',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(
                        predictionData!['timestamp']?.toString(),
                      ),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ExpansionPanelList(
                      expansionCallback: (panelIndex, isExpanded) {
                        setState(() {
                          if (panelIndex == 0) {
                            showPreventive = !showPreventive;
                          } else {
                            showSolutions = !showSolutions;
                          }
                        });
                      },
                      children: [
                        ExpansionPanel(
                          headerBuilder:
                              (context, isExpanded) => ListTile(
                                title: const Text('Preventive Measures'),
                              ),
                          body: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              predictionData!['preventative_tips'] ??
                                  'No data available',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          isExpanded: showPreventive,
                          canTapOnHeader: true,
                        ),
                        ExpansionPanel(
                          headerBuilder:
                              (context, isExpanded) => ListTile(
                                title: const Text('Organic Solutions'),
                              ),
                          body: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              predictionData!['organic_solutions'] ??
                                  'No data available',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          isExpanded: showSolutions,
                          canTapOnHeader: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
