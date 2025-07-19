import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  File? _image;
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _result;
  final _picker = ImagePicker();
  final _storage = const FlutterSecureStorage();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _result = null;
        _error = null;
      });
    }
  }

  Future<void> _predict() async {
    if (_image == null) return;
    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });
    final url = Uri.parse('http://127.0.0.1:8000/api/detection/predict/');
    final access = await _storage.read(key: 'access');
    try {
      final request = http.MultipartRequest('POST', url);
      request.files.add(
        await http.MultipartFile.fromPath('image', _image!.path),
      );
      if (access != null) {
        request.headers['Authorization'] = 'Bearer $access';
      }
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      if (response.statusCode == 200) {
        setState(() {
          _result = jsonDecode(response.body);
        });
      } else {
        setState(() {
          _error = 'Prediction failed: ${response.body}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detect Plant Disease')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _image == null
                ? const Text('No image selected.')
                : Image.file(_image!, height: 200),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo),
                  label: const Text('Pick Image'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _image != null && !_isLoading ? _predict : null,
                  icon: const Icon(Icons.search),
                  label: const Text('Predict'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_isLoading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_result != null) ...[
              Text(
                'Disease: ${_result!['disease']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Confidence: ${(_result!['confidence'] ?? _result!['confi dence'])?.toStringAsFixed(2) ?? ''}',
              ),
              Text('Remedy: ${_result!['remedy']}'),
            ],
          ],
        ),
      ),
    );
  }
}
