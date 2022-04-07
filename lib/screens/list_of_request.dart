import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';

import 'package:tricycleappdriver/controller/requestdatacontroller.dart';
import 'package:tricycleappdriver/dialog/infodialog.dart/info_dialog.dart';
import 'package:tricycleappdriver/dialog/infodialog/infodialog.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/model/request_details.dart';
import 'package:tricycleappdriver/screens/map/map_request_controller.dart';
import 'package:tricycleappdriver/screens/map/request_map_screen.dart';
import 'package:tricycleappdriver/widgets/horizontalspace.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class ListOfRequest extends StatefulWidget {
  static const screenName = '/lisofscreen';
  @override
  _ListOfRequestState createState() => _ListOfRequestState();
}

class _ListOfRequestState extends State<ListOfRequest> {
  var requestxcontroller = Get.put(Requestdatacontroller());
  var authxcontroller = Get.put(Authcontroller());
  var mapxcontroller = Get.put(MapRequestController());
  

  @override
  void initState() {
    super.initState();

    listenToUnAccepteRequest();
  }

  void listenToUnAccepteRequest() async {
    
    requestcollecctionrefference
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((querySnapShot) {

      

      // requestxcontroller.lisofunacceptedrequest(
        
      //   querySnapShot.docs.map((e) {
      //   var request = RequestDetails.fromJson(e.data() as Map<String, dynamic>);
      //   request.request_id = e.id;
      //   return request;
      // }).toList());
           requestxcontroller.lisofunacceptedrequest().clear();
      querySnapShot.docs.forEach((element) { 
               
             var request = RequestDetails.fromJson(element.data() as Map<String, dynamic>);
             request.request_id = element.id;
             if(requestxcontroller.lisofunacceptedrequest.length == 0){
               requestxcontroller.lisofunacceptedrequest.add(request);
             }else{
               requestxcontroller.lisofunacceptedrequest.insert(requestxcontroller.lisofunacceptedrequest.length -1 , request);

             }
           
      });
      
      if(querySnapShot.docs.length == 0  && requestxcontroller.ongoingtrip.value.drop_location_id ==  null){
          
          Get.off(()=>HomeScreenManager());

      }
      
      print('lenght of of unaccepred rtequest');
      print(requestxcontroller.lisofunacceptedrequest.length);
    });
  }

  void exitThisScreen(){
      Get.back();  
  }

  void viewRequestDirection(RequestDetails request) async {
    if (request.drop_location_id ==  mapxcontroller.requestdroplocatioinid) {
      Get.to(() => RequestMapScreen(request: request,), fullscreenDialog: true);
    } else {
      var response = await mapxcontroller.getDirection(context,
          request.pick_location_id
              as String,
          request.drop_location_id
              as String,
          request.actualmarker_position
              as LatLng);
      if (response) {
       
        Get.to(() => RequestMapScreen(request: request,), fullscreenDialog: true);
      } else {
      
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      actions: [
        IconButton(onPressed: (){

               InfoDialog.noDataDialog(context,'You can only access this screen when there is a new request from the passenger. So dont close it. If you dont want to accept any request. Then make sure your acount is offline. ☺️');
        }, icon: FaIcon(FontAwesomeIcons.exclamationCircle, color: ELSA_BLUE_2_,))
      ],
        leading:
            IconButton(onPressed: () {
              
            //Get.off(()=> HomeScreenManager());
            Get.back();
            }, icon: FaIcon(FontAwesomeIcons.times)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Obx(() {
            if (requestxcontroller.lisofunacceptedrequest.length == 0) {
              return noDataBuilder();
            } else {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: LIGHT_CONTAINER,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipOval(
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Image.network('${requestxcontroller.lisofunacceptedrequest[0].passenger_image_url}', fit: BoxFit.cover,),
                              ),
                            ),
                            Horizontalspace(8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${requestxcontroller.lisofunacceptedrequest[0].passenger_name}',
                                      style: Get.textTheme.bodyText1!.copyWith(
                                          fontWeight: FontWeight.w600)),
                                  Verticalspace(5),
                                  Row(children: [
                                    ClipOval(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          //
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              ELSA_PINK_TEXT,
                                              ELSA_PINK_TEXT,
                                            ],
                                          ),
                                        ),
                                        width: 30,
                                        height: 30,
                                        child: Center(
                                            child: Text(
                                          'FR',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        )),
                                      ),
                                    ),
                                    Horizontalspace(4),
                                    Expanded(
                                      child: Text(
                                        '${requestxcontroller.lisofunacceptedrequest[0].pickaddress_name}',
                                        style:
                                            Get.textTheme.bodyText1!.copyWith(
                                          fontWeight: FontWeight.w100,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            ),
                          ],
                        ),
                        Verticalspace(12),
                        Container(
                          decoration: BoxDecoration(
                              color: BOTTOMNAVIGATOR_COLOR,
                              borderRadius: BorderRadius.circular(12)),
                          padding: EdgeInsets.all(12),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 34,
                                      width: 34,
                                      child: Center(
                                        child: FaIcon(
                                          FontAwesomeIcons.mapPin,
                                          color: ELSA_GREEN,
                                        ),
                                      ),
                                    ),
                                    Horizontalspace(12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Drop Location',
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w100),
                                          ),
                                          Verticalspace(8),
                                          Text(
                                            '${requestxcontroller.lisofunacceptedrequest[0].dropddress_name}',
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                        Verticalspace(12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: DARK_GREEN,
                                  ),
                                  onPressed: () {
                                    if(authxcontroller.hasinternet.value){
                                       if(requestxcontroller.hasacceptedrequest.value == false){

                                        requestxcontroller.confirmRequest(context, requestxcontroller.lisofunacceptedrequest[0].request_id);
                                    }else{
                                        Infodialog.showInfoToastCenter('You can oly accept request once at a time');
                                    }
                                    }else{
                                      Infodialog.showInfoToastCenter('No internet');
                                    }
                                   
                                  },
                                  child: Text('Accept')),
                            ),
                            Horizontalspace(24),
                            Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: PINK_1,
                                  ),
                                  onPressed: () async {
                                    viewRequestDirection(requestxcontroller.lisofunacceptedrequest[0]);
                                  },
                                  child: Text('View Location')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Verticalspace(12),
                  if (requestxcontroller.lisofunacceptedrequest.length > 0)
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height,
                      ),
                      child: AnimationLimiter(
                        child: ListView.builder(
                        
                            shrinkWrap: true,
                            itemCount: requestxcontroller
                                .lisofunacceptedrequest.length,
                            itemBuilder: (context, index) {
                              if (requestxcontroller.lisofunacceptedrequest[0].drop_location_id == requestxcontroller.lisofunacceptedrequest[index].drop_location_id) {
                                return Container(
                                  height: 0,
                                );
                              } else {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      color: LIGHT_CONTAINER,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Row(
                                    children: [
                                      Horizontalspace(12),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              
                                              Row(
                                                children: [
                                                   ClipOval(
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Image.network('${requestxcontroller.lisofunacceptedrequest[index].passenger_image_url}', fit: BoxFit.cover,),
                              ),
                            ),Horizontalspace(8),
                                                  Flexible(
                                                    child: Text(
                                                        '${requestxcontroller.lisofunacceptedrequest[index].passenger_name} ',
                                                        style: Get
                                                            .textTheme.bodyText1!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight.w600)),
                                                  ),
                                                ],
                                              ),
                                              Verticalspace(4),
                                              Row(
                                                children: [
                                                  ClipOval(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        //
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomLeft,
                                                          colors: [
                                                            ELSA_PURPLE_2_,
                                                            ELSA_PURPLE_1_,
                                                          ],
                                                        ),
                                                      ),
                                                      width: 30,
                                                      height: 30,
                                                      child: Center(
                                                          child: Text(
                                                        'FR',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      )),
                                                    ),
                                                  ),
                                                  Horizontalspace(5),
                                                  // Container(
                                                  //   width: 30,
                                                  //    padding: EdgeInsets.all(5),
                                                  //   child: Center(child: FaIcon(FontAwesomeIcons.mapMarkerAlt, color: ELSA_PINK,)),
                                                  // ),
                                                  Flexible(
                                                    child: Text(
                                                      '${requestxcontroller.lisofunacceptedrequest[index].pickaddress_name}',
                                                      style: Get
                                                          .textTheme.bodyText1!
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Verticalspace(6),
                                              Row(
                                                children: [
                                                  ClipOval(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        //
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomLeft,
                                                          colors: [
                                                            ELSA_BLUE_2_,
                                                            ELSA_BLUE_1_,
                                                          ],
                                                        ),
                                                      ),
                                                      width: 30,
                                                      height: 30,
                                                      child: Center(
                                                          child: Text(
                                                        'TO',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      )),
                                                    ),
                                                  ),
                                                  Horizontalspace(5),
                                                  // Container(
                                                  //   width: 30,
                                                  //    padding: EdgeInsets.all(5),
                                                  //   child: Center(child: FaIcon(FontAwesomeIcons.mapMarkerAlt, color: ELSA_PINK,)),
                                                  // ),
                                                  Flexible(
                                                    child: Text(
                                                      '${requestxcontroller.lisofunacceptedrequest[index].dropddress_name}',
                                                      style: Get
                                                          .textTheme.bodyText1!
                                                          .copyWith(
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                 requestxcontroller.confirmRequest(context, requestxcontroller.lisofunacceptedrequest[index].request_id);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(2),
                                                  child: Column(children: [
                                                    FaIcon(
                                                        FontAwesomeIcons
                                                            .checkCircle,
                                                        size: 34,
                                                        color: ELSA_GREEN),
                                                    Text('Accept',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[400],
                                                            fontWeight:
                                                                FontWeight
                                                                    .w100))
                                                  ]),
                                                ),
                                              ),
                                              Horizontalspace(8),
                                              GestureDetector(
                                                onTap: () {
                                                 viewRequestDirection(requestxcontroller.lisofunacceptedrequest[index]);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(2),
                                                  child: Column(children: [
                                                    FaIcon(
                                                        FontAwesomeIcons
                                                            .mapMarkedAlt,
                                                        size: 34,
                                                        color: ELSA_BLUE),
                                                    Text('View',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[400],
                                                            fontWeight:
                                                                FontWeight
                                                                    .w100))
                                                  ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Verticalspace(8),
                                          Text('New Request'.toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: DARK_GREEN,
                                                  fontWeight: FontWeight.w400))
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              }
                            }),
                      ),
                    ),
                ],
              );
            }
          }),
        ),
      ),
    );
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
          Text('No request yet',
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
}
