import 'package:comugram/Home.dart';
import 'package:comugram/IntroductionPage.dart';
import 'package:comugram/RegisterForm.dart';
import 'package:comugram/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Login.dart';
import 'ResetPassword.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
        accentColor: Colors.orange,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => SplashScreenPage(),
        '/intro': (context) => IntroductionPage(),
        '/login': (context) => Login(),
        '/home': (context) => Home(),
        '/daftar': (context) => RegisterForm(),
        '/register': (context) => RegisterForm(),
        '/resetPassword': (context) => ResetPassword(),
      },
    );
  }
}