import 'dart:io';
import 'package:comugram/model/Joined.dart';
import 'package:comugram/services/FirestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'Validator.dart';
import 'model/Komunitas.dart';

class KomunitasForm extends StatefulWidget {

  @override
  _KomunitasFormState createState() => _KomunitasFormState();
}

class _KomunitasFormState extends State<KomunitasForm> with Validation{
  final formKey = GlobalKey<FormState>();
  FirestoreServices Fs = new FirestoreServices();
  TextEditingController nameController = TextEditingController();
  TextEditingController deskController = TextEditingController();
  bool _progressLoad=true;
  String dropdownValue;
  File imgPick;
  FirebaseAuth _auth = FirebaseAuth.instance;
  DateTime dateTime = DateTime.now();
  var uuid = Uuid();

  getImage(String result) async{
    if(result == 'pickImg'){
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
  Widget build(BuildContext context) {
    ProgressDialog pD = ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: false,);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Tambah Komunitas", style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: ListView(
          children: <Widget> [
            //circular image...
            //form
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
                                    child: Image.asset('images/instant-camera.png'),
                                  ),
                                  SizedBox(height: 10),
                                  Text("Tambah Gambar", style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),),
                                ],)
                            ) : Container(
                                child: Column(children: <Widget>[
                                  SizedBox(height: 15),
                                  Container(
                                    width: 250,
                                    height: 250,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(imgPick),
                                    ),
                                  ),
                                ],)
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: DropdownButton<String>(
                              iconSize: 24,
                              hint: Text('Kategori'),
                              value: dropdownValue,
                              elevation: 16,
                              underline: Container(
                                height: 2,
                              ),
                              onChanged: (String newValue) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              },
                              items: <String>[
                                'Gaming', 'Makan', 'Masak', 'Olahraga', 'Belajar','Liburan','Kesehatan'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                          Padding (
                              padding: EdgeInsets.only(top:15.0, bottom:10.0),
                              child: TextFormField(
                                controller: nameController,
                                style: TextStyle(color: Colors.grey,),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'Nama Komunitas',
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
                                validator: validateNameKomunitas,
                              ),
                            ),
                          Padding (
                            padding: EdgeInsets.only(top:10.0, bottom:10.0),
                            child: TextFormField(
                              maxLines: 3,
                              controller: deskController,
                              style: TextStyle(color: Colors.grey,),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: 'Deskripsi Komunitas',
                                prefixIcon: Icon(
                                  Icons.edit,
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
                              validator: validateDesk,
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
                                      onPressed: () async{
                                        if(formKey.currentState.validate()){
                                          formKey.currentState.save();
                                          pD.show();
                                          if(imgPick != null && dropdownValue !=null){
                                            String url = await Fs.uploadImgKomunitas(imgPick);
                                            String tgl = DateFormat('dd MMMM yyyy').format(dateTime);
                                            FirebaseUser user = await _auth.currentUser();
                                            String owner = user.uid;
                                            Komunitas kom = Komunitas(uid: uuid.v4(), kategori: dropdownValue, imageUrl: url, namaKomunitas: nameController.text, deskripsi: deskController.text, owner: owner, tanggalBuat: tgl);
                                            Joined join = Joined(uid: kom.owner, kom_id: kom.uid);
                                            Fs.InsertKomunitas(kom,  uuid.v4(), join);
                                            pD.hide();
                                            Navigator.pop(context);
                                          }else{
                                            showAlertDialog_Fail(context, 'Belum ada data lengkap untuk ditampilkan ke sesama Komunitas');
                                          }
                                        }
                                      },
                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                                      child: Text('BUAT KOMUNITAS',
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