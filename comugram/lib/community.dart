import 'package:flutter/material.dart';

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController searchController = new TextEditingController();

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  onSearchTextChanged(String text) async {}

  @override
  Widget build(BuildContext context) {
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
        itemCount: 15,
        itemBuilder: (BuildContext context, int index) {
          return Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Image.asset(
                      'images/dummy.jpg',
                      width: 50,
                    ),
                    title: Text(
                      'Pecinta Wanita',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
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
