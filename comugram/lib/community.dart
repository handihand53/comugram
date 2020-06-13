import 'package:comugram/detailCommunity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  List<Komunitas> komunitas;

  @override
  void initState() {
    firestoreServices = FirestoreServices();
    getKomunitas();
    setState(() {});
  }

  void printDtaa() async {
    print("data");
  }

  void getKomunitas() async {
    FirebaseUser user = await _auth.currentUser();
    String owner = user.uid;
    komunitas = await firestoreServices.getKomunitas(owner);
    print(komunitas.length);
    setState(() {});
  }

  onSearchTextChanged(String text) async {}

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
                      Text(
                        '1000 pengikut',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(
                              this.context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      DetailCommunity()));
                        },
                        child: Text(
                          "Lihat",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.orange,
                      ),
                      Text(
                        kom.owner,
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
                        onPressed: () {},
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
    if (komunitas == null) komunitas = List<Komunitas>();
    Card search = Card(
      child: ListTile(
        leading: Icon(Icons.search),
        title: TextField(
          controller: searchController,
          decoration:
              new InputDecoration(hintText: 'Search', border: InputBorder.none),
          onChanged: onSearchTextChanged,
        ),
        trailing: new IconButton(
          icon: new Icon(Icons.cancel),
          onPressed: () {
            searchController.clear();
            onSearchTextChanged('');
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
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Image.network(
                      komunitas[index].imageUrl,
                      width: 50,
                    ),
                    title: GestureDetector(
                      onTap: () {
                        showAlert(context, komunitas[index]);
                      },
                      child: Text(
                        komunitas[index].namaKomunitas,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      '1000 orang mengikuti komunitas ini',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
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
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          contentSearch,
          Expanded(child: listComunnity),
        ],
      ),
    );
  }

  Future<Null> _refresh() {
    setState(() {});
    return null;
  }
}
