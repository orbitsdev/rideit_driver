import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/widgets/horizontalspace.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';
import 'dart:math';


class MeScreen extends StatefulWidget {
  const MeScreen({Key? key}) : super(key: key);
  static const screenName = "/me";

  @override
  _MeScreenState createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {

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

  Random random =  Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
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
                        child: Image.asset(
                          'assets/images/images.jpg',
                          height: 130,
                          width: 130,
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
                            // Profiledialog.showSimpleDialog(context, pickImage);
                          },
                          icon: Icon(
                            Icons.camera_alt,
                          ),
                          iconSize: 34,
                          color: Colors.white))
                ],
              ),
              Verticalspace(24),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                width: 140,
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
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: const StadiumBorder(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Edit Profile', style: Get.textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w400
                      )),
                      Horizontalspace(10),
                      FaIcon(FontAwesomeIcons.angleRight,size: 34, color: ELSA_TEXT_WHITE,),
                    ],
                  ),
                  onPressed: () async {},
                ),
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
              Verticalspace(16),
              infoBuilder(
                  FontAwesomeIcons.mobileAlt,
                  '${authxcontroller.useracountdetails.value.phone}',
                  ELSA_GREEN),
              Verticalspace(8),
              infoBuilder(
                  FontAwesomeIcons.envelope,
                  '${authxcontroller.useracountdetails.value.email}',
                  ELSA_PINK),
              Verticalspace(8),


              Container(

                height: 240,

                child: AnimationLimiter(
           child: ListView.builder(
            shrinkWrap: true,
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                
                margin: EdgeInsets.symmetric(vertical: 8,),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                      color:BACKGROUND_BLACK,
                        borderRadius: BorderRadius.circular(containerRadius)
                      ),
                      child: Column(
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
                                      color: listofcolors[random.nextInt(listofcolors.length)],
                                      padding: EdgeInsets.all(2),
                                      child: Center(child: Text(authxcontroller.useracountdetails.value.name![0].toUpperCase(), style: Get.textTheme.headline1!.copyWith(),),),
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
                                          initialRating: 5,
                                          minRating: 5,
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
                                        '5.0',
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
                             child: Text('Nice and Very smooth transactions  that was the best expereince'),
                           ),
                         
                        ],
                      ),
                    );
            }),
         ),
              ),


              Verticalspace(120),
            ],
          ),
        ),
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
