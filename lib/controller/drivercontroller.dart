import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/requestdatacontroller.dart';
import 'package:tricycleappdriver/dialog/authdialog/authdialog.dart';
import 'package:tricycleappdriver/dialog/infodialog/infodialog.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/model/ongoing_trip_details.dart';
import 'package:tricycleappdriver/model/rating.dart';
import 'package:tricycleappdriver/model/users.dart';

class Drivercontroller extends GetxController {
  var isOnline = false.obs;
  var isOnlineLoading = false.obs;
  var isonlinelastime = false.obs;
  LatLng? latcurrentposition;
  Position? currentposition;
  var listofsuccesstrip = <OngoingTripDetails>[].obs;
  var listofcanceledtrip = <OngoingTripDetails>[].obs;
  var lisoftriprecord = <OngoingTripDetails>[].obs;
  var totalsuccestrip = 0.obs;
  var canceledtrip = 0.obs;
  var totalearning = 0.obs;
  var authxcontroller = Get.put(Authcontroller());
  var listofRatings = <Rating>[].obs;
  
 

  //GeoFirestore geoFirestore =GeoFirestore(firestore.collection('availableDrivers'));

  void listenToAllTrip() async {
    drivertriphistoryreferrence
        .doc(authinstance.currentUser!.uid)
        .collection('trips')
        .snapshots()
        .listen((event) {
      listofsuccesstrip.clear();
      listofcanceledtrip.clear();
      event.docs.forEach((element) {
        var data = element.data() as Map<String, dynamic>;

        lisoftriprecord.add(OngoingTripDetails.fromJson(data));
        if (data['tripstatus'] == "complete") {
          listofsuccesstrip.add(OngoingTripDetails.fromJson(data));
        }
        if (data['tripstatus'] == "canceled") {
          listofcanceledtrip.add(OngoingTripDetails.fromJson(data));
        }
      });
      totalearning(listofsuccesstrip.fold(
          0,
          (prev, trip) =>
              int.parse(prev.toString()) + int.parse(trip.fee.toString())));

      totalsuccestrip(listofsuccesstrip.length);
      canceledtrip(listofcanceledtrip.length);

    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    driverslocationstream!.cancel();
    super.dispose();
  }

  Future<void> makeDriverOnline(BuildContext context) async {
    try {
      isOnlineLoading(true);
      Authdialog.showAuthProGress('Loading...');
      if (currentposition == null) {
        await getCurentDirection();
      }

      try {
        Map<String, dynamic> driverpostion = {
          'latitude': currentposition!.latitude,
          'longitude': currentposition!.longitude,
        };
        String token = await messaginginstance.getToken() as String;
        await availabledriverrefference.doc(authinstance.currentUser!.uid).set(
          {
            "driver_location": driverpostion,
            "device_token": token,
            "status": "online"
          },
          SetOptions(merge: true),
        ).then((value) {
          Get.back();
          Fluttertoast.showToast(
              msg: "You are Online",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: ELSA_GREEN,
              fontSize: 16.0);
        });
      } on PlatformException catch (e) {
        Infodialog.showInfoToastCenter(e.toString());
      }
      Get.back();
      isOnlineLoading(false);
      isOnline(true);
    } catch (e) {
     Infodialog.showInfoToastCenter(e.toString());
      Get.back();
      isOnlineLoading(false);
      //     isOnline(false);
    }
  }

 

  Future<void> makeDriverOffline(BuildContext context) async {
    Authdialog.showAuthProGress( 'Loading...');

    await availabledriverrefference.doc(authinstance.currentUser!.uid).update({
      "status": "offline",
    }).then((value) {
      Get.back();
      Fluttertoast.showToast(
          msg: "You are Offline",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.redAccent,
          fontSize: 16.0);
      isOnlineLoading(false);
      isOnline(false);
    });
  }

  

  Future<bool> updateProfile(String imageurl) async {
    bool isupdate = false;

    try {
      await driversusers.doc(authinstance.currentUser!.uid).update({
        "image_url": imageurl,
      }).then((value) => isupdate = true);
    } catch (e) {
      isupdate = false;
    }

    return isupdate;
  }

  var isupdatingloading = false.obs;
  updateProfileDetails(String name, String email) async {
    isupdatingloading(true);
    try {
      await driversusers
          .doc(authinstance.currentUser!.uid)
          .update({'name': name, 'phone': email.trim()}).then((_) async {
        isupdatingloading(false);
        Fluttertoast.showToast(
            msg: "Update success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: ELSA_GREEN,
            fontSize: 16.0);
        Get.back();
      });
    } catch (e) {
      isupdatingloading(false);
    }
  }

  void listenToAcountUser() async {
    driversusers.doc(authinstance.currentUser!.uid).snapshots().listen((event) {
      var data = event.data() as Map<String, dynamic>;

      authxcontroller.useracountdetails(Users.fromJson(data));
    });
  }

  void listenToRatings() async {
    ratingsreferrence
        .doc(authinstance.currentUser!.uid)
        .collection('ratings')
        .snapshots()
        .listen((event) {
          listofRatings.clear();
         if(event.docs.length > 0){
            listofRatings(event.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        data['passenger_id'] = e.id;
        return Rating.fromJson(data);
      }).toList());
         }else{
           listofRatings.clear();
         } 
       

    });
  }

  void deleteAcceptedRequest(String requestid) async {
    await drivercurrentrequestaccepted.doc(requestid).delete().then((value) {

      Fluttertoast.showToast(
          msg: "Has accepted request but request found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.grey[400],
          fontSize: 16.0);
          
    });
    
  }

  Future<void> getCurentDirection() async {
    try {
      
      currentposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latcurrentposition =
          LatLng(currentposition!.latitude, currentposition!.longitude);
    } catch (e) {
      Infodialog.showInfoToastCenter(e.toString());
    }
  }
}
