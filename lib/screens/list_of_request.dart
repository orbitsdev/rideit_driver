import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/model/request_details.dart';
import 'package:tricycleappdriver/model/un_accepted_request.dart';

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
  var requestxcontroller = Get.find<Requestcontroller>();
  RequestDetails? requestoaccept;
  @override
  void initState() {
    listenToUnAccepteRequest();
    super.initState();
  }

  void listenToUnAccepteRequest() async {
    // requestcollecctionrefference.get().then((querySnapShot) {
    //   querySnapShot.docs.forEach((element) {

    //     print(element.id);
    //     print(element.data());

    //   });
    // });

    //using where conding
    // requestcollecctionrefference.where("status", isEqualTo: "pending").get().then((querySnapshot) {

    //     print('__________________ this is from listen lis of un accpeted request');
    //   querySnapshot.docs.forEach((element) {

    //     print('______________________________________________');
    //     print('|                                             |');
    //     print('|______________________________________________|');
    //     print(element.id);
    //     print(element.data());
    //   });
    // });

    requestcollecctionrefference
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((querySnapShot) {
      requestxcontroller.lisofunacceptedrequest(querySnapShot.docs.map((e) {
        var request = RequestDetails.fromJson(e.data() as Map<String, dynamic>);
        request.request_id = e.id;
        return request;
      }).toList());

      print('_________________________________ my list after listen');

      print(requestxcontroller.lisofunacceptedrequest.length);

      if (requestxcontroller.lisofunacceptedrequest.length == 0 && requestxcontroller.hasongingtrip.value == false){
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
                  height: 200,
                  width: double.infinity,
                  color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "${requestxcontroller.lisofunacceptedrequest[0].pickaddress_name}"),
                      Text(
                          "${requestxcontroller.lisofunacceptedrequest[0].dropddress_name}"),
                      ElevatedButton(
                          onPressed: () {
                            requestxcontroller.confirmRequest(requestxcontroller
                                .lisofunacceptedrequest[0].request_id);
                          },
                          child: Text('Confirm'))
                    ],
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
                                        onPressed: () {},
                                        child: Text('Confirm')),
                                    ElevatedButton(
                                        onPressed: () {}, child: Text('View')),
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
