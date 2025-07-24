import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class DiagnosisScreen extends StatefulWidget {
  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  String diagnosis = '';
  String confidence = '';
  String plantType = '';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String?> _getToken() async => await _storage.read(key: 'access_token');

  Future<void> _fetchDiagnosis(String imagePath) async {
    var token = await _getToken();
    var request = http.MultipartRequest('POST', Uri.parse('YOUR_BACKEND_API_URL/api/detection/predict/'));
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var data = jsonDecode(responseBody);
      setState(() {
        diagnosis = data['diagnosis'] ?? 'Unknown';
        confidence = data['confidence'] ?? 'N/A';
        plantType = data['plant_type'] ?? 'Unknown';
      });
    } else {
      setState(() {
        diagnosis = 'Error';
        confidence = 'N/A';
        plantType = 'Unknown';
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as String?;
    if (args != null) _fetchDiagnosis(args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Disease Diagnosis')),
      body: Column(
        children: [
          Text('Diagnosis: $diagnosis\nConfidence: $confidence\nPlant Type: $plantType'),
          ExpansionTile(title: Text('Remedies'), children: [
            ListTile(title: Text('Organic solutions'), onTap: () {}),
            ListTile(title: Text('Preventative tips'), onTap: () {}),
          ]),
        ],
      ),
    );
  }
}