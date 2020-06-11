import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class IntroductionPage extends StatefulWidget {
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  _buildBody() {
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            _buildPageView(),
            _buildCircleIndicator(),
          ],
        ),
      ],
    );
  }

  _buildPageView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: PageView(
        controller: _pageController,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 170,
                ),
                Image.asset(
                  'images/intro1.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'SELAMAT DATANG DI COMUGRAM!',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Aplikasi komunitas terbaik di Indonesia!\nGabung dan buat komunitasmu sendiri dengan Comugram.',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            color: Colors.white,
          ),
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 170,
                ),
                Image.asset(
                  'images/intro2.png',
                  width: 350,
                  height: 350,
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  'BERAGAM KOMUNITAS ADA DI COMUGRAM!',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  ' Dengan Comugram, kamu bisa menemukan lebih dari satu komunitas dan mengikutinya',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
            color: Colors.white,
          ),
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 170,
                ),
                Image.asset(
                  'images/intro3.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'BERAGAM KOMUNITAS ADA DI COMUGRAM!',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Dengan Comugram, kamu bisa menemukan lebih dari 1 komunitas dan mengikutinya',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  color: Colors.white,
                  child: Text(
                    'SELANJUTNYA',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                )
              ],
            ),
            color: Colors.white,
          ),
        ],
        onPageChanged: (int index) {
          _currentPageNotifier.value = index;
        },
      ),
    );
  }

  _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          dotColor: Colors.grey,
          selectedDotColor: Colors.orange,
          itemCount: 3,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }
}
