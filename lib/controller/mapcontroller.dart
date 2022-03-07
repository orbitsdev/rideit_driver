import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';

import 'package:tricycleappdriver/helper/firebasehelper.dart';

class Mapcontroller extends GetxController {
  var isOnline = false.obs;
  var isOnlineLoading = false.obs;
  var isonlinelastime = false.obs;
  Position? currentposition;
  var authxcontroller = Get.find<Authcontroller>();
  //GeoFirestore geoFirestore =GeoFirestore(firestore.collection('availableDrivers'));
  

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
        print('__________ref');
        print('exist');
       // liveUpdateLocation();
        isOnline(true);
      } else {
        isOnline(false);
          
        print('__________ref');
        print(value.value);
      }
    });
  }
@override
  void dispose() {
    // TODO: implement dispose
      driverslocationstream!.cancel();
    super.dispose();
  }
  // void makeDriverOnline() async {
  //   try {
  //     isOnlineLoading(true);

  //     currentposition = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     // await geoFirestore.setLocation(authinstance.currentUser!.uid, GeoPoint(currentposition!.latitude, currentposition!.longitude));
  //     //for realtimedatabase

  //     Geofire.initialize("availableDrivers");
  //     Geofire.setLocation(authinstance.currentUser!.uid,
  //         currentposition!.latitude, currentposition!.longitude);

  //     //get device token

  //     String devicetoken = await messaginginstance.getToken() as String;

  //     await availabledriverrefference.doc(authinstance.currentUser!.uid).set(
  //       {"token": devicetoken, "status": "online"},
  //     );

  //     availablereference.onValue.listen((event) {});

  //     isOnlineLoading(false);
  //     isOnline(true);
  //   } catch (e) {
  //     print(e.toString());
  //     isOnlineLoading(false);
  //     isOnline(false);
  //   }
  // }

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
          }
          
       
        isOnlineLoading(false);
        isOnline(true);

    }catch(e){
      print(e);
      isOnlineLoading(false);
  //     isOnline(false);
    }
  }

  void liveUpdateLocation() async {
    // driverslocationstream = Geolocator.getPositionStream().listen((position) async{
    //   currentposition = position ;

    //   await geoFirestore.setLocation(authinstance.currentUser!.uid, GeoPoint(currentposition!.latitude, currentposition!.longitude));

    //  });

    //realtimedatabse
    driverslocationstream = Geolocator.getPositionStream().listen((position) async {
      currentposition = position;
     Geofire.setLocation(authinstance.currentUser!.uid, currentposition!.latitude, currentposition!.longitude);
    });
  }

  void makeDriverOffline() async {

    //availabledriverrefference.doc(authinstance.currentUser!.uid).delete();
    //for realtimedatabse

    //_________________________________________________________________________
   // Geofire.initialize("availableDrivers");
    // await availablereference.child(authinstance.currentUser!.uid).remove();
    await availabledriverrefference.doc(authinstance.currentUser!.uid).delete();
    //_________________________________________________________________________

    // Geofire.removeLocation(authinstance.currentUser!.uid);
    //availablereference.onDisconnect();

    //await driverslocationstream!.cancel();

    isOnlineLoading(false);
    isOnline(false);
        print("make drive offline called");
  }



  

  
}
