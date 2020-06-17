import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comugram/services/FirestoreServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Validator.dart';
import 'model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleFormSignUp extends StatefulWidget {
  @override
  _GoogleFormSignUpState createState() => _GoogleFormSignUpState();
}

class _GoogleFormSignUpState extends State<GoogleFormSignUp> with Validation {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirestoreServices Fs = new FirestoreServices();
  User userModel;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Future<FirebaseUser> RegisUnamePass(String email, String pass) async {
    try {
      FirebaseUser user = (await auth.createUserWithEmailAndPassword(
              email: email, password: pass))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      final FirebaseUser currentUser = await auth.currentUser();
      assert(user.uid == currentUser.uid);
      return user;
    } catch (e) {
      showAlertDialog_Fail(
          context, 'Email Telah Digunakan, Silahkan Daftar dengan Email Lain!');
      return null;
    }
  }

  void doRegis(String nama, String email, String pass, String uname) async {
    RegisUnamePass(email, pass).then((FirebaseUser user) {
      userModel = User(
          uid: user.uid, namaLengkap: nama, username: uname, email: user.email);
      Fs.InsertDataUser(userModel);
      Navigator.popAndPushNamed(this.context, '/home');
    }).catchError((e) => print(e.toString()));
  }

  void doRegisAvailUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.collection('User').document(user.uid).setData({
      'email': user.email,
      'id': user.uid,
      'namaLengkap': nameController.text.toString(),
      'urlProfile': null,
      'username': userController.text.toString(),
    });
    Navigator.popAndPushNamed(this.context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: 15.0, bottom: 15.0, right: 25.0, left: 25.0),
              child: Image.asset(
                'images/comugram logo 1.png',
                width: 330,
                height: 100,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(56, 54, 54, 0),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: ListTile(
                            title: Text(
                              'Buat Akun Baru',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                          child: TextFormField(
                            controller: nameController,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Nama Lengkap',
                              prefixIcon: Icon(
                                Icons.art_track,
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.grey,
                              )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                            validator: validateName,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
                          child: TextFormField(
                            controller: userController,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(
                                Icons.account_box,
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.grey,
                              )),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                            validator: validateName,
                          ),
                        ),
                        // tombol button
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: Row(
                            children: <Widget>[
                              // tombol simpan
                              Expanded(
                                child: Material(
                                  elevation: 1.0,
                                  color: Color.fromRGBO(255, 153, 0, 1),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        doRegisAvailUser();
                                      }
                                    },
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 30.0),
                                    child: Text(
                                      'REGISTER',
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog_Fail(BuildContext context, String msg) {
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text(
      "Perhatian!",
      style: TextStyle(color: Colors.red),
    ),
    content: Text(
      msg,
    ),
    actions: [
      okButton,
    ],
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
