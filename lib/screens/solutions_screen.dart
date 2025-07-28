import 'package:flutter/material.dart';
import 'package:plant_guard/services/api_service.dart';

class SolutionsScreen extends StatefulWidget {
  final String predictionId;

  const SolutionsScreen({super.key, required this.predictionId});

  @override
  _SolutionsScreenState createState() => _SolutionsScreenState();
}

class _SolutionsScreenState extends State<SolutionsScreen> {
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
      setState(() {
        predictionData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load solutions: $e';
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
        title: const Text('Organic Solutions'),
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
                      predictionData?['organic_solutions'] ??
                          'No data available',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
    );
  }
}
