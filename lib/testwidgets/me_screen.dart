import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/dialog/authdialog/authenticating.dart';
import 'package:tricycleappdriver/dialog/profiledialog/profiledialog.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/services/firebase_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as pathprovider;
import 'package:path/path.dart' as path;
import 'package:tricycleappdriver/signin_screen.dart';
import 'package:url_launcher/link.dart';

class MeScreen extends StatefulWidget {
  static const screenName = "/me";

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  var driverxcontroller = Get.put(Drivercontroller());
  var authxcontroller = Get.find<Authcontroller>();
  File? myimage;
  bool isUploading = false;
  final ImagePicker _picker = ImagePicker();
  String? filnametext;
  UploadTask? task;
  Stream? userdetails;
  final Stream<DocumentSnapshot<Object?>> _usersStream =
      driversusers.doc(authinstance.currentUser!.uid).snapshots();
  Stream<QuerySnapshot<Map<String, dynamic>>> ratingsstream = ratingsreferrence
      .doc(authinstance.currentUser!.uid)
      .collection("ratings")
      .snapshots();
  @override
  void initState() {
    super.initState();
    //userdetails = getUserdetails();
  }

  getUserdetails() async {
    return await FirebaseApi.getUserDetails();
  }

  void loadingSetter(bool value) {
    setState(() {
      isUploading = value;
    });
  }

  Future pickImage(ImageSource imagesource) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: imagesource, maxHeight: 480, imageQuality: 85);
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
      final fiilename =
          '${DateTime.now().millisecond}' + path.basename(myimage!.path);
      final saveimage = await myimage!.copy("${pathDir.path}/${fiilename}");
      final destination = 'userimage/${fiilename}';

      task = await FirebaseApi.uploadFile(destination, myimage as File);

      if (task == null) return;
      final snapshot = await task!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      FirebaseApi.updateProfile(urlDownload, destination);

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
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            width: double.infinity,

            //color: BACKGROUND_BLACK_LIGHT_MORE_LIGHT_2,
            child: Center(
              child: Stack(children: [
                StreamBuilder<DocumentSnapshot<Object?>>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading");
                      }

                      if (snapshot.data!["image_url"] == null) {
                        return ClipOval(
                          child: Container(
                            color: TEXT_WHITE_2,
                            padding: EdgeInsets.all(5),
                            child: ClipOval(
                              child: Image.asset(
                                'assets.images/PngItem_1503945.png',
                                height: 130,
                                width: 130,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }

                      return ClipOval(
                        child: Container(
                          color: TEXT_WHITE_2,
                          padding: EdgeInsets.all(5),
                          child: ClipOval(
                            child: Image.network(
                              snapshot.data!["image_url"],
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }),
                Positioned(
                    bottom: 5,
                    right: 5,
                    child: IconButton(
                        onPressed: () {
                          Profiledialog.showSimpleDialog(context, pickImage);
                        },
                        icon: Icon(
                          Icons.camera_alt,
                        ),
                        iconSize: 34,
                        color: Colors.white))
              ]),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Text('${authxcontroller.useracountdetails.value.name}',
              style: Get.textTheme.bodyText1,),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                color: BACKGROUND_BLACK_LIGHT_MORE_LIGHT,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.motorcycle,
                          size: 24,
                          color: TEXT_WHITE,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '200',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Center(
                        child: Text('Total Trips',
                            style: TextStyle(
                                color: TEXT_WHITE_2,
                                fontSize: 12,
                                fontWeight: FontWeight.w300))),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                color: BACKGROUND_BLACK_LIGHT_MORE_LIGHT,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.motorcycle,
                          size: 24,
                          color: TEXT_WHITE,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '200',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Center(
                        child: Text('Total Distance Traveled',
                            style: TextStyle(
                                color: TEXT_WHITE_2,
                                fontSize: 12,
                                fontWeight: FontWeight.w300))),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                color: BACKGROUND_BLACK_LIGHT_MORE_LIGHT,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.motorcycle,
                          size: 24,
                          color: TEXT_WHITE,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '200',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Center(
                        child: Text('Canceled Trip',
                            style: TextStyle(
                                color: TEXT_WHITE_2,
                                fontSize: 12,
                                fontWeight: FontWeight.w300))),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    color: GREEN_LIGHT,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: Text(
                          '${authxcontroller.useracountdetails.value.email}')),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Icon(
                    Icons.phone_android_outlined,
                    color: GREEN_LIGHT,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: Text(
                          '${authxcontroller.useracountdetails.value.phone}')),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(onPressed: (){
                authinstance.signOut();
                Get.offAllNamed(SigninScreen.screenName);
              }, child: Text('SIgnout'))
              // GestureDetector
              // (
              //   onTap: (){
              //     print('called');
              //   authinstance.signOut();
              //   Get.offAllNamed(SigninScreen.screenName);
              //   },
              //   child: Text('Signout', style: Get.textTheme.bodyText2))
            ],
          ),

         
          StreamBuilder<QuerySnapshot>(
            stream: ratingsstream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      color: BACKGROUND_BLACK,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipOval(
                                child: Container(
                                  color: TEXT_WHITE_2,
                                  padding: EdgeInsets.all(2),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/images.jpg',
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('KATE KRISITNE  ', style: Get.textTheme.bodyText1,),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        RatingBar.builder(
                                          initialRating: snapshot.data!.docs[index]['rate'],
                                          minRating: snapshot.data!.docs[index]['rate'],
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 20,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                              
                                          },
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                        '${snapshot.data!.docs[index]['rate']}',
                                        style: Get.textTheme.bodyText1,
                                      ),
                                        
                              
                              
                              
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          
                           Text('Nice and Very smooth transactions  '),
                         
                        ],
                      ),
                    );
                    
                  },
                ),
              );
            },
          ),
      
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
            final percentage = (progress * 100).toStringAsFixed(0);
            return Text(
              "${percentage}%",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        });
  }
}
