import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: [
          ListTile(leading: Icon(Icons.lock), title: Text('Change password'), onTap: () {}),
        ],
      ),
    );
  }
}