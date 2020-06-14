import 'package:comugram/model/Komunitas.dart';
import 'package:comugram/model/Post.dart';
import 'package:comugram/services/FirestoreServices.dart';
import 'package:flutter/material.dart';

class DetailCommunity extends StatefulWidget {
  Komunitas komunitas;
  DetailCommunity({this.komunitas});

  @override
  State<StatefulWidget> createState() => _DetailCommunityState();
}

class _DetailCommunityState extends State<DetailCommunity> {
  FirestoreServices firestoreServices;
  List<Post> post = List<Post>();
  @override
  void initState() {
    super.initState();

    firestoreServices = FirestoreServices();
    getPost();
    setState(() {});
  }

  void getPost() async {
    post = await firestoreServices.getPostKomunitas(widget.komunitas.uid);
    setState(() {});
    print(post.length);
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    Padding header(Post post) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
        child: Row(
          children: <Widget>[
            Container(
              height: 40.0,
              width: 40.0,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: new NetworkImage(
                      "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg"),
                ),
              ),
            ),
            new SizedBox(
              width: 10.0,
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
                    post.location,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }

    Padding footer(Post post) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                children: <Widget>[
                  Text("wayan ganteng",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(post.caption),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: GestureDetector(
                  child: Text(
                    'View all comments',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: () {},
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(post.tanggalBuat,
                    style: TextStyle(color: Colors.grey)),
              )
            ]),
      );
    }

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Image.asset(
          'images/comugram logo 4.png',
          width: 120,
          height: 40,
        ),
      ),
      body: ListView.builder(
        itemCount: post.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              header(post[index]),
              Flexible(
                fit: FlexFit.loose,
                child: new Image.network(
                  post[index].imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              footer(post[index]),
            ],
          );
        },
      ),
    );
  }
}
