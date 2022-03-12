import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/model/request_details.dart';
import 'package:tricycleappdriver/model/un_accepted_request.dart';
import 'package:tricycleappdriver/screens/map/map_request_controller.dart';
import 'package:tricycleappdriver/screens/map/request_map_screen.dart';

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
          if (requestxcontroller.lisofunacceptedrequest.length > 0) {
            return Column(
              
              
              children: [
              
                Container(
        
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${requestxcontroller.lisofunacceptedrequest[0].request_id }"),
                        Text("${requestxcontroller.lisofunacceptedrequest[0].actualmarker_position }", style: TextStyle(fontWeight: FontWeight.w700)),
                        Text("${requestxcontroller.lisofunacceptedrequest[0].drop_location_id }"),
                        Text("${requestxcontroller.lisofunacceptedrequest[0].drop_location }", style: TextStyle(fontWeight: FontWeight.w700),),
                        Text("${requestxcontroller.lisofunacceptedrequest[0].dropddress_name}"),
                        SizedBox(
                          height: 5,
                        ),
                        Text("${requestxcontroller.lisofunacceptedrequest[0].pick_location_id }"),
                        Text("${requestxcontroller.lisofunacceptedrequest[0].pick_location }"),
                        Text("${requestxcontroller.lisofunacceptedrequest[0].pickaddress_name}"),
                        ElevatedButton(
                            onPressed: () {
                              requestxcontroller.confirmRequest(requestxcontroller
                                  .lisofunacceptedrequest[0].request_id);
                            },
                            child: Text('Confirm')),
                             ElevatedButton(
                                          onPressed: () async{

                                            if(requestxcontroller.lisofunacceptedrequest[0].drop_location_id ==  maprequestxcontroller.requestdroplocatioinid){
                                                  Get.to(()=> RequestMapScreen(), fullscreenDialog: true);
                                            }else{
                                              var response =  await maprequestxcontroller.getDirection(requestxcontroller.lisofunacceptedrequest[0].pick_location_id as String,requestxcontroller.lisofunacceptedrequest[0].drop_location_id as String, requestxcontroller.lisofunacceptedrequest[0].actualmarker_position as LatLng);
                                            if(response){
                                            

                                                print(maprequestxcontroller.requestmapdetails.value.polylines_encoded);
                                              print('wazap');
                                              Get.to(()=> RequestMapScreen(), fullscreenDialog: true);

                                            }else{
                                              print('ohn now');
                                            }

                                            }

                                            

                                          

                                          }, child: Text('View')),
                            
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                    //reverse: true,
                    shrinkWrap: true,
                    itemCount: requestxcontroller.lisofunacceptedrequest.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          height: 0,
                        );
                      } else {
                        return Container(
                          color: Colors.blueAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          requestxcontroller.confirmRequest(
                                              requestxcontroller
                                                  .lisofunacceptedrequest[index]
                                                  .request_id);
                                        },
                                        child: Text('Confirm')),
                                    ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Reject')),
                                   
                                    ElevatedButton(
                                        onPressed: () {


                                        }, child: Text('View')),
                                  ],
                                ),
                                Text(requestxcontroller
                                    .lisofunacceptedrequest[index]
                                    .dropddress_name as String),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(requestxcontroller
                                    .lisofunacceptedrequest[index]
                                    .pickaddress_name as String),
                              ],
                            ),
                          ),
                        );
                      }
                    })
              ],
            );
          }
          return Container();
        }),
      ),
    );
  }
}
