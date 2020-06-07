import 'package:comugram/RegisterForm.dart';
import 'package:flutter/material.dart';

import 'Login.dart';
import 'ResetPassword.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => Login(),
        '/register': (context) => RegisterForm(),
        '/resetPassword': (context) => ResetPassword(),
      },
    );
  }
}