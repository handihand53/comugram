import 'dart:io';
import 'package:comugram/model/Comments.dart';
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
import '../commentSession.dart';
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

  //KOMUNITAS
  Future<String> uploadImgKomunitas(File file) async {
    String fileName = basename(file.path);
    StorageReference ref =
        FirebaseStorage.instance.ref().child('imgKomunitas/$fileName');
    StorageUploadTask task = ref.putFile(file);
    StorageTaskSnapshot snapshot = await task.onComplete;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> InsertKomunitas(Komunitas kom, uid, Joined join) {
    Firestore.instance
        .collection('Komunitas')
        .document(kom.uid)
        .setData(kom.toMap());
    Firestore.instance.collection('joined').document(uid).setData(join.toMap());
  }

  Future<void> gabungKomunitas(String id, String uid) {
    Firestore.instance
        .collection('joined')
        .document(id.toString() + uid.toString())
        .setData({
      'id_user': uid,
      'id_komunitas': id,
    });
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

  Future<void> keluarKomunitas(String id, String uid) {
    Firestore.instance
        .collection('joined')
        .document(id.toString() + uid.toString())
        .delete();
  }

  Future<List<Komunitas>> getByCategory(String cat) async {
    List<Komunitas> komunitas = List<Komunitas>();
    await Firestore.instance
        .collection("Komunitas")
        .orderBy("namaKomunitas")
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((data) {
        Map<String, dynamic> temp = data.data;
        komunitas.add(Komunitas.fromMap(temp));
      });
    });
    return komunitas;
  }

  Future<List<Komunitas>> cariKomunitas(String name) async {
    List<Komunitas> komunitas = List<Komunitas>();
    await Firestore.instance
        .collection("Komunitas")
        .orderBy("searchKomunitas")
        .startAt([name.toUpperCase()])
        .endAt([name.toUpperCase() + '\uf8ff'])
        .getDocuments()
        .then((snapshot) {
          snapshot.documents.forEach((data) {
            Map<String, dynamic> temp = data.data;
            komunitas.add(Komunitas.fromMap(temp));
          });
        });
    return komunitas;
  }

  Future<List<Komunitas>> getJoinedKomunitas(String uid) async {
    List<Komunitas> komunitas = List<Komunitas>();

    QuerySnapshot query = await Firestore.instance
        .collection("joined")
        .where("id_user", isEqualTo: uid)
        .getDocuments();

    List<DocumentSnapshot> snapshot = query.documents;

    for (DocumentSnapshot element in snapshot) {
      Map<String, dynamic> tempKomunitas =
          await selectNameKomunitas(element['id_komunitas']);
      Map<String, dynamic> tempUser = await selectUser(tempKomunitas['owner']);
      tempKomunitas['namaOwner'] = tempUser['namaLengkap'];
      Komunitas kom = Komunitas.fromMap(tempKomunitas);
      komunitas.add(kom);
      // print("data komunitas: ${komunitas.length}");
      // print("id_user ${tempUser['namaLengkap']}");
      // await selectNameKomunitas(element['id_komunitas']).then((value) {
      //   Komunitas kom = Komunitas.fromMap(value);
      //   komunitas.add(kom);
      // });
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

  Future<Map<String, dynamic>> selectUser(String userId) async {
    Map<String, dynamic> temp = Map<String, dynamic>();
    await Firestore.instance
        .collection("User")
        .document(userId)
        .get()
        .then((value) {
      temp = value.data;
    });
    return temp;
  }

  Future<List<Post>> getPostKomunitas(String uid) async {
    List<Post> post = List<Post>();
    await Firestore.instance
        .collection("post")
        .document(uid)
        .collection("items")
        .orderBy("id_post")
        .limit(3)
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((data) {
        Map<String, dynamic> temp = data.data;
        post.add(Post.fromMap(temp));
      });
    });
    return post;
  }

  Future<List<Post>> getPostKomunitasByLimit(
      String komId, String idPost) async {
    List<Post> post = List<Post>();
    await Firestore.instance
        .collection("post")
        .document(komId)
        .collection("items")
        .orderBy("id_post")
        .startAfter([
          {'id_post': idPost}
        ])
        .limit(2)
        .getDocuments()
        .then((snapshot) {
          snapshot.documents.forEach((data) {
            Map<String, dynamic> temp = data.data;
            post.add(Post.fromMap(temp));
          });
        });
    print(post.length);
    return post;
  }

  Future<List> getPostKomunitas2(String uid) async {
    List postResult = List();
    QuerySnapshot query = await Firestore.instance
        .collection("post")
        .document(uid)
        .collection("items")
        .getDocuments();

    List<DocumentSnapshot> snapshot = query.documents;

    for (DocumentSnapshot element in snapshot) {
      Map<String, dynamic> tempUser = await selectUser(element['id_user']);
      Map<String, dynamic> post = element.data;
      Map<String, dynamic> temp = Map<String, dynamic>();
      temp['user'] = User.fromMap(tempUser);
      temp['post'] = Post.fromMap(post);
      postResult.add(temp);
    }

    // await Firestore.instance
    //     .collection("post")
    //     .document(uid)
    //     .collection("items")
    //     .getDocuments()
    //     .then((snapshot) {
    //   snapshot.documents.forEach((data) {
    //     Map<String, dynamic> temp = data.data;
    //     post.add(Post.fromMap(temp));
    //   });
    // });
    return postResult;
  }

  Future<void> InsertDataComment(Comments com) async {
    await Firestore.instance.collection('Comments').document(com.id_comment).setData(com.toMap());
    print('print insert data');
  }
}
