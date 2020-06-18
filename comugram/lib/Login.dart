import 'package:comugram/TambahKomunitas.dart';
import 'package:comugram/services/FirestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'Home.dart';
import 'googleFormSignUp.dart';
import 'model/User.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FocusNode _focusNodeEmail;
  FocusNode _focusNodePassword;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNodeEmail = new FocusNode();
    _focusNodeEmail.addListener(_onOnFocusNodeEvent);
    _focusNodePassword = new FocusNode();
    _focusNodePassword.addListener(_onOnFocusNodeEvent);
  }

  _onOnFocusNodeEvent() {
    setState(() {
      // Re-renders
    });
  }

  Color getPrefixIconColorEmail() {
    return _focusNodeEmail.hasFocus ? Colors.orange : Colors.grey;
  }

  Color getPrefixIconColorPassword() {
    return _focusNodePassword.hasFocus ? Colors.orange : Colors.grey;
  }

  Widget build(BuildContext context) {
    ProgressDialog pD = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            //Stack itu kaya z-index di css
            children: <Widget>[
              ClipPath(
                // ini kaya bikin shape yang bisa di customize sisi nya
                clipper: CustomShapeClipper(),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(color: Colors.orange),
                ),
              ),
              ClipPath(
                // ini kaya bikin shape yang bisa di customize sisi nya
                clipper: CustomShapeClipper2(),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(color: Colors.orange),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 140,
                  ),
                  Image.asset(
                    'images/comugram logo 1.png',
                    width: 330,
                    height: 100,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    width: 350,
                    child: TextFormField(
                      focusNode: _focusNodeEmail,
                      controller: email,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(
                          Icons.email,
                          color: getPrefixIconColorEmail(),
                        ),
                        contentPadding: EdgeInsets.all(15.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusColor: Colors.orange,
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        hintText: "Email",
                        fillColor: Color.fromRGBO(245, 245, 245, 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 350,
                    child: TextFormField(
                      focusNode: _focusNodePassword,
                      controller: password,
                      obscureText: true,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: getPrefixIconColorPassword(),
                        ),
                        contentPadding: EdgeInsets.all(15.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusColor: Colors.orange,
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        hintText: "Password",
                        fillColor: Color.fromRGBO(245, 245, 245, 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: 350,
                    child: FlatButton(
                      splashColor: Colors.orange,
                      focusColor: Colors.white,
                      color: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.orange,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 13.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        await pD.show();
                        await doLogin(pD).then((s) async {
                          FirebaseUser usr = s;
                          if (s != null){
                            await pD.hide();
                            Navigator.pushReplacement(
                                this.context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Home()));
                          } else {
                            await pD.hide();
                            showAlertDialog_Fail(context, 'Login gagal, Email atau Password yang anda masukkan salah!');
                          }
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    child: Text(
                      'Lupa password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/resetPassword');
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Belum punya akun ?",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  InkWell(
                    child: Text(
                      'Daftar disini',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, '/register');
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Divider()),
                        Text("atau"),
                        Expanded(child: Divider()),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 115),
                    child: Column(
                      children: <Widget>[
                        RaisedButton(
                          elevation: 2,
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(0),
                              dense: true,
                                leading:Image.asset(
                                  'images/google.png',
                                  height: 40.0,
                                  width: 40.0,
                                ),
                              title: Text("Sign in with Google"),
                            ),
                          ),
                          onPressed: doLoginGoogle,
                        ),
//                        RaisedButton(
//                          elevation: 2,
//                          color: Colors.blue,
//                          padding: EdgeInsets.symmetric(horizontal: 10.0),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: <Widget>[
//                              Image.asset(
//                                'images/facebook.png',
//                                height: 40.0,
//                                width: 40.0,
//                              ),
//                              Text(
//                                "Sign in with Facebook",
//                                style: TextStyle(
//                                  color: Colors.white,
//                                ),
//                              ),
//                            ],
//                          ),
//                          onPressed: doLoginFacebook,
//                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAlertDialog_Fail(BuildContext context, String msg) {
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

  Future<FirebaseUser> doLogin(ProgressDialog pD) async {
    FirebaseUser usr = null;
    await signIn().then((FirebaseUser user) async {
      if (user != null) {
        usr = user;
      }
    }).catchError((s) {
      print(s);
    });
    return usr;
  }

  Future<FirebaseUser> signIn() async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.text, password: password.text);
    FirebaseUser user = result.user;
    return user;
  }

  void doLoginGoogle() {
    googleSignIn().then((FirebaseUser user) async{
      FirestoreServices fs = FirestoreServices();
      Map<String, dynamic> tempUser = await fs.selectUser(user.uid);
      print(tempUser==null);

      if (user != null){
        if(tempUser==null) {
          Navigator.pushReplacement(this.context,
              MaterialPageRoute(builder: (BuildContext context) => GoogleFormSignUp()));
        } else {
          Navigator.pushReplacement(this.context,
            MaterialPageRoute(builder: (BuildContext context) => Home()));
        }
      }

    }).catchError((e) => print(e.toString()));
  }

  Future<FirebaseUser> googleSignIn() async {
    GoogleSignInAccount gsia = await GoogleSignIn().signIn();
    GoogleSignInAuthentication gsiauth = await gsia.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: gsiauth.idToken, accessToken: gsiauth.accessToken);

    FirebaseUser user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    return user;
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(235.0, 0.0);
    path.quadraticBezierTo(size.width / 1.2, 320, size.width, 150);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class CustomShapeClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(200.0, 0.0);
    path.quadraticBezierTo(size.width / 5, 80, size.width, 130);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
