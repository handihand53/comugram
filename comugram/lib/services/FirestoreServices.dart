import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/User.dart';

class FirestoreServices {
  Future<void> InsertDataUser(User u){
    Firestore.instance.collection('User').document(u.uid).setData(u.toMap());
  }
}