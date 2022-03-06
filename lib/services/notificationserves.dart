import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/dialog/requestdialog/requestdialog.dart';
import 'package:tricycleappdriver/model/un_accepted_request.dart';
import 'package:tricycleappdriver/screens/list_of_request.dart';
import 'package:tricycleappdriver/services/localnotificationservice.dart';

class Notificationserves {
  var requestcontroller = Get.find<Requestcontroller>();

  Future initialize() async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // print('______from terminated push notification');

        print(message.data);
        print(message.data["recieve_request"]);
        processRequest(jsonDecode(message.data["recieve_request"]));

        //showRequestDialog(message.data['recieve_request']);

      }
    });
    //forground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print('fourground____________');
        print(message.data);
        print(message.data["recieve_request"]);
        processRequest(jsonDecode(message.data["recieve_request"]));

      }
      //Localnotificationservice.display(message);
    });

    //when at the backgroudn and user tap the notfication
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        /// print('______from push notificaion backround ');
        /// print(message.data["request_id"]);

        /// print(message.data);
        print('background____________');
        print('background_______________');
        print(message.data["recieve_request"]);
        processRequest(jsonDecode(message.data["recieve_request"]));

      }
    });
  }

  void processRequest(Map<String, dynamic> recieverequest) {
    UnAcceptedRequest unacceptedrequest = UnAcceptedRequest.fromJson(recieverequest);
        Get.off(()=> ListOfRequest(unacceptedrequest:unacceptedrequest ,) ); 
   
  }
}
