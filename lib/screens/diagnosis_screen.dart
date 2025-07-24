import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:plant_guard/config/api_config.dart';
import 'package:plant_guard/screens/preventive_tips_screen.dart';
import 'package:plant_guard/screens/solutions_screen.dart';

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  String diagnosis = '';
  String confidence = '';
  String remedy = '';
  String prevention = '';
  bool isLoading = true;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async => await _storage.read(key: 'access_token');

  Future<void> _fetchDiagnosis(String imagePath) async {
    final token = await _getToken();
    if (token == null) {
      if (mounted) {
        setState(() {
          diagnosis = 'No access token found. Please log in again.';
          isLoading = false;
        });
      }
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
        if (mounted) {
          setState(() {
            diagnosis = data['disease'] ?? 'Unknown';
            confidence =
                (data['confidence'] != null)
                    ? "${(data['confidence'] * 100).toStringAsFixed(2)}%"
                    : 'N/A';
            remedy = data['remedy'] ?? 'Not available';
            prevention = data['prevention'] ?? 'Not available';
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            diagnosis = 'Error: ${response.statusCode}';
            confidence = 'N/A';
            remedy = 'Not available';
            prevention = 'Not available';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          diagnosis = 'Failed to get diagnosis: $e';
          confidence = 'N/A';
          remedy = 'Not available';
          prevention = 'Not available';
          isLoading = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    if (args != null) {
      _fetchDiagnosis(args);
    } else {
      if (mounted) {
        setState(() {
          diagnosis = 'No image selected';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disease Diagnosis')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diagnosis: $diagnosis',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Confidence: $confidence',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ExpansionTile(
                      title: const Text('Remedies and Prevention'),
                      children: [
                        ListTile(
                          title: const Text('Organic Solutions'),
                          subtitle: Text(remedy),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => SolutionsScreen(
                                      predictionId: 'dynamic_id_here',
                                    ), // Replace with actual ID if available
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('Preventative Tips'),
                          subtitle: Text(prevention),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PreventiveTipsScreen(
                                      predictionId: 'dynamic_id_here',
                                    ), // Replace with actual ID if available
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
