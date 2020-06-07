import 'package:comugram/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'model/User.dart';

class MainMenu extends StatefulWidget{
  @override
  State createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MainMenu'),
      ),
      body: Column(
        children: <Widget>[
          Text("Hello, "),
          Padding (
            padding: EdgeInsets.only(top: 15.0,bottom:15.0),
            child: Row(
              children: <Widget> [
                // tombol simpan
                Expanded(
                  child: Material(
                    elevation: 1.0,
                    color: Color.fromRGBO(255, 153, 0, 1),
                    child: MaterialButton(
                      onPressed: () async{
                        FirebaseAuth.instance.signOut();
                        FirebaseUser user = await FirebaseAuth.instance.currentUser();
                        runApp(
                          MaterialApp(
                            home: Login(),
                          )
                        );
                      },
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                      child: Text('SIGN OUT',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}