import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/model/ongoing_trip_details.dart';

class Drivercontroller  extends GetxController{


  var isOnline = false.obs;
  var isOnlineLoading = false.obs;
  var isonlinelastime = false.obs;
  LatLng?  latcurrentposition;
  Position? currentposition;
  var listofsuccesstrip = <OngoingTripDetails>[].obs;
  var listofcanceledtrip = <OngoingTripDetails>[].obs;
  var lisoftriprecord = <OngoingTripDetails>[].obs;
  var totalsuccestrip = 0.obs;
  var canceledtrip = 0.obs;
  var totalearning = 0.obs;
  
  var authxcontroller = Get.find<Authcontroller>();
  //GeoFirestore geoFirestore =GeoFirestore(firestore.collection('availableDrivers'));
  
  
  
void listenToAllTrip() async{
  drivertriphistoryreferrence.doc(authinstance.currentUser!.uid).collection('trips').snapshots().listen((event) {
listofsuccesstrip.clear();
listofcanceledtrip.clear();
    event.docs.forEach((element) { 

        var data =  element.data() as  Map<String, dynamic>;

          lisoftriprecord.add(OngoingTripDetails.fromJson(data));
        if(data['tripstatus']=="complete"){
          listofsuccesstrip.add(OngoingTripDetails.fromJson(data));
        }
        if(data['tripstatus']=="canceled"){
            listofcanceledtrip.add(OngoingTripDetails.fromJson(data));
        }
     

    });
      totalearning(listofsuccesstrip.fold(0, (prev, trip) =>  int.parse(prev.toString()) +  int.parse(trip.payedamount.toString())));
     
     totalsuccestrip(listofsuccesstrip.length) ;
     canceledtrip(listofcanceledtrip.length) ;


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
            latcurrentposition =  LatLng(currentposition!.latitude , currentposition!.longitude);
            print('called');

          }
          
          try{
           

        Map<String, dynamic> driverpostion = {
          'latitude': currentposition!.latitude,
          'longitude': currentposition!.longitude,
        };

        await availabledriverrefference.doc(authinstance.currentUser!.uid).set(
        {
        "driver_location":driverpostion ,
         "device_token": authxcontroller.useracountdetails.value.device_token, 
         "status": "online"
         },
         SetOptions(merge: true),
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
    await availabledriverrefference.doc(authinstance.currentUser!.uid).update({
      "status": "offline",
    });
    //_________________________________________________________________________

    // Geofire.removeLocation(authinstance.currentUser!.uid);
    //availablereference.onDisconnect();

    //await driverslocationstream!.cancel();

    isOnlineLoading(false);
    isOnline(false);
        print("make drive offline called");
  }




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
    "image_url": imageurl,
  }).then((value) => isupdate = true);


  }catch (e){
    isupdate = false;
  }

  return isupdate;
  }





}