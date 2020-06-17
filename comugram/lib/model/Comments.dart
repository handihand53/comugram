import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Comments extends StatelessWidget {
  String id_comment;
  String id_post;
  String user_id;
  String username;
  String urlProfil;
  String comment;
  String waktu;
  Timestamp time;

  Comments(
      {this.id_comment,
      this.id_post,
      this.user_id,
      this.username,
      this.urlProfil,
      this.comment,
      this.waktu,
      this.time});

  Comments.fromMap(Map<String, dynamic> userMaps) {
    this.id_comment = userMaps['id_comment'];
    this.id_post = userMaps['id_post'];
    this.user_id = userMaps['id_user'];
    this.username = userMaps['username'];
    this.urlProfil = userMaps['urlProfile'];
    this.comment = userMaps['comment'];
    this.waktu = userMaps['waktu'];
    this.time = userMaps['time'];
  }
  //dapetin data langsung object, factory untuk keperluan agar namedConstructor tidak membuat object baru, disini digunakan untuk mengubah snapshot db ke object
  factory Comments.fromDocument(DocumentSnapshot document) {
    return Comments(
      id_comment: document['id_comment'],
      id_post: document['id_post'],
      user_id: document['id_user'],
      username: document['username'],
      urlProfil: document['urlProfile'],
      comment: document['comment'],
      waktu: document['waktu'],
      time: document['time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_comment': id_comment,
      'id_post': id_post,
      'id_user': user_id,
      'username': username,
      'urlProfile': urlProfil,
      'comment': comment,
      'waktu': waktu,
      'time': time,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: urlProfil != null
              ? Image.network(urlProfil)
              : Image.asset('images/user.png'),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(username),
          Text(waktu),
        ],
      ),
      subtitle: Text(comment),
    );
  }
}
