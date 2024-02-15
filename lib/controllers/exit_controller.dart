import 'package:flutter/material.dart';
import 'package:safe_event/controllers/credentials_controller.dart';
import 'package:safe_event/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExitController {
  static Future<void> logout(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    CredentialsController credentialsController = await CredentialsController();

    // Remove os tokens do SharedPreferences
    sharedPreferences.remove('token');
    sharedPreferences.remove('refreshToken');

    //remover os dados de login do CredentialsController (criptografado)
    await credentialsController.removeLoginCredentials();

    // Navega para a página de login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
