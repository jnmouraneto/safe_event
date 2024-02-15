import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:safe_event/controllers/credentials_controller.dart';
import 'package:safe_event/controllers/expiration_controller.dart';
import 'package:safe_event/service/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String apiUrl = ApiConfig.baseUrl;
  CredentialsController credentialsController = CredentialsController();

  Future login(String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse('$apiUrl/token/'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      print("Deu certo o login, setando usuário e senha / token e refresh");
      Map<String, dynamic> tokens = json.decode(response.body);
      sharedPreferences.setString('token', tokens['access']);
      sharedPreferences.setString('refreshToken', tokens['refresh']);
      //SaveProtegido
      credentialsController.saveLoginCredentials(email, password);

      return json.decode(response.body);
    }
    if (response.statusCode == 401) {
      return json.decode(response.body);
    } else {
      return response.statusCode;
    }
  }

  Future<Map<String, dynamic>> refreshToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final refreshToken = sharedPreferences.getString('refreshToken');

    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await http.post(
      Uri.parse('$apiUrl/token/refresh/'),
      body: {
        'refresh': refreshToken,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> tokens = json.decode(response.body);

      sharedPreferences.setString('token', tokens['access']);
      return tokens;
    } else {
      if (response.statusCode == 401) {
        print("RefreshToken expirado, realizando novo login");
        //Código de refreshToken expirado, necessário realizar novo login

        Map<String, String> loginCredentials =
            await credentialsController.getLoginCredentials();

        String savedEmail = loginCredentials['email'] ?? '';
        String savedPassword = loginCredentials['password'] ?? '';

        //novo login
        await login(savedEmail, savedPassword);
      }
      throw Exception('Failed to refresh token (${response.statusCode})');
    }
  }

  newSession(String email, String password) {}
}
