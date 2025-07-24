import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> getToken() async => await _storage.read(key: 'access_token');
  Future<String?> getRefreshToken() async =>
      await _storage.read(key: 'refresh_token');

  // LOGIN
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/api/account/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: 'access_token', value: data['access']);
      await _storage.write(key: 'refresh_token', value: data['refresh']);
      return true;
    } else {
      throw HttpException('Login failed: ${response.body}');
    }
  }

  // REGISTER
  Future<bool> register(
    String username,
    String password,
    String firstName,
    String lastName,
  ) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/api/account/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      }),
    );
    if (response.statusCode == 201) return true;
    throw HttpException('Registration failed: ${response.body}');
  }

  // UPDATE PROFILE
  Future<bool> updateProfile(String firstName, String lastName) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$apiBaseUrl/api/account/update_profile/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'first_name': firstName, 'last_name': lastName}),
    );
    if (response.statusCode == 200) return true;
    throw HttpException('Profile update failed: ${response.body}');
  }

  // PREDICT DISEASE
  Future<Map<String, dynamic>> predictDisease(String imagePath) async {
    final token = await getToken();
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiBaseUrl/api/detection/predict/'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      return jsonDecode(responseBody);
    }
    throw HttpException('Prediction failed with status ${response.statusCode}');
  }

  // GET HISTORY
  Future<List<dynamic>> getHistory() async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$apiBaseUrl/api/detection/history/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw HttpException('Failed to load history: ${response.body}');
  }

  // GET PREDICTION DETAILS
  Future<Map<String, dynamic>> getPredictionDetails(String id) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$apiBaseUrl/api/detection/history/$id/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw HttpException('Failed to load prediction details: ${response.body}');
  }

  // DELETE ONE HISTORY ITEM
  Future<bool> deleteHistoryItem(String id) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$apiBaseUrl/api/detection/history/$id/delete/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 204) return true;
    throw HttpException('Failed to delete history item: ${response.body}');
  }

  // CLEAR HISTORY
  Future<bool> clearHistory({required String password}) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$apiBaseUrl/api/detection/history/clear/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'password': password}),
    );

    if (response.statusCode == 204) return true;

    throw HttpException('Failed to clear history: ${response.body}');
  }

  // GET USER PROFILE - **Moved inside class!**
  Future<Map<String, dynamic>> getUserProfile() async {
    final token = await getToken();
    if (token == null) {
      throw Exception('No access token found');
    }
    final response = await http.get(
      Uri.parse('$apiBaseUrl/api/account/user_detail/'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to fetch profile: ${response.body}');
  } // <- THIS CLOSING BRACE IS MISSING
}
