import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String namaLengkap;
  String username;
  String email;
  String urlProfile;

  User({this.uid, this.namaLengkap,this.username, this.email, this.urlProfile});

  User.fromMap(Map<String, dynamic> userMaps) {
    this.uid = userMaps['id'];
    this.namaLengkap = userMaps['namaLengkap'];
    this.username = userMaps['username'];
    this.email = userMaps['email'];
    this.urlProfile = userMaps['urlProfile'];
  }
  //dapetin data langsung object, factory untuk keperluan agar namedConstructor tidak membuat object baru, disini digunakan untuk mengubah snapshot db ke object
  factory User.fromDocument(DocumentSnapshot document){
    return User(
        uid : document['id'],
        namaLengkap : document['namaLengkap'],
        username : document['username'],
        email : document['email'],
        urlProfile : document['urlProfile'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'namaLengkap' : namaLengkap,
      'username': username,
      'email': email,
      'urlProfile' : urlProfile,
    };
  }

}