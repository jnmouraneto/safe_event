import 'package:flutter/material.dart';
import 'package:safe_event/models/event_model.dart';
import 'package:safe_event/models/guest_model.dart';
import 'package:safe_event/screens/guest_detail_screen.dart';
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

  static void navigateToGuestDetail(BuildContext context, Guest guest, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GuestDetail(guest: guest, event: event)),
    );
  }
}
