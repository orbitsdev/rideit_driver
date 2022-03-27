import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';

import 'package:tricycleappdriver/controller/requestdatacontroller.dart';
import 'package:tricycleappdriver/dialog/infodialog.dart/info_dialog.dart';
import 'package:tricycleappdriver/screens/ongoingtrip.dart';
import 'package:tricycleappdriver/screens/tripdetails_screen.dart';
import 'package:tricycleappdriver/widgets/elsabutton.dart';
import 'package:tricycleappdriver/widgets/horizontalspace.dart';
import 'package:tricycleappdriver/widgets/tripwidget/custompinlocation.dart';
import 'package:tricycleappdriver/widgets/tripwidget/listcontainer.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({Key? key}) : super(key: key);
  static const screenName = '/tripscreen';

  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  var requestxcontroller = Get.find<Requestdatacontroller>();
  var driverxcontroller = Get.find<Drivercontroller>();
  bool hasongointrip = false;
  bool loadingrequest = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    this.tabController.addListener(() => setState(() {}));
    Future.delayed(Duration.zero,(){
         getOngoinTripDataIfHasRequqest(context);
    });
  }

  

  
  void getOngoinTripDataIfHasRequqest(BuildContext context) async {
    if (requestxcontroller.requestdetails.value.request_id != null) {
      tripSetter(true);
      loaderSetter(false);
    } else {
      //check database ia has trip
      bool response = await requestxcontroller.checkIfHasOngoingRequest();
      if (response) {
        var ready = await requestxcontroller.getRequestData(context);
        if (ready) {
          tripSetter(true);
          loaderSetter(false);
        } else {
          //error uccor when fetch data
          tripSetter(false);
          loaderSetter(false);
        }
      } else {
        //false then display emty
        tripSetter(false);
        loaderSetter(false);
      }
    }
  }

@override
  void setState(VoidCallback fn) {
    if(mounted){
    super.setState(fn);

    }
  }

  void tripSetter(bool value) {
    setState(() {
      hasongointrip = value;
    });
  }

  void loaderSetter(bool value) {
    setState(() {
      loadingrequest = value;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child:
         Column(children: [
          Container(
            padding: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  BACKGROUND_TOP,
                  BACKGROUND_CEENTER,
                ],
              ),
              // color: BACKGROUND_BLACK_LIGHT_MORE_LIGHT,
            ),
            height: 80,
            child: TabBar(
                controller: tabController,
                labelColor: TEXT_COLOR_WHITE,
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ELSA_BLUE_2_,
                      ELSA_BLUE_1_,
                    ],
                  ),
                ),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Ongoing Trip".toUpperCase()),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Records".toUpperCase()),
                    ),
                  ),
                ]),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    BACKGROUND_TOP,
                    BACKGROUND_BOTTOM,
                  ],
                ),
                borderRadius:
                    BorderRadius.all(Radius.circular(containerRadius)),
              ),
              child: TabBarView(
                controller: tabController,
                children: [
                  loadingrequest
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        )
                      : !hasongointrip
                          ? noDataBuilder()
                          : requestBuilder(),
                  listtBuilder(),
                ],
              ),
            ),
          ),
        ]),
       
      ),
    );
  }

  Widget listtBuilder() {
    return Obx(() {
      if (driverxcontroller.lisoftriprecord.length > 0) {


         return  AnimationLimiter(
           child: ListView.builder(
            shrinkWrap: true,
            itemCount: driverxcontroller.lisoftriprecord.length,
            itemBuilder: (context, index) {
              return Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        Get.to(
                            () => TripdetailsScreen(
                                  trip:
                                      driverxcontroller.lisoftriprecord[index],
                                    
                                ),
                            fullscreenDialog: true, transition: Transition.zoom);
                      },
                      child: Listcontainer(
                          status:'${driverxcontroller.lisoftriprecord[index].tripstatus}',
                          statuscolor: ELSA_GREEN,
                          picklocation:
                              '${driverxcontroller.lisoftriprecord[index].pickaddress_name}',
                          droplocation:
                              '${driverxcontroller.lisoftriprecord[index].dropddress_name}',
                          date:
                              '${driverxcontroller.lisoftriprecord[index].created_at}')));
            }),
         );
       
      }
      return noDataBuilder();
    });
  }

  Widget noDataBuilder() {

    
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/images/66528-qntm.json',
          ),
          Text('No current trip yet ',
              style: Get.textTheme.headline1!.copyWith(
                  color: ELSA_TEXT_GREY,
                  fontSize: 24,
                  fontWeight: FontWeight.w800)),
          Verticalspace(8),
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Text(
              'Just chill while waiting customers request',
              textAlign: TextAlign.center,
              style: Get.theme.textTheme.bodyText1!.copyWith(
                color: ELSA_TEXT_GREY,
              ),
            ),
          ),
          Verticalspace(100),
        ],
      ),
    );
  }

  Widget requestBuilder() {
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Verticalspace(8),
            Container(
              margin: EdgeInsets.only(left: 10),
              padding: EdgeInsets.symmetric(),
              child: Text(
                'Details',
                style: Get.textTheme.headline5!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    BACKGROUND_BOTTOM,
                    BACKGROUND_TOP,
                  ],
                ),
                borderRadius:
                    BorderRadius.all(Radius.circular(containerRadius)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To collect',
                            style: Get.textTheme.bodyText1!
                                .copyWith(fontWeight: FontWeight.w300),
                          ),
                          RichText(
                            text: TextSpan(
                              style: Get.textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 34),
                              children: [
                                TextSpan(
                                    text: '₱ ',
                                    style: TextStyle(color: Colors.amber[300])),
                                TextSpan(
                                    text:
                                        '${requestxcontroller.requestdetails.value.fee}.00'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(right: 12),
                      padding: EdgeInsets.all(12),
                      child: FaIcon(
                        FontAwesomeIcons.coins,
                        color: Colors.amber[400],
                        size: 34,
                      )),
                ],
              ),
            ),
            Verticalspace(12),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(containerRadius)),
                  color: LIGHT_CONTAINER,
                ),
                constraints: BoxConstraints(minHeight: 200),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Horizontalspace(12),
                        ClipOval(
                          child: Material(
             
                            child: InkWell(
                              splashColor: Colors.red, // Splash color
                              onTap: () {
                                InfoDialog.noDataDialog(context,'If you press the phone number it will redirect you to the dial number ☺️');

                              },
                              child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(17)),
                                //
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    ELSA_GREEN,
                                    ELSA_BLUE,
                                  ],
                                )),
                            child: Center(
                                child: FaIcon(
                              FontAwesomeIcons.exclamation,
                              color: Colors.white,
                            ))
                            ),
                          ),
                        )
                        ),
                      ],
                    ),
                    Custompinlocation(
                        title: 'Passenger Name',
                        lication:
                            '${requestxcontroller.requestdetails.value.passenger_name}',
                        icon: FontAwesomeIcons.user,
                        color: ELSA_BLUE_2_),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          await launch(
                              'tel:${requestxcontroller.requestdetails.value.passenger_phone}');
                        },
                        child: Custompinlocation(
                            title: 'Passenger Phone',
                            lication:
                                '${requestxcontroller.requestdetails.value.passenger_phone}',
                            icon: FontAwesomeIcons.mobileAlt,
                            color: ELSA_ORANGE),
                      ),
                    ),
                    Custompinlocation(
                        title: 'Passenger Pickup Location',
                        lication:
                            '${requestxcontroller.requestdetails.value.pickaddress_name}',
                        icon: FontAwesomeIcons.mapMarkerAlt,
                        color: ELSA_PINK),
                    Custompinlocation(
                        title: 'Passenger Drop-off Location',
                        lication:
                            '${requestxcontroller.requestdetails.value.dropddress_name}',
                        icon: FontAwesomeIcons.mapPin,
                        color: ELSA_GREEN),
                  ],
                ),
              ),
            ),
            Verticalspace(24),
            Elsabutton(
                label: 'View',
                function: () {
                  Get.to(()=> Ongoingtrip(),);
                }),
            Verticalspace(120),
          ],
        ),
      );
    });
  }
}
