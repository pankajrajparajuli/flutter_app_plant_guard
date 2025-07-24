import 'package:flutter/material.dart';
import 'package:plant_guard/services/api_service.dart';

class SolutionsScreen extends StatefulWidget {
  final String predictionId;

  SolutionsScreen({required this.predictionId});

  @override
  _SolutionsScreenState createState() => _SolutionsScreenState();
}

class _SolutionsScreenState extends State<SolutionsScreen> {
  Map<String, dynamic> predictionData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPredictionDetails();
  }

  Future<void> fetchPredictionDetails() async {
    try {
      final data = await ApiService().predictDiseaseDetails(widget.predictionId);
      setState(() {
        predictionData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Organic Solutions'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    predictionData['disease_name'] ?? 'Unknown Disease',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    predictionData['organic_solutions'] ?? 'No data available',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}