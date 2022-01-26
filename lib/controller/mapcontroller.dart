import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geo_firestore_flutter/geo_firestore_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';

class Mapcontroller extends GetxController {
  var isOnline =false.obs;
  var isOnlineLoading = false.obs;
  Position? currentposition;
   GeoFirestore geoFirestore = GeoFirestore(firestore.collection('availableDrivers'));

  void makeDriverOnline () async{
    try{
      isOnlineLoading(true);
     currentposition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      // await geoFirestore.setLocation(authinstance.currentUser!.uid, GeoPoint(currentposition!.latitude, currentposition!.longitude));
      //for realtimedatabase
      Geofire.initialize("availableDrivers");
      Geofire.setLocation(authinstance.currentUser!.uid, currentposition!.latitude, currentposition!.longitude);
      
      availablereference.onValue.listen((event){

      });      


      isOnlineLoading(false);
      isOnline(true);
    }catch(e){
      print(e.toString());
      isOnlineLoading(false);
      isOnline(false);
    }
  }


  void liveUpdateLocation() async{

    

    // driverslocationstream = Geolocator.getPositionStream().listen((position) async{
    //   currentposition = position ;

    //   await geoFirestore.setLocation(authinstance.currentUser!.uid, GeoPoint(currentposition!.latitude, currentposition!.longitude));
    
    //  });


    //realtimedatabse
    driverslocationstream = Geolocator.getPositionStream().listen((position) {
      currentposition = position;
      Geofire.setLocation(authinstance.currentUser!.uid, currentposition!.latitude, currentposition!.longitude);
    });
  }

void makeDriverOffline() async{

      //availabledriverrefference.doc(authinstance.currentUser!.uid).delete();
    //for realtimedatabse
    await  availablereference.child(authinstance.currentUser!.uid).remove();
     // Geofire.removeLocation(authinstance.currentUser!.uid);
      availablereference.onDisconnect();
   
      driverslocationstream!.cancel();
      
    

      isOnlineLoading(false);
      isOnline(false);
  }
}