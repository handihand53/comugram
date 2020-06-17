import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comugram/Home.dart';
import 'package:comugram/MapsDetail.dart';
import 'package:comugram/model/Komunitas.dart';
import 'package:comugram/model/Post.dart';
import 'package:comugram/services/FirestoreServices.dart';
import 'package:comugram/services/GoogleMapsService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';
import 'Validator.dart';

class UploadPost extends StatefulWidget {
  File imageFile;
  UploadPost({this.imageFile});
  @override
  State<StatefulWidget> createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  Komunitas _selectedkomunitas;
  List<DropdownMenuItem<Komunitas>> _dropdownMenuItems;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirestoreServices firestoreServices;
  List<Komunitas> komunitas = List<Komunitas>();
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  DateTime dateTime = DateTime.now();
  var uuid = Uuid();
  GoogleMapsService googleMapsService;
  String location, location_id;
  Validation val = Validation();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    firestoreServices = FirestoreServices();
    initKomunitas();
    setState(() {});
  }

  void initKomunitas() async {
    FirebaseUser user = await _auth.currentUser();
    googleMapsService = GoogleMapsService();
    String owner = user.uid;
    //List<Komunitas> komunitas = List<Komunitas>();
    komunitas = await firestoreServices.getJoinedKomunitas(owner);
    //print(komunitas.length);
    komunitas.insert(
        0, Komunitas(namaKomunitas: "----silahkan pilih komunitas----"));
    _dropdownMenuItems = buildDropdownMenuItems(komunitas);
    _selectedkomunitas = _dropdownMenuItems[0].value;
    setState(() {});
  }

  onChangeDropdownItem(Komunitas selectedKomunitas) {
    setState(() {
      print(selectedKomunitas.namaKomunitas);
      _selectedkomunitas = selectedKomunitas;
    });
  }

  List<DropdownMenuItem<Komunitas>> buildDropdownMenuItems(
      List<Komunitas> komunitas) {
    List<DropdownMenuItem<Komunitas>> items = List();
    for (Komunitas komu in komunitas) {
      items.add(
        DropdownMenuItem(
          value: komu,
          child: Text(komu.namaKomunitas),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(Object context) {
    ProgressDialog pD = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        elevation: 1.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 20.0),
            child: GestureDetector(
              child: Text(
                'Post',
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
              onTap: () async {
                if (formKey.currentState.validate()) {
                  pD.show();
                  String url = await firestoreServices
                      .uploadImgKomunitas(widget.imageFile);
                  String tgl = DateFormat('dd MMMM yyyy').format(dateTime);
                  FirebaseUser user = await _auth.currentUser();
                  String owner = user.uid;
                  Post post = Post(
                      id_post: uuid.v4(),
                      id_user: owner,
                      id_komunitas: _selectedkomunitas.uid,
                      location: location,
                      imageUrl: url,
                      caption: captionController.text,
                      tanggalBuat: tgl,
                      location_id: location_id,
                      time: Timestamp.now());
                  firestoreServices.insertPost(post);
                  pD.hide();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: ((context) => Home())));
                }
              },
            ),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: Column(children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 12.0),
                child: Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(widget.imageFile),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 8.0),
                  child: TextFormField(
                    controller: captionController,
                    validator: val.validateCaption,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Write a caption...',
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () async {
                Prediction p = await googleMapsService.getPrediction(context);
                if (p != null) {
                  location_id = p.placeId;
                  var arr = p.description.split(",");
                  location = arr[0];
                  print(location);
                  setState(() {});
                }
              },
              child: location == null
                  ? Text("Add Location")
                  : Wrap(spacing: 8.0, runSpacing: 4.0, children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 30.0,
                      ),
                      Text(location),
                    ]),
            ),
          ),
          komunitas.length == 0
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropdownButtonFormField(
                    value: _selectedkomunitas,
                    items: _dropdownMenuItems,
                    onChanged: onChangeDropdownItem,
                    validator: (value) => value.namaKomunitas ==
                            "----silahkan pilih komunitas----"
                        ? "silahkan pilih komunitas"
                        : null,
                  ),
                ),
        ]),
      ),
    );
  }
}
