import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/dialog/authdialog/authdialog.dart';
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
  var authxcontroller = Get.find<Authcontroller>();

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
              int.parse(prev.toString()) +
              int.parse(trip.payedamount.toString())));

      totalsuccestrip(listofsuccesstrip.length);
      canceledtrip(listofcanceledtrip.length);

      // print('mylist PRINTINg');
      // print(listofsuccesstrip.length);
      // print(listofcanceledtrip.length);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    driverslocationstream!.cancel();
    super.dispose();
  }

  void makeDriverOnline(BuildContext context) async {
    try {
      isOnlineLoading(true);
      Authdialog.showAuthProGress(context, 'Loading...');
      if (currentposition == null) {
        currentposition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        latcurrentposition =
            LatLng(currentposition!.latitude, currentposition!.longitude);
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
        print(e.message);
      }
      Get.back();
      isOnlineLoading(false);
      isOnline(true);
    } catch (e) {
      print(e);
      Get.back();
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
    driverslocationstream =
        Geolocator.getPositionStream().listen((position) async {
      currentposition = position;
      Geofire.setLocation(authinstance.currentUser!.uid,
          currentposition!.latitude, currentposition!.longitude);
    });
  }

  void makeDriverOffline(BuildContext context) async {
    Authdialog.showAuthProGress(context, 'Loading...');

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
      print("make drive offline called");
    });
  }

  void disableLiveLocationUpdate() async {
    Geofire.initialize("availableDrivers");
    driverslocationstream!.pause();
    Geofire.removeLocation(authinstance.currentUser!.uid);
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
    print('ratings listening');
    ratingsreferrence
        .doc(authinstance.currentUser!.uid)
        .collection('ratings')
        .snapshots()
        .listen((event) {
      listofRatings(event.docs.map((e) {
        var data = e.data() as Map<String, dynamic>;
        print(data);
        data['passenger_id'] = e.id;
        print(data);
        return Rating.fromJson(data);
      }).toList());

      print('_LENGHT OF RATINGS');
      print(listofRatings.length);
    });
  }


  void deleteAcceptedRequest(String requestid) async{
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
}
