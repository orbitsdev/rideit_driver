import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/widgets/elsabutton.dart';
import 'package:tricycleappdriver/widgets/horizontalspace.dart';
import 'package:tricycleappdriver/widgets/tripwidget/custompinlocation.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({Key? key}) : super(key: key);
  static const screenName = '/tripscreen';

  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  var requestxcontroller = Get.find<Requestcontroller>();
  var driverxcontroller = Get.find<Drivercontroller>();
  bool hasongointrip = false;
  bool loadingrequest = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    this.tabController.addListener(() => setState(() {}));
  }

  bool isdepencycalled = false;
  @override
  void didChangeDependencies() {
    getOngoinTripDataIfHasRequqest(context);
    super.didChangeDependencies();
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
        child: Column(children: [
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
                      child: Text("Ongoing".toUpperCase()),
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
              margin: EdgeInsets.all(16),
              child: TabBarView(
                controller: tabController,
                children: [
                  loadingrequest
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : !hasongointrip
                          ? Center(
                              child: Text('No Data'),
                            )
                          : Obx(() {
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Verticalspace(8),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(containerRadius)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'To collect',
                                                    style: Get.textTheme.bodyText1!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w300),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      style: Get
                                                          .textTheme.headline5!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize: 34),
                                                      children: [
                                                        TextSpan(
                                                            text: '₱ ',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .amber[300])),
                                                        TextSpan(
                                                            text:
                                                                '${driverxcontroller.totalearning}.00'),
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
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(containerRadius)),
                                          color: LIGHT_CONTAINER,
                                        ),
                                        constraints: BoxConstraints(minHeight: 200),
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Custompinlocation(
                                                title: 'Passenger Name',
                                                lication: '${requestxcontroller.requestdetails.value.passenger_name }',
                                                icon: FontAwesomeIcons.user,
                                                color: ELSA_BLUE_2_),
                                            Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: (){
                                        
                                                },
                                                child: Custompinlocation(
                                                    title: 'Passenger Phone',
                                                    lication: '${requestxcontroller.requestdetails.value.passenger_phone }',
                                                    icon: FontAwesomeIcons.mobileAlt,
                                                    color: ELSA_ORANGE),
                                              ),
                                            ),
                                            Custompinlocation(
                                                title: 'Passenger Pickup Location',
                                                lication: '${requestxcontroller.requestdetails.value.pickaddress_name }',
                                                icon: FontAwesomeIcons.mapMarkerAlt,
                                                color: ELSA_PINK),
                                          
                                            Custompinlocation(
                                                title: 'Passenger Drop-off Location',
                                                lication: '${requestxcontroller.requestdetails.value.dropddress_name}',
                                                icon: FontAwesomeIcons.mapPin,
                                                color: ELSA_GREEN),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Verticalspace(34),
                                    Elsabutton(label: 'View', function: (){print('hellow');}),
                                    Verticalspace(140),
                                    
                                  ],
                                ),
                              );
                            }),
                  Icon(Icons.directions_car, size: 350),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
