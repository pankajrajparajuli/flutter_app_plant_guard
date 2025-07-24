import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>(); // Fixed: Use GlobalKey<FormState>() instance
  String firstName = '';
  String lastName = '';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String?> _getToken() async => await _storage.read(key: 'access_token');

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) { // Now works with correct instance
      _formKey.currentState!.save();
      var token = await _getToken();
      var response = await http.put(
        Uri.parse('YOUR_BACKEND_API_URL/api/account/update_profile/'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({'first_name': firstName, 'last_name': lastName}),
      );
      if (response.statusCode == 200) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Form(
        key: _formKey, // Associate the form with the key
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'First Name'),
              validator: (value) => value!.isEmpty ? 'Enter first name' : null,
              onSaved: (value) => firstName = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Last Name'),
              validator: (value) => value!.isEmpty ? 'Enter last name' : null,
              onSaved: (value) => lastName = value!,
            ),
            ElevatedButton(onPressed: _updateProfile, child: Text('Change')),
          ],
        ),
      ),
    );
  }
}