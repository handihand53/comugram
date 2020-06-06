import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterForm extends StatefulWidget {

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> with Validation{

  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(28, 28, 28, 1),
        child: ListView(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 25.0, left: 25.0),
              child: Image.asset(
                'images/wang_bold.png',
                width: 150,
                height: 150,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(56, 54, 54, 1),
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
                              style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding (
                          padding: EdgeInsets.only(top:15.0, bottom:10.0),
                          child: TextFormField(
                            controller: userController,
                            style: TextStyle(color: Color.fromRGBO(200, 200, 200, 1),),
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(
                                Icons.supervised_user_circle,
                                color: Color.fromRGBO(200, 200, 200, 1),
                              ),
                              labelStyle: TextStyle(color: Color.fromRGBO(200, 200, 200, 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                  )
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            validator: validateName,
                          ),
                        ),

                        Padding (
                          padding: EdgeInsets.only(top:10.0, bottom:10.0),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(color: Color.fromRGBO(200, 200, 200, 1),),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(
                                Icons.alternate_email,
                                color: Color.fromRGBO(200, 200, 200, 1),
                              ),
                              labelStyle: TextStyle(color: Color.fromRGBO(200, 200, 200, 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                  )
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            validator: validateEmail,
                          ),
                        ),

                        Padding (
                          padding: EdgeInsets.only(top:10.0, bottom:15.0),
                          child: TextFormField(
                            controller: passController,
                            style: TextStyle(color: Color.fromRGBO(200, 200, 200, 1),),
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(
                                Icons.security,
                                color: Color.fromRGBO(200, 200, 200, 1),
                              ),
                              labelStyle: TextStyle(color: Color.fromRGBO(200, 200, 200, 1)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(200, 200, 200, 1),
                                  )
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
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
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color.fromRGBO(255, 153, 0, 1),
                                  child: MaterialButton(
                                    onPressed: () {
                                      if(formKey.currentState.validate()){
                                        formKey.currentState.save();

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
            Text("Already Have a Account? ")
          ],
        ),
      ),
    );
  }
}