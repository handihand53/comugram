import 'dart:io';

import 'package:comugram/UploadPost.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AddPostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  File imageFile;

  Future<File> _pickImage(String action) async {
    File selectedImage;

    action == 'Gallery'
        ? selectedImage =
            await ImagePicker.pickImage(source: ImageSource.gallery)
        : await ImagePicker.pickImage(source: ImageSource.camera);

    return selectedImage;
  }

  showImageDialog() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) {
          return SimpleDialog(
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Choose from Gallery'),
                onPressed: () async {
                  File selectedImage = await _pickImage('Gallery');
                  File croppedImg = await ImageCropper.cropImage(
                    sourcePath: selectedImage.path,
                    aspectRatio: CropAspectRatio(
                      ratioX: 1,
                      ratioY: 1,
                    ),
                    compressQuality: 100,
                    maxHeight: 700,
                    maxWidth: 700,
                  );
                  setState(() {
                    imageFile = croppedImg;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => UploadPost(
                                imageFile: imageFile,
                              ))));
                },
              ),
              SimpleDialogOption(
                child: Text('Take Photo'),
                onPressed: () async {
                  File selectedImage = await _pickImage('Camera');
                  File croppedImg = await ImageCropper.cropImage(
                    sourcePath: selectedImage.path,
                    aspectRatio: CropAspectRatio(
                      ratioX: 1,
                      ratioY: 1,
                    ),
                    compressQuality: 100,
                    maxHeight: 700,
                    maxWidth: 700,
                  );
                  setState(() {
                    imageFile = croppedImg;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => UploadPost(
                                imageFile: imageFile,
                              ))));
                },
              ),
              SimpleDialogOption(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }));
  }

  @override
  Widget build(Object context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(15),
      child: Center(
          child: RaisedButton.icon(
        splashColor: Colors.yellow,
        shape: StadiumBorder(),
        color: Colors.black,
        label: Text(
          'Upload Image',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.cloud_upload,
          color: Colors.white,
        ),
        onPressed: showImageDialog,
      )),
    );
  }
}
