import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  String firstName = '';
  String lastName = '';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var response = await http.post(
        Uri.parse('YOUR_BACKEND_API_URL/api/account/register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password, 'first_name': firstName, 'last_name': lastName}),
      );
      if (response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) => value!.isEmpty ? 'Enter username' : null,
              onSaved: (value) => username = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) => value!.isEmpty ? 'Enter password' : null,
              onSaved: (value) => password = value!,
            ),
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
            ElevatedButton(onPressed: _register, child: Text('Register')),
          ],
        ),
      ),
    );
  }
}