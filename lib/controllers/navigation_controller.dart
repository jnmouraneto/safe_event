import 'package:flutter/material.dart';
import 'package:safe_event/screens/login_screen.dart';

class NavigationController {
  static void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  static void navigateToDashboard(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/dashboard'); // Substitua com a rota da tela do painel
  }
}
