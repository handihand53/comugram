import 'dart:io';
import 'package:comugram/services/FirestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'Validator.dart';
import 'model/User.dart';

class EditProfile extends StatefulWidget {
  final User editUser;
  EditProfile(this.editUser);

  @override
  _EditProfileState createState() => _EditProfileState(this.editUser);
}

class _EditProfileState extends State<EditProfile> with Validation{
  final formKey = GlobalKey<FormState>();
  User editUser;
  _EditProfileState(this.editUser);
  FirestoreServices Fs = FirestoreServices();
  TextEditingController nameController = TextEditingController();
  TextEditingController UnameController = TextEditingController();
  File imgPick;

  getImage(String result) async{
    if(result == 'pickImg'){
      imgPick = await ImagePicker.pickImage(source: ImageSource.camera);
      if(imgPick != null){
        File croppedImg = await ImageCropper.cropImage(
          sourcePath: imgPick.path,
          aspectRatio: CropAspectRatio(
            ratioX: 1,ratioY: 1,
          ),
          compressQuality: 100,
          maxHeight: 700,
          maxWidth: 700,
        );
        setState(() {imgPick = croppedImg;});
      }
    }else{
      imgPick = await ImagePicker.pickImage(source: ImageSource.gallery);
      if(imgPick != null){
        File croppedImg = await ImageCropper.cropImage(
          sourcePath: imgPick.path,
          aspectRatio: CropAspectRatio(
            ratioX: 1,ratioY: 1,
          ),
          compressQuality: 100,
          maxHeight: 700,
          maxWidth: 700,
        );
        setState(() {imgPick = croppedImg;});
      }
    }
  }


  @override
  void initState() {
    nameController.text = editUser.namaLengkap;
    UnameController.text = editUser.username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Edit Profile", style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            children: <Widget>[
              PopupMenuButton<String>(
                onSelected: (String result){
                  print(result);
                  getImage(result);
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'pickImg',
                    child: Text('Ambil Foto'),
                  ),
                  PopupMenuItem(
                    value: 'pickGallery',
                    child: Text('Pilih dari Gallery'),
                  )
                ],
                child: (imgPick== null) ?
                Container(
                    child: Column(children: <Widget>[
                      SizedBox(height: 15),
                      Container(
                        width: 150,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: editUser.urlProfile != '' ? Image.network(editUser.urlProfile) : Image.asset('images/sensor.png'),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text("Ganti Foto", style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),),
                    ],)
                ) : Container(
                    child: Column(children: <Widget>[
                      SizedBox(height: 15),
                      Container(
                        width: 150,
                        height: 150,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(imgPick),
                        ),
                      ),
                      Text('Ganti Foto'),
                    ],)
                ),
              ),
              Padding (
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  controller: nameController,
                  style: TextStyle(color: Colors.grey,),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nama Lengkap',
                    prefixIcon: Icon(
                      Icons.art_track,
                      color: Colors.orange,
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
                padding: EdgeInsets.all(15),
                child: TextFormField(
                  controller: UnameController,
                  style: TextStyle(color: Colors.grey,),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Colors.orange,
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
              //Tombol
              Padding (
                padding: EdgeInsets.only(top: 20.0,bottom:20.0,right: 15,left: 15),
                child: Row(
                  children: <Widget> [
                    // tombol simpan
                    Expanded(
                      child: Material(
                        elevation: 1.0,
                        color: Color.fromRGBO(255, 153, 0, 1),
                        child: MaterialButton(
                          onPressed: () async{
                            if(formKey.currentState.validate()){
                              formKey.currentState.save();
                              editUser.namaLengkap = nameController.text;
                              editUser.username = UnameController.text;
                              if(imgPick!=null){
                                String url = await Fs.uploadImgProfile(imgPick, editUser.uid);
                                editUser.urlProfile = url;
                                Fs.EditDataUser(editUser);
                              }else{
                                Fs.EditDataUser(editUser);
                              }
                              Navigator.pop(context);
                            }
                          },
                          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                          child: Text('SIMPAN',
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
    );
  }
}