import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comugram/services/FirestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'model/Joined.dart';
import 'model/Komunitas.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  FocusNode _focusNodeSearch;
  TextEditingController search = TextEditingController();
  List<Komunitas> listKomunitas = new List();
  List<Joined> listJoined = List();
  List<Widget> listSearch = new List();

  Future<void> getKomunitasDataPopuler() async {
    await Firestore.instance.collection('Komunitas').snapshots().listen((s) {
      s.documents.forEach((d) {
        listKomunitas.add(Komunitas(
          uid: d['id'],
          deskripsi: d['deskripsi'],
          imageUrl: d['imageUrl'],
          kategori: d['kategori'],
          namaKomunitas: d['namaKomunitas'],
          owner: d['owner'],
          tanggalBuat: d['tanggalBuat'],
        ));
      });
    });
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
                  idKom: d['id_komunitas'],
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

  Widget categoryCard(String text, String image) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {},
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
                    onChanged: (val) {
                      listKomunitas = [];
                      searchComunity(val);
                      setState(() {});
                    },
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
    setState(() {
    });
  }

  void _showDialog(String desc, String img, String name, String id) {
    bool status = true;
    listJoined.forEach((idJoined) {
      status = idJoined.idKom != id;
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
                    width: 200,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: ExactAssetImage('images/dummy.jpg'),
                          radius: 12,
                          backgroundColor: Colors.grey.withOpacity(0.15),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        CircleAvatar(
                          backgroundImage: ExactAssetImage('images/dummy.jpg'),
                          radius: 12,
                          backgroundColor: Colors.grey.withOpacity(0.15),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        CircleAvatar(
                          backgroundImage: ExactAssetImage('images/dummy.jpg'),
                          radius: 12,
                          backgroundColor: Colors.grey.withOpacity(0.15),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          '+18 Lainnya',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      ],
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
                              Container(
                                  width: 260,
                                  margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage:
                                            ExactAssetImage('images/dummy.jpg'),
                                        radius: 12,
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.15),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      CircleAvatar(
                                        backgroundImage:
                                            ExactAssetImage('images/dummy.jpg'),
                                        radius: 12,
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.15),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      CircleAvatar(
                                        backgroundImage:
                                            ExactAssetImage('images/dummy.jpg'),
                                        radius: 12,
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.15),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '+18 Lainnya',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    ],
                                  )),
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

  Widget searchPage() {
    setState(() {
    });
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
                      categoryCard('Gaming', 'images/gaming.png'),
                      categoryCard('Masak', 'images/kitchen.png'),
                      categoryCard('Olahraga', 'images/sport.png'),
                      categoryCard('Belajar', 'images/study.png'),
                      categoryCard('Liburan', 'images/liburan.png'),
                      categoryCard('Kesehatan', 'images/health.png'),
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
              listKomunitas.length == 0
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: listSearch,
                    ),
            ],
          );
  }
}
