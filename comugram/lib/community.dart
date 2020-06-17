import 'package:comugram/detailCommunity.dart';
import 'package:comugram/model/Post.dart';
import 'package:comugram/model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'model/Komunitas.dart';
import 'model/Komunitas.dart';
import 'model/Komunitas.dart';
import 'services/FirestoreServices.dart';
import 'services/FirestoreServices.dart';

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController searchController = new TextEditingController();
  FirestoreServices firestoreServices;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Komunitas> komunitas = List<Komunitas>();
  bool isEmpy = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    firestoreServices = FirestoreServices();
    onSearchTextChanged();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print("sscrol");
      }
    });
    setState(() {});
  }

  // void _scrollListener() {
  //   if (controller.offset >= controller.position.maxScrollExtent &&
  //       !controller.position.outOfRange) {
  //     print("at the end of list");
  //   }
  // }

  void printDtaa() async {
    print("data");
  }

  // void getKomunitas() async {
  //   FirebaseUser user = await _auth.currentUser();
  //   String owner = user.uid;
  //   komunitas = await firestoreServices.getJoinedKomunitas(owner);
  //   print(komunitas.length);
  //   if (komunitas.length == 0) isEmpy = true;
  //   setState(() {});
  // }

  Future<void> onSearchTextChanged() async {
    FirebaseUser user = await _auth.currentUser();
    String owner = user.uid;
    komunitas = searchController.text.length > 0
        ? await firestoreServices.cariKomunitasJoined(
            searchController.text, owner)
        : await firestoreServices.getJoinedKomunitas(owner);
    komunitas.length == 0 ? isEmpy = true : isEmpy = false;
    setState(() {});
  }

  void _showDialogPengikut(String id, ProgressDialog pD) async {
    List<User> usr = await firestoreServices.getJoinedPeople(id);
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

  showAlert(BuildContext context, Komunitas kom) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Row contentHeader = Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Image.network(
                  kom.imageUrl,
                  width: 100,
                  height: 150,
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    direction: Axis.vertical,
                    spacing: 4.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: <Widget>[
                      Text(
                        kom.namaKomunitas,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          ProgressDialog pD = ProgressDialog(
                            context,
                            type: ProgressDialogType.Normal,
                            isDismissible: false,
                          );
                          await pD.show();
                          _showDialogPengikut(kom.uid, pD);
                        },
                        child: Text(
                          'Lihat Pengikut',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          print("uid: " + kom.uid);
                          Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailCommunity(komunitas: kom)));
                        },
                        child: Text(
                          "Lihat",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.orange,
                      ),
                      Text(
                        kom.namaOwner,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        kom.tanggalBuat,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );

          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    contentHeader,
                    Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      kom.deskripsi,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () async {
                          print(kom.joinedId);
                          await firestoreServices.unjoinKomunitas(kom.joinedId);
                          _refresh();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Berhenti Mengikuti",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.orange,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Card search = Card(
      child: ListTile(
        leading: Icon(Icons.search),
        title: TextFormField(
          controller: searchController,
          decoration:
              new InputDecoration(hintText: 'Search', border: InputBorder.none),
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (val) {
            komunitas = List<Komunitas>();
            setState(() {});
            onSearchTextChanged();
          },
        ),
        trailing: new IconButton(
          icon: new Icon(Icons.cancel),
          onPressed: () {
            searchController.clear();
            isEmpy = false;
            komunitas = List<Komunitas>();
            setState(() {});
            onSearchTextChanged();
          },
        ),
      ),
    );

    Container contentSearch = Container(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'komunitas Anda',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          search,
        ],
      ),
    );

    ListView content = ListView.builder(
        itemCount: komunitas.length,
        //controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Card(
              child: GestureDetector(
                onTap: () {
                  showAlert(context, komunitas[index]);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Image.network(
                        komunitas[index].imageUrl,
                        width: 50,
                      ),
                      title: Text(
                        komunitas[index].namaKomunitas,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: InkWell(
                        onTap: () async {
                          ProgressDialog pD = ProgressDialog(
                            context,
                            type: ProgressDialogType.Normal,
                            isDismissible: false,
                          );
                          await pD.show();
                          _showDialogPengikut(komunitas[index].uid, pD);
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
                  ],
                ),
              ),
            ),
          );
        });

    RefreshIndicator listComunnity = RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: content,
    );
    // TODO: implement build
    var children2 = <Widget>[
      contentSearch,
      komunitas.length == 0
          ? Center(
              child: isEmpy == true
                  ? Text(
                      'Belum ada Komunitas',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  : CircularProgressIndicator(),
            )
          : Expanded(child: listComunnity),
    ];
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children2,
      ),
    );
  }

  Future<void> _refresh() {
    //print("refresh");
    komunitas = List<Komunitas>();
    setState(() {});
    return onSearchTextChanged();
  }
}
