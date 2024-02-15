import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safe_event/models/guest_model.dart';
import 'package:safe_event/service/api_config.dart';
import 'package:safe_event/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuestService {
  final String apiUrl = ApiConfig.baseUrl;
  final authService = AuthService();

  Future<List<Guest>> getGuests(int eventId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    if (token == null) {
      throw Exception('No token available');
    }

    final response = await http.get(
      Uri.parse('$apiUrl/events/$eventId/guests'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      Iterable<dynamic> guestList = json.decode(response.body);
      List<Guest> guests =
          guestList.map((json) => Guest.fromJson(json)).toList();
      return guests;
    }

    if (response.statusCode == 403) {
      print("Token expirou para convidados, chamando o refresh");
      await authService.refreshToken();
      token = sharedPreferences.getString('token');
      if (token == null) {
        throw Exception('Falha ao renovar o token');
      }

      return getGuests(eventId);
    }

    throw Exception('Failed to load guests (${response.statusCode})');
  }
}
