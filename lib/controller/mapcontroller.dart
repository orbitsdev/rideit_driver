import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/dialog/infodialog/infodialog.dart';

import 'package:tricycleappdriver/helper/firebasehelper.dart';

class Mapcontroller extends GetxController {
  var isOnline = false.obs;
  var isOnlineLoading = false.obs;
  var isonlinelastime = false.obs;
  Position? currentposition;
  var authxcontroller = Get.find<Authcontroller>();

  

  @override
  void onInit() {

    super.onInit();
  }

  void checkDriverIsOnlie() {
    var ref = availablereference
        .orderByKey()
        .equalTo(authinstance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
       
     
        isOnline(true);
      } else {
        isOnline(false);
          

      }
    });
  }
@override
  void dispose() {
    
      driverslocationstream!.cancel();
    super.dispose();
  }
  

  void makeDriverOnline() async{

    try{
       isOnlineLoading(true);
          
          if(currentposition == null){
            currentposition =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            print('called');

          }
          try{
           

        Map<String, dynamic> driverpostion = {
          'latitude': currentposition!.latitude,
          'longitude': currentposition!.longitude,
        };
        await availabledriverrefference.doc(authinstance.currentUser!.uid).set(
        {"driver_location":driverpostion , "token": authxcontroller.useracountdetails.value.device_token, "status": "online"},
      );

          }on PlatformException catch(e){
              print(e.message);
              Infodialog.showInfoToastCenter(e.message.toString());
          }
          
       
        isOnlineLoading(false);
        isOnline(true);

    }catch(e){
       Infodialog.showInfoToastCenter(e.toString());
        isOnlineLoading(false);
  
    }
  }

  

  void makeDriverOffline() async {

    await availabledriverrefference.doc(authinstance.currentUser!.uid).delete();
  

    isOnlineLoading(false);
    isOnline(false);
        print("make drive offline called");
  }



  

  
}
