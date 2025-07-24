import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'YOUR_BACKEND_API_URL';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String?> getToken() async => await _storage.read(key: 'access_token');

  Future<void> login(String username, String password) async {
    var response = await http.post(
      Uri.parse('$baseUrl/api/account/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      await _storage.write(key: 'access_token', value: data['access']);
      await _storage.write(key: 'refresh_token', value: data['refresh']);
    }
  }

  Future<void> register(String username, String password, String firstName, String lastName) async {
    var response = await http.post(
      Uri.parse('$baseUrl/api/account/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password, 'first_name': firstName, 'last_name': lastName}),
    );
    if (response.statusCode == 201) {
      // Handle successful registration
    }
  }

  Future<void> updateProfile(String firstName, String lastName) async {
    var token = await getToken();
    var response = await http.put(
      Uri.parse('$baseUrl/api/account/update_profile/'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: jsonEncode({'first_name': firstName, 'last_name': lastName}),
    );
    if (response.statusCode == 200) {
      // Handle successful update
    }
  }

  Future<Map<String, dynamic>> predictDisease(String imagePath) async {
    var token = await getToken();
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/detection/predict/'));
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    var response = await request.send();
    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString());
    }
    return {};
  }

  Future<List<dynamic>> getHistory() async {
    var token = await getToken();
    var response = await http.get(
      Uri.parse('$baseUrl/api/detection/history/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return [];
  }

  Future<Map<String, dynamic>> predictDiseaseDetails(String id) async {
    var token = await getToken();
    var response = await http.get(
      Uri.parse('$baseUrl/api/detection/history/$id/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {};
  }

  Future<void> deleteHistoryItem(String id) async {
    var token = await getToken();
    var response = await http.delete(
      Uri.parse('$baseUrl/api/detection/history/$id/delete/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 204) {
      // Handle successful deletion
    }
  }

  Future<void> clearHistory() async {
    var token = await getToken();
    var response = await http.delete(
      Uri.parse('$baseUrl/api/detection/history/clear/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 204) {
      // Handle successful clear
    }
  }
}