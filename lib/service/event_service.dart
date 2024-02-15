// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:safe_event/models/event_model.dart';
// import 'package:safe_event/service/api_config.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ApiServiceEvent {
//  final String apiUrl = ApiConfig.baseUrl;

//   Future<List<Event>> getEvents() async {
//     try{
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     String? token = sharedPreferences.getString('token');
//     if (token != null) {
//       http.Response response = await http.get(
//         Uri.parse(apiUrl),
//         headers: {
//           'User-Agent': 'Android',
//           'Authorization': 'Bearer $token',
//         },
//       );

//     if (response.statusCode == 200) {
//       List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));

//       return jsonList.map((json) => Event.fromJson(json)).toList();
//     } else {
//       print(response.toString());
//       throw Exception('Failed to load events');
//     }

//   }

// }
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:safe_event/models/event_model.dart';
import 'package:safe_event/service/api_config.dart';
import 'package:safe_event/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServiceEvent {
  final String apiUrl = ApiConfig.baseUrl;
  final authService = AuthService();
  Future<List<Event>> getEvents() async {
    String erro = "";
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? token = sharedPreferences.getString('token');

      if (token != null) {
        http.Response response = await http.get(
          Uri.parse('$apiUrl/events/'),
          headers: {
            'User-Agent': 'Android',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          List<dynamic> jsonList = json.decode(utf8.decode(response.bodyBytes));
          return jsonList.map((json) => Event.fromJson(json)).toList();
        }
        //erro de token expirado - chamar o refresh
        if (response.statusCode == 403) {
          print("Token expirou para eventos, chamando o refresh");
           await authService.refreshToken();
           token = sharedPreferences.getString('token');
           if (token == null) {
            throw Exception('Falha ao renovar o token');
          }


          return getEvents();
        }
        else {
          throw Exception('Failed to load events');
        }
      } else {
        throw Exception('Token não encontrado no SharedPreferences');
      }
    } catch (e) {
      print(e);
      return getEvents();
      
    }
  }
}
