import 'package:comugram/HomeContent.dart';
import 'package:comugram/ProfileContent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Login.dart';
import 'ResetPassword.dart';
import 'Search.dart';
import 'model/User.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      print(index);
      _currentIndex = index;
    });
  }

  final List<Widget> _children = [
    HomeContent(),
    Search(),
    HomeContent(),
    HomeContent(),
    ProfileContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex == 4 ? null : AppBar(
        backgroundColor: Colors.orange,
        title: Image.asset(
          'images/comugram logo 4.png',
          width: 120,
          height: 40,
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type : BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Beranda'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Cari'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              title: Text('Tambah')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text('Komunitas')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Akun')
          ),
        ],
      ),
    );
  }
}
