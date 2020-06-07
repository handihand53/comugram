import 'package:comugram/RegisterForm.dart';
import 'package:comugram/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/login': (context) => Login(),
        '/': (context) => SplashScreenPage(),
        '/daftar': (context) => RegisterForm(),
      },
    );
  }
}