import 'package:comugram/services/FirestoreServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'Validator.dart';
import 'model/User.dart';
import 'MainMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterForm extends StatefulWidget {

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> with Validation{
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirestoreServices Fs = new FirestoreServices();
  User userModel;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  Future<FirebaseUser> RegisUnamePass(String email, String pass)async{
      try {
        FirebaseUser user = (await auth.createUserWithEmailAndPassword(email: email, password: pass)).user;
        assert(user != null);
        assert(await user.getIdToken() != null);
        final FirebaseUser currentUser = await auth.currentUser();
        assert(user.uid == currentUser.uid);
        return user;
      } catch (e) {
        showAlertDialog_Fail(context, 'Email Telah Digunakan, Silahkan Daftar dengan Email Lain!');
        return null;
      }
  }
  void doRegis(String email, String pass, String uname) async{
    RegisUnamePass(email, pass).then((FirebaseUser user){
      userModel = User(uid: user.uid, username: uname,email: user.email, pass: pass);
      Fs.InsertDataUser(userModel);
      Navigator.pushReplacement(this.context, MaterialPageRoute(builder: (BuildContext context) => MainMenu()));
    }).catchError((e) =>print(e.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 25.0, left: 25.0),
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
                            title: Text('Buat Akun Baru',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding (
                          padding: EdgeInsets.only(top:15.0, bottom:10.0),
                          child: TextFormField(
                            controller: userController,
                            style: TextStyle(color: Colors.grey,),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(
                                Icons.supervised_user_circle,
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  )
                              ),
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

                        Padding (
                          padding: EdgeInsets.only(top:10.0, bottom:10.0),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(color: Colors.grey,),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                            validator: validateEmail,
                          ),
                        ),

                        Padding (
                          padding: EdgeInsets.only(top:10.0, bottom:15.0),
                          child: TextFormField(
                            controller: passController,
                            style: TextStyle(color: Colors.grey,),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                            validator: validatePass,
                          ),
                        ),

                        // tombol button
                        Padding (
                          padding: EdgeInsets.only(top: 15.0,bottom:15.0),
                          child: Row(
                            children: <Widget> [
                              // tombol simpan
                              Expanded(
                                child: Material(
                                  elevation: 1.0,
                                  color: Color.fromRGBO(255, 153, 0, 1),
                                  child: MaterialButton(
                                    onPressed: () {
                                      if(formKey.currentState.validate()){
                                        formKey.currentState.save();
                                        doRegis(emailController.text.toString(), passController.text.toString(), userController.text.toString());
                                      }
                                    },
                                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                                    child: Text('REGISTER',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.white
                                      ),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: RichText(text: TextSpan(children: <TextSpan>[
                TextSpan(text: 'Sudah memiliki akun? ',style: TextStyle(color: Colors.black)),
                TextSpan(text: 'Login disini', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                  recognizer: TapGestureRecognizer()..onTap = () {
                    Navigator.pushNamed(context, '/login');
                  }, ),
              ])
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