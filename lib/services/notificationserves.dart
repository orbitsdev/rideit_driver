import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/mapcontroller.dart';

import 'package:tricycleappdriver/controller/requestdatacontroller.dart';
import 'package:tricycleappdriver/dialog/infodialog.dart/info_dialog.dart';
import 'package:tricycleappdriver/dialog/infodialog/infodialog.dart';
import 'package:tricycleappdriver/dialog/requestdialog/requestdialog.dart';
import 'package:tricycleappdriver/model/un_accepted_request.dart';
import 'package:tricycleappdriver/screens/list_of_request.dart';
import 'package:tricycleappdriver/services/localnotificationservice.dart';

class Notificationserves {
  var requestcontroller = Get.find<Requestdatacontroller>();
  var driverxcontroller = Get.find<Drivercontroller>();

  Future initialize() async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // print('______from terminated push notification');

        print(message.data);
        print(message.data["recieve_request"]);
       
        //(jsonDecode(message.data["recieve_request"]));

        //showRequestDialog(message.data['recieve_request']);

      }
    });
    //forground
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print('fourground____________');
        print(message.data);
     
       gotoScreenOfunacceptedRequest( jsonDecode(message.data["recieve_request"]));
      }
      //Localnotificationservice.display(message);
    });

    //when at the backgroudn and user tap the notfication
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        /// print('______from push notificaion backround ');
        /// print(message.data["request_id"]);

        print('background____________');
        print('background_______________');
        print(message.data["recieve_request"]);

        gotoScreenOfunacceptedRequest( jsonDecode(message.data["recieve_request"]));
      }
    });
  }

  void gotoScreenOfunacceptedRequest(Map<String, dynamic> recieverequest) {

     if(driverxcontroller.isOnline.value){

    //IF HAS ACCEPTD REQUEST PREVENT FROM SHOWING LIST OF SCREEN
        if(requestcontroller.hasacceptedrequest.value == false){
           UnAcceptedRequest unacceptedrequest =  UnAcceptedRequest.fromJson(recieverequest);
             Get.to(() => ListOfRequest());
        }else{

            Infodialog.showInfoToastCenter('New Request is Comings');
        }
     
    

    }
   
  }
}
