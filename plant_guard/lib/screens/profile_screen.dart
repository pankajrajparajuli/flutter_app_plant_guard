import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = const FlutterSecureStorage();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  String? _success;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _success = null;
    });
    final url = Uri.parse('http://127.0.0.1:8000/api/account/profile/');
    final access = await _storage.read(key: 'access');
    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $access'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        firstNameController.text = data['first_name'] ?? '';
        lastNameController.text = data['last_name'] ?? '';
      } else {
        setState(() {
          _error = 'Failed to load profile.';
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

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _success = null;
    });
    final url = Uri.parse('http://127.0.0.1:8000/api/account/profile/');
    final access = await _storage.read(key: 'access');
    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $access',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'first_name': firstNameController.text.trim(),
          'last_name': lastNameController.text.trim(),
          if (oldPasswordController.text.isNotEmpty &&
              newPasswordController.text.isNotEmpty)
            'old_password': oldPasswordController.text,
          if (oldPasswordController.text.isNotEmpty &&
              newPasswordController.text.isNotEmpty)
            'new_password': newPasswordController.text,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          _success = 'Profile updated successfully!';
        });
        oldPasswordController.clear();
        newPasswordController.clear();
      } else {
        setState(() {
          _error = 'Failed to update profile.';
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
      appBar: AppBar(title: const Text('Profile')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: oldPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Old Password (to change password)',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 24),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  if (_success != null)
                    Text(
                      _success!,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Update Profile'),
                  ),
                ],
              ),
            ),
    );
  }
}
