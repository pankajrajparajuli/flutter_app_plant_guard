import 'package:flutter/material.dart';
import 'package:plant_guard/services/api_service.dart';

class PreventiveTipsScreen extends StatefulWidget {
  final String predictionId;

  PreventiveTipsScreen({required this.predictionId});

  @override
  _PreventiveTipsScreenState createState() => _PreventiveTipsScreenState();
}

class _PreventiveTipsScreenState extends State<PreventiveTipsScreen> {
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
        title: Text('Preventative Tips'),
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
                    predictionData['preventative_tips'] ?? 'No data available',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}