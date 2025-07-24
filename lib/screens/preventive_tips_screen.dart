import 'package:flutter/material.dart';
import 'package:plant_guard/services/api_service.dart';

class PreventiveTipsScreen extends StatefulWidget {
  final String predictionId;

  PreventiveTipsScreen({required this.predictionId});

  @override
  _PreventiveTipsScreenState createState() => _PreventiveTipsScreenState();
}

class _PreventiveTipsScreenState extends State<PreventiveTipsScreen> {
  Map<String, dynamic>? predictionData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchPredictionDetails();
  }

  Future<void> fetchPredictionDetails() async {
    try {
      final data = await ApiService().getPredictionDetails(widget.predictionId);
      if (!mounted) return;
      setState(() {
        predictionData = data;
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Failed to load tips: $e';
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Preventative Tips'),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      predictionData?['disease_name'] ?? 'Unknown Disease',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      predictionData?['preventative_tips'] ??
                          'No data available',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
    );
  }
}
