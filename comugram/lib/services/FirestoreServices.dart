import 'dart:io';
import 'package:comugram/model/Komunitas.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/User.dart';

class FirestoreServices {
  Future<void> InsertDataUser(User u){
    Firestore.instance.collection('User').document(u.uid).setData(u.toMap());
  }
  Future<String> uploadImgKomunitas(File file) async{
    String fileName = basename(file.path);
    StorageReference ref = FirebaseStorage.instance.ref().child('imgKomunitas/$fileName');
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    return await snapshot.ref.getDownloadURL();
  }
  Future<void> InsertKomunitas(Komunitas kom){
    Firestore.instance.collection('Komunitas').document(kom.uid).setData(kom.toMap());
  }
}