//import 'dart:async';
//
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:comugram/model/Comments.dart';
//import 'package:comugram/services/FirestoreServices.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:progress_dialog/progress_dialog.dart';
//import 'package:uuid/uuid.dart';
//import 'model/User.dart';
//
//class CommentPage extends StatefulWidget {
//
//  @override
//  _CommentPageState createState() => _CommentPageState();
//}
//
//class _CommentPageState extends State<CommentPage>{
//  User profile;
//  DateTime dateTime = DateTime.now();
//  var uuid = Uuid();
//  FirestoreServices Fs = FirestoreServices();
//  String idPost;
//  TextEditingController _commentController = TextEditingController();
//
//  Future<List<Comments>> getComments()async{
//    List<Comments> _comments = [];
//    QuerySnapshot data = await Firestore.instance.collection('Comments').where('id_post', isEqualTo: idPost).orderBy('time').getDocuments();
//    _comments.clear();
//    data.documents.forEach((DocumentSnapshot doc){
//      _comments.add(Comments.fromDocument(doc));
//    });
//    return _comments;
//  }
//
//  void _addComment(String uid, String com)async{
//    _commentController.clear();
//    await Firestore.instance.collection('User').document(uid).get().then((snapshot){
//      profile = User.fromMap(snapshot.data);
//    });
//    String jam = DateFormat.Hm().format(DateTime.now());
//    Comments komentar = Comments(id_comment: uuid.v4(),id_post: idPost, user_id: profile.uid,username: profile.username,urlProfil: profile.urlProfile,comment: com, waktu: jam,time: Timestamp.now());
//    Fs.InsertDataComment(komentar);
//  }
//
//  Widget buildCommentList(){
//    return FutureBuilder<List<Comments>>(
//        future: getComments(),
//        builder: (context, snapshot) {
//          if (!snapshot.hasData)
//            return Container(
//                alignment: FractionalOffset.center,
//                child: CircularProgressIndicator());
//          return ListView(
//            children: snapshot.data,
//          );
//        });
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    getComments();
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Comments'),
//      ),
//      body: Column(
//        children: <Widget>[
//          Expanded(
//              child: buildCommentList()
//          ),
//          Divider(),
//          ListTile(
//            title: TextFormField(
//              controller: _commentController,
//              decoration: InputDecoration(
//                  contentPadding: EdgeInsets.all(20),
//                  hintText: 'Tambahkan Komentar'
//              ),
//              //onFieldSubmitted:,
//            ),
//            trailing: OutlineButton(
//              onPressed: ()async{
//                FirebaseUser user = await FirebaseAuth.instance.currentUser();
//                _addComment(user.uid,_commentController.text);
//                Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (BuildContext context) => CommentPage()));
//              },
//              borderSide: BorderSide.none,
//              child: Icon(Icons.send),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//
////class LoadingBridge extends StatefulWidget {
////  @override
////  _LoadingBridge createState() => _LoadingBridge();
////}
////
////class _LoadingBridge extends State<LoadingBridge> {
////  startSplash() async {
////    var duration = const Duration(seconds: 1);
////    return Timer(duration, navigationPage);
////  }
////
////  Future<void> navigationPage() async {
////    Navigator.push(this.context, MaterialPageRoute(builder: (BuildContext context) => CommentPage()));
////  }
////
////  @override
////  Widget build(BuildContext context) {
////    return Container(
////        alignment: FractionalOffset.center,
////        child: CircularProgressIndicator()
////    );
////  }
////}