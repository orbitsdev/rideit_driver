import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';

class Drivercontroller  extends GetxController{


void disableLiveLocationUpdate() async {

     Geofire.initialize("availableDrivers");
    driverslocationstream!.pause();
    Geofire.removeLocation(authinstance.currentUser!.uid);

  }

  // void enableLibeLocationUpdate() async{ 
  //   var currentpositon =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   driverslocationstream!.resume();
  //   Geofire.setLocation(authinstance.currentUser!.uid, currentpositon.latitude, currentpositon.longitude);

  // }

  Future<bool> updateProfile(String imageurl) async{
  bool isupdate = false;
  
  try{

      await driversusers.doc(authinstance.currentUser!.uid).update({
    "profile_url": imageurl,
  }).then((value) => isupdate = true);


  }catch (e){
    isupdate = false;
  }

  return isupdate;
  }

}