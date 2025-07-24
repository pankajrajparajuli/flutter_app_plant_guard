import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu')),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Alicia Smith\n@aliciasmith'),
            onTap: () {},
          ),
          ListTile(leading: Icon(Icons.history), title: Text('History'), onTap: () {}),
          ListTile(leading: Icon(Icons.info), title: Text('About Us'), onTap: () {}),
          ListTile(leading: Icon(Icons.logout), title: Text('Log Out'), onTap: () {}),
        ],
      ),
    );
  }
}