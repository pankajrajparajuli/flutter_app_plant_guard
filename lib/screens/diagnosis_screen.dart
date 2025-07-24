import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:plant_guard/config/api_config.dart'; // Import your config here
import 'package:plant_guard/screens/preventive_tips_screen.dart';
import 'package:plant_guard/screens/solutions_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  String diagnosis = '';
  String confidence = '';
  String plantType = '';
  bool isLoading = true;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async => await _storage.read(key: 'access_token');

  Future<void> _fetchDiagnosis(String imagePath) async {
    final token = await _getToken();
    if (token == null) {
      setState(() {
        diagnosis = 'No access token found. Please log in again.';
        isLoading = false;
      });
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiBaseUrl/api/detection/predict/'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var data = jsonDecode(responseBody);
        setState(() {
          diagnosis = data['diagnosis'] ?? 'Unknown';
          confidence = (data['confidence'] != null) ? "${(data['confidence'] * 100).toStringAsFixed(2)}%" : 'N/A';
          plantType = data['plant_type'] ?? 'Unknown';
          isLoading = false;
        });
      } else {
        setState(() {
          diagnosis = 'Error: ${response.statusCode}';
          confidence = 'N/A';
          plantType = 'Unknown';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        diagnosis = 'Failed to get diagnosis';
        confidence = 'N/A';
        plantType = 'Unknown';
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    if (args != null) {
      _fetchDiagnosis(args);
    } else {
      setState(() {
        diagnosis = 'No image selected';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disease Diagnosis')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Diagnosis: $diagnosis', style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 8),
                  Text('Confidence: $confidence', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Text('Plant Type: $plantType', style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 24),
                  ExpansionTile(
                    title: const Text('Remedies'),
                    children: [
                      ListTile(
                        title: const Text('Organic Solutions'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SolutionsScreen(predictionId: 'some_id_here'),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Preventative Tips'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreventiveTipsScreen(predictionId: 'some_id_here'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
