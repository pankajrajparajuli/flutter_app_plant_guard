import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Add auth check and navigation logic
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
    return const Scaffold(
      body: Center(child: Text('Plant Guard', style: TextStyle(fontSize: 32))),
    );
  }
}
