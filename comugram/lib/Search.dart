import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comugram/Category.dart';
import 'package:comugram/services/FirestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'model/Joined.dart';
import 'model/Komunitas.dart';
import 'model/User.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  FocusNode _focusNodeSearch;
  TextEditingController search = TextEditingController();
  List<Komunitas> listKomunitas = new List();
  List<Joined> listJoined = List();
  List<Joined> listJoinedUser = List();
  List<Widget> listSearch = new List();
  List<User> usr = new List();
  bool finish = false;
  Future<User> userProfile(String id) async {
    User profile;
    await Firestore.instance
        .collection('User')
        .document(id)
        .get()
        .then((snapshot) {
      setState(() {
        usr.add(User.fromMap(snapshot.data));
      });
    });
  }

  Future<void> getKomunitasDataPopuler() async {
    await Firestore.instance.collection('Komunitas').snapshots().listen((s) {
      for (var d in s.documents) {
        listKomunitas.add(Komunitas(
          uid: d['id'],
          deskripsi: d['deskripsi'],
          imageUrl: d['imageUrl'],
          kategori: d['kategori'],
          namaKomunitas: d['namaKomunitas'],
          owner: d['owner'],
          tanggalBuat: d['tanggalBuat'],
        ));
      }
      finish = true;
    });
  }

  Future<List<Joined>> getJoinedUserInKomunitas(String idKom) async {
    print(idKom);
    listJoinedUser = [];
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    await Firestore.instance
        .collection("joined")
        .where('id_komunitas', isEqualTo: idKom)
        .getDocuments()
        .then((snapshot) {
      for (var data in snapshot.documents) {
        listJoinedUser.add(
          Joined(
            uid: data['id_user'],
            kom_id: data['id_komunitas'],
          ),
        );
        print(data['id_user']);
      }
    });

    setState(() {});
    return listJoinedUser;
  }

  Future<void> getJoinedKomunitas() async {
    listJoined = [];
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Firestore.instance.collection('joined').snapshots().listen(
      (s) {
        s.documents.forEach(
          (d) {
            if (d['id_user'] == user.uid) {
              listJoined.add(
                Joined(
                  uid: d['id_user'],
                  kom_id: d['id_komunitas'],
                ),
              );
            }
          },
        );
      },
    );
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _focusNodeSearch.dispose();
  }

  @override
  void initState() {
    getJoinedKomunitas().then((s) {
      setState(() {});
    });
    super.initState();
    getKomunitasDataPopuler().then((s) {
      setState(() {});
    });
    _focusNodeSearch = new FocusNode();
    _focusNodeSearch.addListener(_onOnFocusNodeEvent);
  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  Color getPrefixIconColorSearch() {
    return _focusNodeSearch.hasFocus ? Colors.black : Colors.grey;
  }

  Route _createRouteCategory(String cat) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Category(cat),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  Widget categoryCard(String text, String image, String cat) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(_createRouteCategory(cat));
        },
        child: Container(
          width: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: ExactAssetImage(image),
                radius: 18,
                backgroundColor: Colors.grey.withOpacity(0.15),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    listSearch = [];
    listPage();
    return OKToast(
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    focusNode: _focusNodeSearch,
                    controller: search,
                    onEditingComplete: () {},
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (val) {
                      listKomunitas = [];
                      searchComunity(val);
                      setState(() {});
                    },
                    onChanged: (val) {
                      finish = false;
                      if (val == "") {
                        listKomunitas = [];
                        searchComunity(val);
                        setState(() {});
                      }
                    },
                    autofocus: false,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: getPrefixIconColorSearch(),
                      ),
                      contentPadding: EdgeInsets.all(15.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusColor: Colors.orange,
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      hintText: "Cari",
                      fillColor: Color.fromRGBO(245, 245, 245, 1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 15.0,
                    ),
                    child: searchPage(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void searchComunity(String s) async {
    FirestoreServices firestoreServices = FirestoreServices();
    listKomunitas = await firestoreServices.cariKomunitas(s);
    finish = true;
    setState(() {});
  }

  void _showDialog(String desc, String img, String name, String id) {
    bool status = true;
    listJoined.forEach((idJoined) {
      status = idJoined.kom_id != id;
    });

    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                titlePadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
                elevation: 3,
                shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                title: ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.all(0),
                  title: Container(
                    width: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(
                        img,
                        fit: BoxFit.cover,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                      textScaleFactor: 1,
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 6.0),
                      child: InkWell(
                        onTap: () async {
                          ProgressDialog pD = ProgressDialog(
                            context,
                            type: ProgressDialogType.Normal,
                            isDismissible: false,
                          );
                          await pD.show();
                          _showDialogPengikut(id, pD);
                        },
                        child: Text(
                          'Lihat Pengikut',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7.0,
                    ),
                    Container(
                      height: 150,
                      child: SingleChildScrollView(
                        child: Text(desc),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  status
                      ? RaisedButton(
                          color: Colors.orange,
                          child: Text(
                            'Ikuti Komunitas',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () async {
                            FirebaseUser user =
                                await FirebaseAuth.instance.currentUser();
                            FirestoreServices firestoreServices =
                                new FirestoreServices();
                            firestoreServices.gabungKomunitas(id, user.uid);
                            Navigator.pop(context);
                            showToast(
                              'Berhasil mengikuti komunitas ${name}',
                              duration: Duration(seconds: 2),
                              position: ToastPosition.bottom,
                              backgroundColor: Colors.black.withOpacity(0.7),
                              radius: 10.0,
                              textStyle: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            );
                            setState(() {});
                          },
                        )
                      : RaisedButton(
                          color: Colors.orange,
                          child: Text(
                            'Keluar Komunitas',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () async {
                            FirebaseUser user =
                                await FirebaseAuth.instance.currentUser();
                            FirestoreServices firestoreServices =
                                new FirestoreServices();
                            firestoreServices.keluarKomunitas(id, user.uid);
                            Navigator.pop(context);
                            showToast(
                              'Berhenti mengikuti komunitas ${name}',
                              duration: Duration(seconds: 2),
                              position: ToastPosition.bottom,
                              backgroundColor: Colors.black.withOpacity(0.7),
                              radius: 10.0,
                              textStyle: TextStyle(
                                  fontSize: 16.0, color: Colors.white),
                            );
                            setState(
                              () {
                                getJoinedKomunitas();
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  void listPage() {
    listSearch = [];
    listKomunitas.forEach(
      (data) {
        listSearch.add(
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: InkWell(
              onTap: () {
                _showDialog(
                  data.deskripsi,
                  data.imageUrl,
                  data.namaKomunitas,
                  data.uid,
                );
              },
              child: Card(
                elevation: 5,
                child: Container(
                  height: 120,
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 120,
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(5),
                              topLeft: Radius.circular(5),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(data.imageUrl),
                              fit: BoxFit.cover,
                            )),
                      ),
                      Container(
                        height: 100,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data.namaKomunitas,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: InkWell(
                                  onTap: () async {
                                    ProgressDialog pD = ProgressDialog(
                                      context,
                                      type: ProgressDialogType.Normal,
                                      isDismissible: false,
                                    );
                                    await pD.show();
                                    _showDialogPengikut(data.uid, pD);
                                  },
                                  child: Text(
                                    'Lihat Pengikut',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 260,
                                child: Text(data.deskripsi),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDialogPengikut(String id, ProgressDialog pD) async {
    usr = [];
    await getJoinedUserInKomunitas(id);
    for (var x in listJoinedUser) {
      await userProfile(x.uid);
    }
    await pD.hide();

    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                titlePadding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
                elevation: 3,
                shape: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                title: Text('List pengikut (${usr.length})'),
                content: ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Container(
                    height: 500.0,
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: ListView.separated(
                      padding: EdgeInsets.all(0),
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.grey,
                        );
                      },
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {},
                          contentPadding: EdgeInsets.all(0),
                          dense: true,
                          leading: CircleAvatar(
                            backgroundImage: usr[index].urlProfile != null
                                ? NetworkImage(usr[index].urlProfile)
                                : ExactAssetImage('images/user.png'),
                            radius: 20,
                            backgroundColor: Colors.grey.withOpacity(0.15),
                          ),
                          title: Text(
                            usr[index].namaLengkap,
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      },
                      itemCount: usr.length,
                    ),
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      'Tutup',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }

  Widget searchPage() {
    print(finish);
    setState(() {});
    return search.text.length == 0
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Text(
                  'Comu Kategori',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 80,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      categoryCard('Gaming', 'images/gaming.png', 'Gaming'),
                      categoryCard('Masak', 'images/kitchen.png', 'Masak'),
                      categoryCard('Olahraga', 'images/sport.png', 'Olahraga'),
                      categoryCard('Belajar', 'images/study.png', 'Belajar'),
                      categoryCard('Liburan', 'images/liburan.png', 'Liburan'),
                      categoryCard(
                          'Kesehatan', 'images/health.png', 'Kesehatan'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Populer',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                listKomunitas.length == 0
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: listSearch,
                      ),
              ])
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              finish ?
              listKomunitas.length == 0 ?
              Text('Belum ada komunitas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),) : Column(
                children: listSearch,
              ) :Center(
                child: CircularProgressIndicator(),
              )
            ],
          );
  }
}
