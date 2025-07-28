import 'package:flutter/material.dart';
import 'package:plant_guard/screens/diagnosis_screen.dart';
import 'package:plant_guard/screens/edit_profile_screen.dart';
import 'package:plant_guard/screens/home_screen.dart';
import 'package:plant_guard/screens/login_screen.dart';
import 'package:plant_guard/screens/menu_screen.dart';
import 'package:plant_guard/screens/register_screen.dart';
import 'package:plant_guard/screens/scan_screen.dart';
import 'package:plant_guard/screens/settings_screen.dart';
import 'package:plant_guard/screens/history_screen.dart';
import 'package:plant_guard/screens/change_password_screen.dart';

void main() {
  runApp(const PlantGuardApp());
}

class PlantGuardApp extends StatelessWidget {
  const PlantGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Guard',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/edit_profile': (context) => EditProfileScreen(),
        '/menu': (context) => MenuScreen(),
        '/settings': (context) => SettingsScreen(),
        '/scan': (context) => ScanScreen(),
        '/diagnosis': (context) => DiagnosisScreen(),
        '/history': (context) => HistoryScreen(),
        '/change_password': (context) => ChangePasswordScreen(),
      },
    );
  }
}
