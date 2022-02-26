import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/dialog/authdialog/authenticating.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/services/firebase_api.dart';
import 'package:tricycleappdriver/signin_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as pathprovider;
import 'package:path/path.dart' as path;

class MeScreen extends StatefulWidget {
  static const screenName = "/me";

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {

var driverxcontroller = Get.find<Drivercontroller>();  
  File? myimage;
  bool isUploading = false;
  final ImagePicker _picker = ImagePicker();
  String? filnametext;
  UploadTask? task;

  void loadingSetter(bool value) {
    setState(() {
      isUploading = value;
    });
  }

  Future pickImage(ImageSource imagesource) async {
    try {
     
      final image = await ImagePicker().pickImage(source: imagesource);
      if (image == null) {
        return;
      }
 loadingSetter(true);
      progressDialog("Uploading");
      final imageTemporary = File(image.path);
      setState(() {
        this.myimage = imageTemporary;
      });

      final pathDir = await pathprovider.getApplicationDocumentsDirectory();
      final fiilename = path.basename(myimage!.path);
      final saveimage = await myimage!.copy("${pathDir.path}/${fiilename}");
      final destination = 'profile/${fiilename}';

      task = await FirebaseApi.uploadFile(destination, myimage as File);
      setState(() {
        
      });
      if (task == null) return;
      final snapshot = await task!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      if(urlDownload.isNotEmpty){
        driverxcontroller.updateProfile(urlDownload);
  //      FirebaseApi.updateProfile(urlDownload);
        print("download ____________${urlDownload}");

      }
    
      setState(() {
        filnametext = destination;
      });
      loadingSetter(false);
      Get.back();
    } on PlatformException catch (e) {
      loadingSetter(false);

      print("field to pick image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 170,
              height: 170,
              color: Colors.pinkAccent,
              child: myimage != null
                  ? Image.file(myimage as File, fit: BoxFit.cover)
                  : Center(child: Text("No image")),
            ),
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(
                  onPressed: () {
                    pickImage(ImageSource.camera);
                  },
                  icon: Icon(
                    Icons.camera_alt,
                  ),
                  iconSize: 34,
                  color: Colors.white))
        ]),
        SizedBox(
          height: 3,
        ),
        // if (filnametext != null) Text(filnametext as String),
        ElevatedButton.icon(
            onPressed: () {
              pickImage(ImageSource.gallery);
            },
            icon: Icon(Icons.folder),
            label: Text('Pick Image')),
        SizedBox(
          height: 12,
        ),
        task != null ? builUploadStatus(task) : Container(),
        
        ElevatedButton(
            onPressed: () {
              authinstance.signOut();
              Get.offAllNamed(SigninScreen.screenName);
            },
            child: Text('Signout'))
      ],
    );
  }

  builUploadStatus(UploadTask? task) {
    return StreamBuilder<TaskSnapshot>(
        stream: task!.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap!.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100 ).toStringAsFixed(0);
            return Text("${percentage}%", style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold),);
          } else {
            return Container();
          }
        });
  }
}
