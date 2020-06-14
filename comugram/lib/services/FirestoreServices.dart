import 'dart:io';
import 'package:comugram/model/Joined.dart';
import 'package:comugram/model/Komunitas.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/User.dart';

class FirestoreServices {
  //USER
  Future<void> InsertDataUser(User u){
    Firestore.instance.collection('User').document(u.uid).setData(u.toMap());
  }
  //USER->KHUSUS PROFILE
  Future<void> EditDataUser(User u){
    Firestore.instance.collection('User').document(u.uid).updateData(u.toMap());
  }
  Future<String> uploadImgProfile(File file, String uid) async{
    StorageReference ref = FirebaseStorage.instance.ref().child('imgProfile/$uid');
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    return await snapshot.ref.getDownloadURL();
  }

  //KOMUNITAS
  Future<String> uploadImgKomunitas(File file) async{
    String fileName = basename(file.path);
    StorageReference ref = FirebaseStorage.instance.ref().child('imgKomunitas/$fileName');
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    return await snapshot.ref.getDownloadURL();
  }
  Future<void> InsertKomunitas(Komunitas kom, uid,Joined join){
    Firestore.instance.collection('Komunitas').document(kom.uid).setData(kom.toMap());
    Firestore.instance.collection('joined').document(uid).setData(join.toMap());
  }
  Future<void> GabungKomunitas(Komunitas kom, String uid){
    Firestore.instance.collection('Komunitas').document(kom.uid).updateData({
      'member' : FieldValue.arrayUnion([uid])
    });
  }
  Future<void> KeluarKomunitas(Komunitas kom, String uid){
    Firestore.instance.collection('Komunitas').document(kom.uid).updateData({
      'member' : FieldValue.arrayRemove([uid])
    });
  }
}