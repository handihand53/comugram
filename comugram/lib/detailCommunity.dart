import 'package:flutter/material.dart';

class DetailCommunity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DetailCommunityState();
}

class _DetailCommunityState extends State<DetailCommunity> {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    Padding header = Padding(
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
    );

    Padding footer = Padding(
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
                  child: Text("hati sedang baik-baik saja"),
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
              child: Text("1 Day Ago", style: TextStyle(color: Colors.grey)),
            )
          ]),
    );
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
        itemCount: 4,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              header,
              Flexible(
                fit: FlexFit.loose,
                child: new Image.network(
                  "https://images.pexels.com/photos/672657/pexels-photo-672657.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                  fit: BoxFit.cover,
                ),
              ),
              footer,
            ],
          );
        },
      ),
    );
  }
}
