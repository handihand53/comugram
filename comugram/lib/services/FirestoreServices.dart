import 'dart:io';
import 'package:comugram/model/Joined.dart';
import 'package:comugram/model/Komunitas.dart';
import 'package:comugram/model/Post.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/Komunitas.dart';
import '../model/Komunitas.dart';
import '../model/Komunitas.dart';
import '../model/Komunitas.dart';
import '../model/Komunitas.dart';
import '../model/Komunitas.dart';
import '../model/Komunitas.dart';
import '../model/Komunitas.dart';
import '../model/User.dart';

class FirestoreServices {
  //USER
  Future<void> InsertDataUser(User u) {
    Firestore.instance.collection('User').document(u.uid).setData(u.toMap());
  }

  //USER->KHUSUS PROFILE
  Future<void> EditDataUser(User u) {
    Firestore.instance.collection('User').document(u.uid).updateData(u.toMap());
  }

  Future<String> uploadImgProfile(File file, String uid) async {
    StorageReference ref =
        FirebaseStorage.instance.ref().child('imgProfile/$uid');
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    return await snapshot.ref.getDownloadURL();
  }

//  Future<int> countPost(bth parameter)async{
//   QuerySnapshot post  = await Firestore.instance.collection('Post').where('user_id', isEqualTo: 'user_id').getDocuments();
//   return post.documents.length;
//  }
//  Future<int> countOwnedKomunitas(User u)async{
//   QuerySnapshot own  = await Firestore.instance.collection('Komunitas').where('Owned', isEqualTo: u.uid).getDocuments();
//   return own.documents.length;
//  }
//  Future<int> countJoinedKomunitas(User u)async{
//   QuerySnapshot join  = await Firestore.instance.collection('Komunitas').where('Member', arrayContains: u.uid).getDocuments();
//   return join.documents.length;
//  }

  //KOMUNITAS
  Future<String> uploadImgKomunitas(File file) async {
    String fileName = basename(file.path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child('imgKomunitas/$fileName');
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> InsertKomunitas(Komunitas kom) {
    Firestore.instance
        .collection('Komunitas')
        .document(kom.uid)
        .setData(kom.toMap());
  }

  Future<void> gabungKomunitas(String id, String uid) {
    Firestore.instance.collection('joined').document().setData({
      'id_user': uid,
      'id_komunitas': id,
    });
  }

  Future<void> KeluarKomunitas(String id, String uid) {
    Firestore.instance.collection('joined').where('komunitas_id', isEqualTo: uid).where('user_id', isEqualTo: id);
  }

  Future<Map<String, dynamic>> selectNameKomunitas(String komId) async {
    Map<String, dynamic> temp = Map<String, dynamic>();
    await Firestore.instance
        .collection("Komunitas")
        .document(komId)
        .get()
        .then((value) {
      temp = value.data;
    });
    return temp;
  }

  Future<List<Komunitas>> getJoinedKomunitas(String uid) async {
    List<Komunitas> komunitas = List<Komunitas>();

    QuerySnapshot query = await Firestore.instance
        .collection("joined")
        .where("id_user", isEqualTo: uid)
        .getDocuments();

    List<DocumentSnapshot> snapshot = query.documents;

    for (DocumentSnapshot element in snapshot) {
      await selectNameKomunitas(element['id_komunitas']).then((value) {
        Komunitas kom = Komunitas.fromMap(value);
        komunitas.add(kom);
      });
    }

    return komunitas;
  }

  //uploadpost
  Future<String> uploadImgPost(File file) async {
    String fileName = basename(file.path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child('imgPost/$fileName');
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> insertPost(Post post) async {
    Firestore.instance
        .collection("post")
        .document(post.id_komunitas)
        .collection("items")
        .document(post.id_post)
        .setData(post.toMap());
  }

  Future<List<Post>> getPostKomunitas(String uid) async {
    List<Post> post = List<Post>();
    await Firestore.instance
        .collection("post")
        .document(uid)
        .collection("items")
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((data) {
        Map<String, dynamic> temp = data.data;
        post.add(Post.fromMap(temp));
      });
    });
    return post;
  }
}
