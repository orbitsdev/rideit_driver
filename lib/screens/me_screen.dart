import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/dialog/authdialog/authenticating.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/model/users.dart';
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

var driverxcontroller = Get.put(Drivercontroller());  
  File? myimage;
  bool isUploading = false;
  final ImagePicker _picker = ImagePicker();
  String? filnametext;
  UploadTask? task;
  Stream? userdetails;
 final Stream<DocumentSnapshot<Object?>> _usersStream = driversusers.doc(authinstance.currentUser!.uid).snapshots();
 Stream<QuerySnapshot<Map<String, dynamic>>> ratingsstream = ratingsreferrence.doc(authinstance.currentUser!.uid).collection("ratings").snapshots();
  @override
  void initState() {
    super.initState();
   //userdetails = getUserdetails();
  }

   getUserdetails() async{
    return await FirebaseApi.getUserDetails();
  }

  void loadingSetter(bool value) {
    setState(() {
      isUploading = value;
    });
  }

  Future pickImage(ImageSource imagesource) async {
    try {
     
      final image = await ImagePicker().pickImage(source: imagesource, maxHeight: 480, imageQuality: 85);
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
      final fiilename ='${DateTime.now().millisecond}' +path.basename(myimage!.path);
      final saveimage = await myimage!.copy("${pathDir.path}/${fiilename}");
      final destination = 'userimage/${fiilename}';
  
      task = await FirebaseApi.uploadFile(destination, myimage as File);
      
      if (task == null) return;
      final snapshot = await task!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      FirebaseApi.updateProfile(urlDownload, destination );

    
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
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Stack(children: [
    
        StreamBuilder<DocumentSnapshot<Object?>>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
    
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
    
           
          if(snapshot.data!["image_url"] == null){
            return  ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                width: 170,
                height: 170,
                color: Colors.pinkAccent,
                child: Text("No Image")),
            
              );
            
          }
    
          return  ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                width: 170,
                height: 170,
                color: Colors.pinkAccent,
                child: Image.network(snapshot.data!["image_url"], fit: BoxFit.cover,),
            
              ),
            );
        }),
            
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
          StreamBuilder<QuerySnapshot>(
        stream: ratingsstream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
    
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }
    
          return Container(
            constraints: BoxConstraints(
              maxHeight: 400,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index){
    
                   return ListTile(
                  title: Text('${snapshot.data!.docs[index]['rate']}'),
                  subtitle: Text('${snapshot.data!.docs[index]['created_at']}')
                );
              },
              
            ),
          );
        },
      ),
          ElevatedButton(
              onPressed: () {
                authinstance.signOut();
                Get.offAllNamed(SigninScreen.screenName);
              },
              child: Text('Signout')),
        
    
              
        ],
      ),
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
