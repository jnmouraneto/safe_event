import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:safe_event/screens/splash_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Questrial'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      //home: GuestPage(),
      
      home: SplashPage(),
      //home: DashboardPage(businessName: "Assunção Eventos", businessLogo: "C:/Users/Micro/OneDrive/Projetos/Evento Seguro/safe_event/assuncaofestas.jpg"),
    );
  }
}
