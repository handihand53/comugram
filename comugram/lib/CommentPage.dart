import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comugram/model/Comments.dart';
import 'package:comugram/services/FirestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'model/User.dart';

class CommentPage extends StatefulWidget {
  final String idPost;
  CommentPage(this.idPost);
  @override
  _CommentPageState createState() => _CommentPageState(this.idPost);
}

class _CommentPageState extends State<CommentPage> {
  String idPost;
  _CommentPageState(this.idPost);
  User profile;
  DateTime dateTime = DateTime.now();
  var uuid = Uuid();
  FirestoreServices Fs = FirestoreServices();
  TextEditingController _commentController = TextEditingController();

  Future<List<Comments>> getComments() async {
    List<Comments> _comments = [];
    print(idPost);
    _comments.clear();
    QuerySnapshot data = await Firestore.instance.collection('Comments').orderBy('time').getDocuments();
    data.documents.forEach((DocumentSnapshot doc){
      if(doc['id_post']==idPost){
        _comments.add(Comments.fromDocument(doc));
      }
    });
    print('ini get komen');
    return _comments;
  }

  Future<void> _addComment(String uid, String com) async {
    _commentController.clear();
    await Firestore.instance
        .collection('User')
        .document(uid)
        .get()
        .then((snapshot) {
      profile = User.fromMap(snapshot.data);
    });
    String jam = DateFormat.Hm().format(DateTime.now());
    Comments komentar = Comments(
        id_comment: uuid.v4(),
        id_post: idPost,
        user_id: profile.uid,
        username: profile.username,
        urlProfil: profile.urlProfile,
        comment: com,
        waktu: jam,
        time: Timestamp.now());
    await Fs.InsertDataComment(komentar);
    setState(() {
      getComments();
      buildCommentList();
    });
  }

  Widget buildCommentList() {
    return FutureBuilder<List<Comments>>(
        future: getComments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data,
          );
        });
  }

  @override
  void initState() {
    getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: buildCommentList()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: _commentController,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(20),
                  hintText: 'Tambahkan Komentar'),
              //onFieldSubmitted:,
            ),
            trailing: OutlineButton(
              onPressed: () async {
                if(_commentController.text !=''){
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();
                  await _addComment(user.uid, _commentController.text);
                }
              },
              borderSide: BorderSide.none,
              child: Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}
