import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
  File? myimage;
  final ImagePicker _picker = ImagePicker();
  String? filnametext;

  Future pickImage(ImageSource imagesource) async {
    try {
      final image = await ImagePicker().pickImage(source: imagesource, maxWidth: 600);
      if (image == null) {
        return;
      }

      final imageTemporary = File(image.path);
      setState(() {
        this.myimage = imageTemporary;
      });

      final pathDir = await pathprovider.getApplicationDocumentsDirectory();
      final fiilename = path.basename(myimage!.path);
      final saveimage = await myimage!.copy("${pathDir.path}/${fiilename}");
      final destination = 'files/${fiilename}';
      
      FirebaseApi.uploadFile(destination, myimage as File);
      setState(() {
        filnametext =  destination;
      });

    } on PlatformException catch (e) {
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
        Stack(
          children:[ ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              width: 170,
              height:170,
              color: Colors.pinkAccent,
              child: myimage != null ? Image.file(myimage as File, fit: BoxFit.cover) : Center(child: Text("No image")),
            ),
          ),
            Positioned(
            bottom: 10,
            right: 10,
              child: IconButton(onPressed: (){
                pickImage(ImageSource.camera);
              }, icon: Icon(Icons.camera_alt,) ,iconSize: 34, color: Colors.white)
            )
          ]
        ),
       
        SizedBox(
          height: 3,
        ),
        if(filnametext != null )
        Text(filnametext as String),
        ElevatedButton.icon(  
            onPressed: () {
              pickImage(ImageSource.gallery);
            },
            icon: Icon(Icons.folder),
            label: Text('Pick Image')),
      SizedBox(
        height: 12,
      )  ,
        ElevatedButton(
            onPressed: () {
              authinstance.signOut();
              Get.offAllNamed(SigninScreen.screenName);
            },
            child: Text('Signout'))
      ],
    );
  }
}
