import 'package:flutter/material.dart';
import 'package:safe_event/assets/images/colors/my_colors.dart';
import 'package:safe_event/screens/events_screen.dart';
import 'package:safe_event/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPage();
}

class _SplashPage extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  _startTimer() async {
    await Future.delayed(const Duration(seconds: 3));

    verifyToken().then((tokens) {
      if (tokens['token'] != null && tokens['refreshToken'] != null) {
        // Se ambos os tokens existirem, redirecione para a página do dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(
              businessName: "teste",
              businessLogo:
                  'C:/Users/Micro/OneDrive/Projetos/Evento Seguro/safe_event/lib/assets/images/assuncaofestas.jpg',
            ),
          ),
        );
      } else {
        // Se algum dos tokens estiver faltando, redirecione para a página de login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'C:/Users/Micro/OneDrive/Projetos/Evento Seguro/safe_event/lib/assets/images/assuncaofestas.jpg',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Deixando tudo pronto...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<Map<String, String?>> verifyToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    String? refreshToken = sharedPreferences.getString('refreshToken');

    return {'token': token, 'refreshToken': refreshToken};
  }
}
