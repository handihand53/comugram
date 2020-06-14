import 'dart:io';
import 'package:comugram/model/Joined.dart';
import 'package:comugram/model/Komunitas.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
}
