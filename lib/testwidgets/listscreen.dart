import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:tricycleappdriver/UI/constant.dart';

import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/model/request_details.dart';
import 'package:tricycleappdriver/model/un_accepted_request.dart';
import 'package:tricycleappdriver/screens/map/map_request_controller.dart';
import 'package:tricycleappdriver/screens/map/request_map_screen.dart';
import 'package:tricycleappdriver/widgets/horizontalspace.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class ListOfRequest extends StatefulWidget {
  UnAcceptedRequest? unacceptedrequest;
  ListOfRequest({
    Key? key,
    this.unacceptedrequest,
  }) : super(key: key);

  static const screenName = '/listofequest';

  @override
  _ListOfRequestState createState() => _ListOfRequestState();
}

class _ListOfRequestState extends State<ListOfRequest> {
  var requestxcontroller = Get.put(Requestcontroller());
  var maprequestxcontroller = Get.put(MapRequestController());
  RequestDetails? requestoaccept;
  @override
  void initState() {
    listenToUnAccepteRequest();
    super.initState();
  }

  void listenToUnAccepteRequest() async {
    requestcollecctionrefference
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((querySnapShot) {
      requestxcontroller.lisofunacceptedrequest(querySnapShot.docs.map((e) {
        var request = RequestDetails.fromJson(e.data() as Map<String, dynamic>);
        request.request_id = e.id;
        return request;
      }).toList());

      if (requestxcontroller.lisofunacceptedrequest.length == 0 &&
          requestxcontroller.hasongingtrip == false) {
        Get.offNamed(HomeScreenManager.screenName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        
        child: Obx(() {
          return Container(
              padding: EdgeInsets.all(20),
             
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height
            ),
            
            
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                
                
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: LIGHT_CONTAINER,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      )),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          color: TEXT_WHITE_2,
                          padding: EdgeInsets.all(5),
                          child: ClipOval(
                              child: Image.asset(
                            'assets/images/images.jpg',
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                      Text(
                        "${requestxcontroller.lisofunacceptedrequest[0].passenger_name} ",
                        style: Get.textTheme.headline1!.copyWith(
                          color: ELSA_TEXT_WHITE,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Passenger'.toUpperCase(),
                        style: Get.textTheme.subtitle1!
                            .copyWith(fontSize: 12, color: ELSA_TEXT_GREY),
                        textAlign: TextAlign.center,
                      ),
                      Verticalspace(8),

                      Container(
                        decoration: BoxDecoration(
                            color: BOTTOMNAVIGATOR_COLOR,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            )),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        child: Column(
                          children: [
                            Row(
                              children: [

                                 Container(
                                    width: 34,
                                    height: 34,
                                    child: Center(
                                        child: FaIcon(
                                      FontAwesomeIcons.mapMarkerAlt,
                                      color: ELSA_PINK,
                                    ))),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("From"),
                                        Text(
                                          "${requestxcontroller.lisofunacceptedrequest[0].dropddress_name}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                               
                              ],
                            )
                          ],
                        ),
                      ),
                      Verticalspace(8),
                      Container(
                        decoration: BoxDecoration(
                            color: BOTTOMNAVIGATOR_COLOR,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            )),
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        child: Column(
                          children: [
                            Row(
                              children: [

                                 Container(
                                    width: 34,
                                    height: 34,
                                    child: Center(
                                        child: FaIcon(
                                      FontAwesomeIcons.mapPin,
                                      color: ELSA_GREEN,
                                    ))),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("to"),
                                        Text(
                                          "${requestxcontroller.lisofunacceptedrequest[0].pickaddress_name}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                               
                              ],
                            )
                          ],
                        ),
                      ),
            Verticalspace(8),

                          
                  ConfirmationSlider(
                    height: 60,
                    stickToEnd: false,
                    backgroundColor: LIGHT_CONTAINER,
                    foregroundColor: ELSA_BLUE_2_,
                    textStyle: TextStyle(color: Colors.white, fontSize: 16),
                    onConfirmation: () {
                                            },
                  ),

                      // ElevatedButton(
                      //     onPressed: () {
                      //       requestxcontroller.confirmRequest(
                      //           context,
                      //           requestxcontroller
                      //               .lisofunacceptedrequest[0].request_id);
                      //     },
                      //     child: Text('Confirm')),
                      ElevatedButton(
                          onPressed: () async {
                            if (requestxcontroller
                                    .lisofunacceptedrequest[0].drop_location_id ==
                                maprequestxcontroller.requestdroplocatioinid) {
                              Get.to(() => RequestMapScreen(),
                                  fullscreenDialog: true);
                            } else {
                              var response =
                                  await maprequestxcontroller.getDirection(
                                      requestxcontroller.lisofunacceptedrequest[0]
                                          .pick_location_id as String,
                                      requestxcontroller.lisofunacceptedrequest[0]
                                          .drop_location_id as String,
                                      requestxcontroller.lisofunacceptedrequest[0]
                                          .actualmarker_position as LatLng);
                              if (response) {
                                print(maprequestxcontroller
                                    .requestmapdetails.value.polylines_encoded);
                                print('wazap');
                                Get.to(() => RequestMapScreen(),
                                    fullscreenDialog: true);
                              } else {
                                print('ohn now');
                              }
                            }
                          },
                          child: Text('View')),
                    ],
                  ),
                ),

                
                Container(
              
                  padding: EdgeInsets.symmetric(vertical: 10,),
                  child: ListView.builder(
                      //reverse: true,
                      shrinkWrap: true,
                      itemCount: requestxcontroller.lisofunacceptedrequest.length,
                      itemBuilder: (context, index) {
                        if (index <0) {
                          return Container(
                            height: 0,
                          );
                        } else {

                          return ListTile(
                            leading:  ClipOval(
                        child: Container(
                          color: TEXT_WHITE_2,
                          padding: EdgeInsets.all(1),
                          child: ClipOval(
                              child: Image.asset(
                            'assets/images/images.jpg',
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),                           
                            onTap: (){

                            },
                            tileColor: LIGHT_CONTAINER,
                            title: Text('From: ${requestxcontroller.lisofunacceptedrequest[index].pickaddress_name}', style: TextStyle(color: Colors.white,)),
                            subtitle: Text('To: ${requestxcontroller.lisofunacceptedrequest[index].dropddress_name}', style: TextStyle(color: Colors.white,)),
                          );
                          // return Container(
                          //   color: Colors.blueAccent,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(20.0),
                          //     child: Column(
                          //       children: [
                          //         Row(
                          //           children: [
                          //             ElevatedButton(
                          //                 onPressed: () {
                          //                   requestxcontroller.confirmRequest(
                          //                       context,
                          //                       requestxcontroller
                          //                           .lisofunacceptedrequest[index]
                          //                           .request_id);
                          //                 },
                          //                 child: Text('Confirm')),
                          //             ElevatedButton(
                          //                 onPressed: () {}, child: Text('Reject')),
                          //             ElevatedButton(
                          //                 onPressed: () {}, child: Text('View')),
                          //           ],
                          //         ),
                          //         Text(requestxcontroller
                          //             .lisofunacceptedrequest[index]
                          //             .dropddress_name as String),
                          //         SizedBox(
                          //           height: 12,
                          //         ),
                          //         Text(requestxcontroller
                          //             .lisofunacceptedrequest[index]
                          //             .pickaddress_name as String),
                          //       ],
                          //     ),
                          //   ),
                          // );
                        }
                      }),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
