import 'package:flutter/widgets.dart';
import 'package:safe_event/controllers/navigation_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpirationController {
  static verifyExpiration(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final isExpirated = sharedPreferences.getString('isExpirated');
    if (isExpirated == 'isExpirated') {
      sharedPreferences.remove('isExpirated');
      print("Mandando pra tela de login ...");
      NavigationController.navigateToLogin(context);
    }
  }

  static setToExpirated() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('isExpirated', 'isExpirated');
  }
}
