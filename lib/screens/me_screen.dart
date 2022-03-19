import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/dialog/authdialog/authdialog.dart';
import 'package:tricycleappdriver/dialog/profiledialog/profiledialog.dart';
import 'package:tricycleappdriver/model/rating.dart';
import 'package:tricycleappdriver/screens/editprofile_screen.dart';
import 'package:tricycleappdriver/services/firebase_api.dart';
import 'package:tricycleappdriver/widgets/horizontalspace.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';
import 'dart:math';
import 'package:path_provider/path_provider.dart' as pathprovider;
import 'package:path/path.dart' as path;

class MeScreen extends StatefulWidget {
  const MeScreen({Key? key}) : super(key: key);
  static const screenName = "/me";

  @override
  _MeScreenState createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  File? myimage;
  UploadTask? task;
  String? filnametext;
  List<Color> listofcolors = [
    ELSA_ORANGE,
    ELSA_BLUE_2_,
    ELSA_GREEN,
    ELSA_PINK,
    ELSA_BLUE,
    DARK_GREEN,
    ELSA_YELLOW_TEXT,
    ELSA_PINK_TEXT,
    ELSA_BLUE_1_,
    iconcolorsecondary,
  ];
  var authxcontroller = Get.find<Authcontroller>();
  var driverxcontroller = Get.find<Drivercontroller>();

  Random random = Random();
  @override
  void initState() {
    super.initState();
    driverxcontroller.listenToAcountUser();
    driverxcontroller.listenToRatings();
    
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future pickImage(ImageSource imagesource) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: imagesource, maxHeight: 480, imageQuality: 85);
      if (image == null) {
        return;
      }

      final imageTemporary = File(image.path);
      setState(() {
        this.myimage = imageTemporary;
      });

      final pathDir = await pathprovider.getApplicationDocumentsDirectory();
      final fiilename =
          '${DateTime.now().millisecond}' + path.basename(myimage!.path);
      final saveimage = await myimage!.copy("${pathDir.path}/${fiilename}");
      final destination = 'userimage/${fiilename}';
      Profiledialog.showUploadDialog(context, 'Uploading...');
      task = await FirebaseApi.uploadFile(destination, myimage as File);

      if (task == null) return;
      final snapshot = await task!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      await FirebaseApi.updateProfile(urlDownload, destination);
      Get.back();
      Get.back();
    } on PlatformException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Verticalspace(20),
                Container(
                  width: double.infinity,
                ),
                Stack(
                  children: [
                    ClipOval(
                      child: Container(
                        color: TEXT_WHITE_2,
                        padding: EdgeInsets.all(5),
                        child: ClipOval(
                          child: authxcontroller
                                      .useracountdetails.value.image_url ==
                                  null
                              ? Image.asset(
                                  'assets/images/images.jpg',
                                  height: 130,
                                  width: 130,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  '${authxcontroller.useracountdetails.value.image_url}',
                                  height: 130,
                                  width: 130,
                                  loadingBuilder: (context, child, progress) =>
                                      progress == null
                                          ? child
                                          :
                                           Container(

                                              height: 130,
                                              width: 130,
                                              child: Center(
                                                child: CircularProgressIndicator(
                                                color: ELSA_BLUE_1_,
                                                ),
                                              ),
                                            ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 5,
                        right: 5,
                        child: IconButton(
                            onPressed: () {
                              Profiledialog.showSimpleDialog(
                                  context, pickImage);
                            },
                            icon: Icon(
                              Icons.camera_alt,
                            ),
                            iconSize: 34,
                            color: Colors.white)),
                  ],
                ),
                Verticalspace(24),
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 50),
                          height: 50,
                          decoration: const ShapeDecoration(
                            shape: StadiumBorder(),
                            gradient: LinearGradient(
                              end: Alignment.bottomCenter,
                              begin: Alignment.topCenter,
                              colors: [
                                ELSA_BLUE_1_,
                                ELSA_BLUE_1_,
                              ],
                            ),
                          ),
                          child: MaterialButton(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            shape: const StadiumBorder(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Edit Profile',
                                    style: Get.textTheme.bodyText1!
                                        .copyWith(fontWeight: FontWeight.w400)),
                                Horizontalspace(10),
                                FaIcon(
                                  FontAwesomeIcons.angleRight,
                                  size: 34,
                                  color: ELSA_TEXT_WHITE,
                                ),
                              ],
                            ),
                            onPressed: () async {
                              Get.to(() => EditprofileScreen(),
                                  fullscreenDialog: true,
                                  transition: Transition.zoom);
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              Authdialog.shouwLogoutDialog(context);
                            },
                            icon: FaIcon(
                              Icons.logout_outlined,
                              color: ELSA_TEXT_GREY,
                            ))
                      ]),
                ),
                Verticalspace(24),
                Text('${authxcontroller.useracountdetails.value.name}',
                    style: Get.textTheme.headline1!.copyWith(
                        color: ELSA_TEXT_WHITE, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center),
                Verticalspace(8),
                Text('${authxcontroller.useracountdetails.value.email}',
                    style: Get.textTheme.headline1!.copyWith(
                        color: ELSA_TEXT_GREY,
                        fontSize: 16,
                        fontWeight: FontWeight.w100),
                    textAlign: TextAlign.center),
                Verticalspace(24),
                infoBuilder(
                    FontAwesomeIcons.mobileAlt,
                    '${authxcontroller.useracountdetails.value.phone}',
                    ELSA_GREEN),
                Verticalspace(12),
                infoBuilder(
                    FontAwesomeIcons.envelope,
                    '${authxcontroller.useracountdetails.value.email}',
                    ELSA_PINK),
                Container(
                  height: 270,
                  child:  AnimationLimiter(
          child: ListView.builder(
          shrinkWrap: true,
          itemCount: driverxcontroller.listofRatings.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: FadeInAnimation(
              //verticalOffset: 50.0,
              child: ScaleAnimation(
                child:  Material(
                color: Colors.transparent,
                child: ratingBuilder(driverxcontroller.listofRatings[index]),
              ),
            ),)
          );
            
            //
          }),
        ),
               
                ),
                Verticalspace(120),
              ],
            );
          }),
        ),
      ),
    );
  }

Widget ratingBuilder(Rating rating){
  return Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: BACKGROUND_BLACK,
                              borderRadius:
                                  BorderRadius.circular(containerRadius)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipOval(
                                    child: Container(
                                      color: ELSA_TEXT_WHITE,
                                      padding: EdgeInsets.all(1),
                                      child: ClipOval(
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          color: listofcolors[random
                                              .nextInt(listofcolors.length)],
                                          padding: EdgeInsets.all(2),
                                          child: Center(
                                            child: Text(rating.passenger_name ==  null ? 'K' :  rating.passenger_name![0].toUpperCase()  ,
                                              style: Get.textTheme.headline1!
                                                  .copyWith(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${rating.passenger_name} ',
                                          style: Get.textTheme.bodyText1,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            RatingBar.builder(
                                              initialRating: 5,
                                              minRating: 5,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 20,
                                              itemPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              itemBuilder: (context, _) =>
                                                  Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              '${rating.rate} ',
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    '${rating.comment} '),
                              ),
                            ],
                          ),
                        );
}
  Widget infoBuilder(IconData icon, String label, Color color) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                child: Center(
                  child: FaIcon(
                    icon,
                    color: color,
                  ),
                ),
              ),
              Horizontalspace(16),
              Expanded(
                  child: Text(
                label,
                style: Get.textTheme.bodyText1!.copyWith(),
              )),
            ],
          ),
        ]);
  }
}
