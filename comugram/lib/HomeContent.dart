import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Widget> listOfData = new List();
  ScrollController _scrollController = new ScrollController();

  List<InlineSpan> listOfText() {
    String s =
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';
    List<TextSpan> textSpan = new List();

    textSpan.add(
      TextSpan(
        text: 'Albert Einstein ',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    if (s.length > 100) {
      textSpan.add(
        TextSpan(
          text: s.substring(0, 112),
          style: TextStyle(
            height: 1.3,
          ),
        ),
      );

      TextSpan more = TextSpan(
        text: ' ... more\n',
        style: TextStyle(
          color: Colors.grey,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => print('Tap Here onTap'),
      );

      textSpan.add(more);

      textSpan.add(
        TextSpan(
          text: 'Lihat komentar\n',
          style: TextStyle(
            color: Colors.grey,
            height: 1.5,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => print('Ini komentar'),
        ),
      );

      textSpan.add(
        TextSpan(
          text: '20 Januari 2020',
          style: TextStyle(
            color: Colors.grey,
            height: 1.5,
          ),
        ),
      );
      return textSpan;
    }

    textSpan.add(
      TextSpan(
        text: s,
        style: TextStyle(
          height: 1.3,
        ),
      ),
    );

    textSpan.add(
      TextSpan(
        text: 'Lihat komentar',
        style: TextStyle(
          color: Colors.grey,
          height: 1.5,
        ),
      ),
    );

    return textSpan;
  }

  @override
  void initState() {
    getList();
    super.initState();
//    WidgetsBinding.instance
//        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  void getList() {
    // foreach
    for (int i = 0; i < 10; i++) {
      listOfData.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: ExactAssetImage('images/dummy.jpg'),
//                        FileImage(File(imgUrl))
                radius: 18,
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Albert Einstein',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () => print('tes'),
                    child: Text(
                      'Yogyakarta',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );

      listOfData.add(
        Image.asset(
          ('images/sepeda.jpg'),
          fit: BoxFit.cover,
        ),
      );

      listOfData.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
              ),
              children: listOfText(),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: NotificationListener( // ini untuk listen scroll, nantinya digunakan untuk infinity scroll
        child: ListView(
          controller: _scrollController,
          children:
              listOfData,
        ),
        onNotification: (t) {
          if (t is ScrollEndNotification) {
            print(_scrollController.position.maxScrollExtent); // detect max scroll
            print(_scrollController.position.pixels); //detect current heigt pixels
          }
        },
      ),
    );
  }

  // untuk logic nantinya ketika user melakukan refresh
  // karena belum ada logic jadi masih ada error
  Future<Null> _refresh() {
    setState(() {});
    return null;
  }
}
