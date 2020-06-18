import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comugram/CommentPage.dart';
import 'package:comugram/MapsDetail.dart';
import 'package:comugram/model/Komunitas.dart';
import 'package:comugram/model/User.dart';
import 'package:comugram/services/FirestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/Post.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Widget> listOfData = new List();
  List<Widget> listOfData2 = new List();
  List<Widget> allData = new List();
  List<List<Post>> postAllUser = List();
  List<Post> postAllUser2 = List<Post>();
  List<Komunitas> kom = List();
  ScrollController _scrollController = new ScrollController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirestoreServices firestoreServices;
  User profile;
  bool finish = false;
  DocumentSnapshot _lastDocument;
  int idxKom = 0;
  int count = 0;
  int countAddData = 0;
  bool startAgain = false;
  bool getMoreItems = false;
  bool moreItemsAvailable = true;
  bool statusLoad = false;
  int jumlahPost = 0;

  Future<User> userProfile(String id) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance
        .collection('User')
        .document(id)
        .get()
        .then((snapshot) {
      setState(() {
        profile = User.fromMap(snapshot.data);
      });
    });
  }

  List<InlineSpan> listOfText(String s, String idPost) {
    List<TextSpan> textSpan = new List();

    textSpan.add(
      TextSpan(
        text: "${profile.username} ",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    if (s.length > 10000) {
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
            ..onTap = () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CommentPage(idPost))),
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
        text: '\nLihat komentar',
        style: TextStyle(
          color: Colors.grey,
          height: 1.5,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => CommentPage(idPost))),
      ),
    );

    return textSpan;
  }

  @override
  void initState() {
    getData().then((x) {
      print('get data');
    });

    firestoreServices = FirestoreServices();
    super.initState();
//    WidgetsBinding.instance
//        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<void> getData() async {
    FirebaseUser user = await _auth.currentUser();
    String uid = user.uid;

    kom = [];
    kom = await firestoreServices.getJoinedKomunitas(uid);
    addData(kom).then((x) {
      setState(() {});
    });
  }

  Future<void> getFirstData(List<Komunitas> kom) async {
    if (moreItemsAvailable == false) {
      print('no more products');
      return;
    }
    getMoreItems = true;

    QuerySnapshot limit = await Firestore.instance
        .collection("post")
        .document(kom[idxKom].uid)
        .collection("items")
        .getDocuments();

    Query q = Firestore.instance
        .collection("post")
        .document(kom[idxKom].uid)
        .collection("items")
        .orderBy("id_post")
        .limit(2);

    QuerySnapshot querySnapshot = await q.getDocuments();

    querySnapshot.documents.forEach((f) {
      Map<String, dynamic> temp = f.data;
      postAllUser2.add(Post.fromMap(temp));
      countAddData++;
      jumlahPost++;
      if (jumlahPost >= limit.documents.length) {
        jumlahPost = 0;
        idxKom++;
        startAgain = true;
        print('pindah index 2');
      }
    });

    if (querySnapshot.documents.length < 1) {
      moreItemsAvailable = false;
    }

    _lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];

    getMoreItems = false;
  }

  Future<void> getFirstData2(List<Komunitas> kom) async {
    if (moreItemsAvailable == false) {
      print('no more products');
      return;
    }
    getMoreItems = true;

    QuerySnapshot limit = await Firestore.instance
        .collection("post")
        .document(kom[idxKom].uid)
        .collection("items")
        .getDocuments();

    Query q = Firestore.instance
        .collection("post")
        .document(kom[idxKom].uid)
        .collection("items")
        .orderBy("id_post")
        .limit(1);

    QuerySnapshot querySnapshot = await q.getDocuments();

    querySnapshot.documents.forEach((f) {
      Map<String, dynamic> temp = f.data;
      postAllUser2.add(Post.fromMap(temp));
      print(Post.fromMap(temp).caption);
      countAddData++;
      jumlahPost++;
      if (jumlahPost >= limit.documents.length) {
        print('jumlahPost ${jumlahPost}');
        print('limit.documents.length ${limit.documents.length}');
        idxKom++;
        jumlahPost = 0;
        startAgain = true;
        print('pindah index 3');
      }
    });

    if (querySnapshot.documents.length < 1) {
      moreItemsAvailable = false;
    }

    _lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];

    getMoreItems = false;
  }

  Future<List<List<Post>>> addData(List<Komunitas> kom) async {
    countAddData = 0;
    while (countAddData < 2 &&
        idxKom + 1 <= kom.length &&
        moreItemsAvailable != false) {
      await getFirstData(kom);
    }

    postAllUser.add(postAllUser2);
    getList().then((d) {
      allData = [];
      allData = d;
      finish = true;
    });

    return postAllUser;
  }

  Future<List<List<Post>>> addData2(List<Komunitas> kom) async {
    statusLoad = true;
    countAddData = 0;
    while (countAddData < 1 &&
        idxKom + 1 <= kom.length &&
        moreItemsAvailable != false) {
      print('MASUK ANJENG');
      print(countAddData);
      await getFirstData2(kom);
    }

//    postAllUser.add(postAllUser2);

    getList().then((d) {
      allData = [];
      allData = d;
      finish = true;
    });

    return postAllUser;
  }

  Future<void> getDataAfter(List<Komunitas> kom) async {
    if (moreItemsAvailable == false) {
      print('no more products');
      return;
    }
    getMoreItems = true;

    QuerySnapshot limit = await Firestore.instance
        .collection("post")
        .document(kom[idxKom].uid)
        .collection("items")
        .getDocuments();

    Query q = Firestore.instance
        .collection("post")
        .document(kom[idxKom].uid)
        .collection("items")
        .orderBy("id_post")
        .startAfterDocument(_lastDocument)
        .limit(1);
    QuerySnapshot querySnapshot = await q.getDocuments();

    querySnapshot.documents.forEach((f) {
      Map<String, dynamic> temp = f.data;
      postAllUser2.add(Post.fromMap(temp));
      count++;
      jumlahPost++;
      if (jumlahPost > limit.documents.length - 1) {
        jumlahPost = 0;
        idxKom++;
        startAgain = true;
        print('pindah index 1');
      }
    });

    if (querySnapshot.documents.length < 1) {
      moreItemsAvailable = false;
    }
    _lastDocument = querySnapshot.documents[querySnapshot.documents.length - 1];

    getMoreItems = false;
  }

  Future<List<List<Post>>> addMoreData(List<Komunitas> kom) async {
    statusLoad = true;
    count = 0;
    while (
        count < 1 && idxKom + 1 <= kom.length && moreItemsAvailable != false) {
      print('asd');
      await getDataAfter(kom);
      count++;
    }

    getList().then((d) {
      allData = [];
      allData = d;
      finish = true;
    });

    return postAllUser;
  }

  Future<List<Widget>> getList() async {
    List<Widget> data = new List();
    for (var f in postAllUser) {
      for (var x in f) {
        await userProfile(
          x.id_user,
        );
        data.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: <Widget>[
                profile.urlProfile == null
                    ? CircleAvatar(
                        backgroundImage: ExactAssetImage('images/user.png'),
                        radius: 18,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(profile.urlProfile),
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
                      "${profile.username} ",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MapsDetail(
                                  desc: x.location, id: x.location_id))),
                      child: Text(
                        x.location,
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

        data.add(
          Image.network(
            (x.imageUrl),
            fit: BoxFit.cover,
          ),
        );

        data.add(
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                ),
                children: listOfText(x.caption, x.id_post),
              ),
            ),
          ),
        );

        data.add(
          Padding(
            padding: EdgeInsets.only(left: 7.0),
            child: Text(
              x.tanggalBuat,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.black,
              ),
            ),
          ),
        );
      }
    }
    statusLoad = false;
    return data;
  }

  @override
  Widget build(BuildContext context) {
//    print(postAllUser.length);
//    postAllUser.forEach((s){
//      print(s.length);
//      s.forEach((d){
//        print(d.caption);
//      });
//    });
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: NotificationListener(
        // ini untuk listen scroll, nantinya digunakan untuk infinity scroll
        child: ListView(
          controller: _scrollController,
          children: finish
              ? allData.length == 0
                  ? <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 300,
                          ),
                          Center(
                            child: Text(
                              'Belum ada postingan',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ]
                  : allData
              : <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
        ),
        onNotification: (t) {
          if (t is ScrollEndNotification) {
            if (_scrollController.position.maxScrollExtent ==
                    _scrollController.position.pixels &&
                statusLoad == false) {
              if (startAgain) {
                print('if (index beda)');
                addData2(kom);
                startAgain = false;
//                postAllUser2 = [];
              } else {
                addMoreData(kom);
                print('else (index sama)');
              }
              print('idxKom ${idxKom}');
            }
          }
        },
      ),
    );
  }

  // untuk logic nantinya ketika user melakukan refresh
  Future<Null> _refresh() {
    finish = false;
    idxKom = 0;
    count = 0;
    countAddData = 0;
    startAgain = false;
    getMoreItems = false;
    moreItemsAvailable = true;
    postAllUser2 = [];
    listOfData = [];
    listOfData2 = [];
    allData = [];
    postAllUser = [];
    kom = [];
    return getData().then((x) {
      setState(() {});
    });
  }
}
