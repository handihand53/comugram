import 'package:comugram/HomeContent.dart';
import 'package:comugram/community.dart';
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
  bool _showAppbar = true;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

      // untuk hidden appbar
      // index didapat dari setiap user melakukan click pada bottom navigation
      // halaman yg ditempelkan pada tampilan bisa di liat di list<widget> _children

      if (_currentIndex != 1) {
        _showAppbar = true;
      } else {
        _showAppbar = false;
      }
    });
  }

  // tolong nanti di ganti bagian ini
  // ada 5 halaman
  // sesuai index : 0, 1, 2, 3, 4
  // 0: homeContent (handi)
  // 1: searchPage (handi)
  // 2: addPostPage (wayan)
  // 3: komunitasPage (wayan)
  // 4: akunPage (wilhel)
  final List<Widget> _children = [
    HomeContent(),
    Search(),
    HomeContent(),
    Community(),
    HomeContent(),
    ProfileContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppbar
          ? AppBar(
              backgroundColor: Colors.orange,
              title: Image.asset(
                'images/comugram logo 4.png',
                width: 120,
                height: 40,
              ),
            )
          : PreferredSize(
              child: Container(),
              preferredSize: Size(0.0, 0.0),
            ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
            title: Text('Tambah'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Komunitas'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Akun'),
          ),
        ],
      ),
    );
  }
}
