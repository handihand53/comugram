import 'package:comugram/CommentPage.dart';
import 'package:comugram/Home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'Login.dart';
import 'TambahKomunitas.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    startSplash();
  }

  startSplash() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, navigationPage);
  }

  Future<void> navigationPage() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (BuildContext context) => Home()));
    } else{
      Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (BuildContext context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(''),
            Center(
              child: Image.asset(
                'images/comugram logo 2.png',
                width: 500,
                height: 450,
              ),
            ),
            Text(
              'Copyright \u00a9 2020 by Comugram\'s Team',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ));
  }
}
