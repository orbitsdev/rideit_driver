import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/config/firebaseconfig.dart';
import 'package:tricycleappdriver/config/mapconfig.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/pageindexcontroller.dart';
import 'package:tricycleappdriver/dialog/Failuredialog/failuredialog.dart';
import 'package:tricycleappdriver/dialog/authdialog/authdialog.dart';
import 'package:tricycleappdriver/dialog/collectionofdialog.dart';
import 'package:tricycleappdriver/dialog/infodialog/infodialog.dart';
import 'package:tricycleappdriver/dialog/toastdialog/toastdialog.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/model/directiondetails.dart';
import 'package:tricycleappdriver/model/ongoing_trip_details.dart';
import 'package:tricycleappdriver/model/request_details.dart';
import 'package:tricycleappdriver/screens/ongoingtrip.dart';
import 'package:tricycleappdriver/services/mapservices.dart';
import 'package:http/http.dart' as http;

class Requestdatacontroller extends GetxController {
  var driverxcontroller = Get.find<Drivercontroller>();
  var authxcontroller = Get.find<Authcontroller>();
  var pageindexcontroller = Get.find<Pageindexcontroller>();
  CameraPosition? cameraposition;

  var lisofunacceptedrequest = <RequestDetails>[].obs;

  var requestdetails = RequestDetails().obs;
  var monitorrequestdetails = RequestDetails().obs;
  var directiondetails = Directiondetails().obs;
  var ongoingtrip = OngoingTripDetails().obs;
  var ongoingtripmonitor = OngoingTripDetails().obs;
  String? acceptedrequest_id;

  var hasacceptedrequest = false.obs;
  var isDirectiionReady = false.obs;
  Position? currentpostion;
  void confirmRequest(BuildContext context, String? requestid) async {
    Get.off(()=>HomeScreenManager());
    Authdialog.showAuthProGress(context, 'Please wait...');
    if (requestid != null) {
      await requestcollecctionrefference
          .doc(requestid)
          .get()
          .then((documentsnapshot) async {
        if (documentsnapshot.data() != null) {
        
          //store to local after confirming
          requestdetails(RequestDetails.fromJson(documentsnapshot.data() as Map<String, dynamic>));
          requestdetails.value.request_id = requestid;

          //check request
          if (requestdetails.value.status == "pending") {
            currentpostion = driverxcontroller.currentposition;
            if (currentpostion == null) {
              currentpostion = await Geolocator.getCurrentPosition(
                  desiredAccuracy: LocationAccuracy.high);
            }
            Map<String, dynamic> currentlocation = {
              'latitude': currentpostion!.latitude,
              'longitude': currentpostion!.longitude,
            };

            //accept request with  driver information
            requestcollecctionrefference.doc(requestid).update({
              "status": "accepted",
              'request_id': requestid,
              'driver_id': authinstance.currentUser!.uid,
              'driver_name': authxcontroller.useracountdetails.value.name,
              'driver_phone': authxcontroller.useracountdetails.value.phone,
              'driver_image_url':  authxcontroller.useracountdetails.value.image_url,
              'driver_location': currentlocation,
              'payed': false,
              'read': false,
            }).then((_) async {

              /// Store requestid in driver database for handling data if the app close ,uninstall or if the user clear local data or cache
              /// This will be use to retrive data when the app installed or open again
              await drivercurrentrequestaccepted.doc(requestid).set({'status': 'accepted'}).then((_) async {
               
                hasacceptedrequest(true);
              
              /// Create trip and prepair direction
                var iscreated = await getDirectionAndCreateOngoingTrip(context, requestid);

                if (iscreated) {
                  await requestcollecctionrefference.doc(requestid).update({
                    'tripstatus': 'ready',
                  }).then((value) async {
                  
                  /// make driver offline
                    driverxcontroller.makeDriverOffline(context);

                  /// close loading screen

                   /// update page to trip para pag back mo malakat ka sa trip screen
                    pageindexcontroller.updateIndex(1);
                       Get.back();
                    Future.delayed(Duration(seconds: 1), () {
                      Get.off(() => Ongoingtrip());
                    });

                  });
                } else {
                  Get.back();
                  Infodialog.showInfo(context, 'Failed to create trip');
                  driverxcontroller.deleteAcceptedRequest(requestid);
                }
              });
            });
          } else {
            Get.back();

            infoDialog('Request already accepted by other driver');
          }
        } else {
          Get.back();
          infoDialog('Request Has been canceled');
        }
      });
    }
  }

  Future<bool> getDirectionAndCreateOngoingTrip(
    BuildContext context, String requestid) async {
    bool issucces = false;
    

    /// Get the updated data and store local 

    await requestcollecctionrefference
        .doc(requestid)
        .get()
        .then((snapshot) async {
      if (snapshot.data() != null) {
        
        requestdetails( RequestDetails.fromJson(snapshot.data() as Map<String, dynamic>));
        OngoingTripDetails  newongoingtripdetails =  OngoingTripDetails.fromJson(snapshot.data() as Map<String, dynamic>);
        
        /// get deriction details
        var isrouteready = await getDirection(
            context,
            newongoingtripdetails.pick_location_id as String,
            newongoingtripdetails.drop_location_id as String,
            newongoingtripdetails.actualmarker_position as LatLng);

          Map<String, dynamic> ongoingtripdata = newongoingtripdetails.toJson();
          ongoingtripdata['tripstatus'] = 'prepairing';
       

        /// is route ready it will retrun
        if (isrouteready) {
         
          var isOngoingTripCreated = await createOngoingTrip(ongoingtripdata);

        /// is created
          if (isOngoingTripCreated) {
            issucces = true;
          } else {
            issucces = false;
          }
        } else {
          issucces = false;
        }
      } else {
        Infodialog.showInfoToastCenter('No Ongoing tip');
        issucces = false;
      }
    });
    return issucces;
  }

  Future<bool> getDirection(BuildContext context, String pickuplocationid,
      String droplocationid, LatLng actularmarkerpostion) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:${pickuplocationid}&destination=${actularmarkerpostion.latitude},${actularmarkerpostion.longitude}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";
    //   String url =  "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:${pickuplocationid}&destination=place_id:${droplocationid}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";
    //  var url = "https://maps.googleapis.com/maps/api/directions/json?origin=place_id=${pickuplocationid}&destinaion=place_id:${droplocationid}&mode=waking&key=${Mapconfig.GOOGLEMAP_API_KEY}";

    try {
      var response = await Mapservices.mapRequest(url);

      if (response != 'failed') {
        var newdirectiondetails = Directiondetails.fromJason(response);
        directiondetails(newdirectiondetails);

        isDirectiionReady(true);

        return true;
      } else {
        Infodialog.showInfoToastCenter("faile to get direction");

        isDirectiionReady(false);
        return false;
      }
    } catch (e) {
      isDirectiionReady(false);
      print('DIRECT ERROR');
      Infodialog.showInfoToastCenter(e.toString());
      return false;
    }
  }

  Future<bool> createOngoingTrip(Map<String, dynamic> ongoingtripdata) async {
    bool iscreated = false;

      
    // print('Request id');
    // print(ongoingtripdata['request_id']);
    try {
      await requestcollecctionrefference.doc(ongoingtripdata['request_id']).collection('ongoingtrip').doc(ongoingtripdata['request_id']).set(ongoingtripdata).then((_){
       
         iscreated = true;
      });
  
    } catch (e) {
      Toastdialog.showInfoToastCenter(e.toString());
      iscreated = false;
    }

    return iscreated;
  }

  Future<bool> checkOngoingTripDetails(BuildContext context) async {
    if (ongoingtrip.value.drop_location_id != null) {
      return true;
    } else {
      //checkdatabase

      acceptedrequest_id = await getAcceptedRequestId();
      if (acceptedrequest_id != null) {
        try {
          await requestcollecctionrefference
              .doc(acceptedrequest_id).collection('ongoingtrip').doc(acceptedrequest_id)
              .get()
              .then((value) async {
                ongoingtrip(OngoingTripDetails.fromJson(
                value.data() as Map<String, dynamic>));

            //get direction again
            var response = await getDirection(
                context,
                ongoingtrip.value.pick_location_id as String,
                ongoingtrip.value.drop_location_id as String,
                ongoingtrip.value.actualmarker_position as LatLng);
            // getRouteDirection(requestid as String);
          });

          return true;
        } catch (e) {
          return false;
        }
      } else {
        return false;
      }
    }
  }

  Future<bool> changeRouteDirection(BuildContext context,
      LatLng startinglocation, LatLng endinglocation) async {
    // print(startinglocation);
    // print(endinglocation);
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startinglocation.latitude},${startinglocation.longitude}&destination=${endinglocation.latitude},${endinglocation.longitude}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";

    try {
      Authdialog.showAuthProGress(context, 'Changing Route');
      var response = await Mapservices.mapRequest(url);

      if (response != 'failed') {
        var newdirectiondetails = Directiondetails.fromJason(response);
        directiondetails(newdirectiondetails);
        print(directiondetails.value.polylines_encoded);
        Get.back();
        isDirectiionReady(true);

        return true;
      } else {
        Infodialog.showInfoToastCenter("failed to get direction");
        Get.back();
        isDirectiionReady(false);
        return false;
      }
    } catch (e) {
      print('_______________________');
      print(e);
      Infodialog.showInfoToastCenter(e.toString());
      isDirectiionReady(false);
      Get.back();
      return false;
    }
    //return true;
  }

  void deleteAcceptedRequest(String acceptedrequestid) async {
      await drivercurrentrequestaccepted
        .doc(acceptedrequestid)
        .delete()
        .then((value) {
            Infodialog.showToastCenter(Colors.red, ELSA_TEXT_WHITE,'Accepted request deleteted because no data found');
            clearLocalData();
        });
        
  }

  Future<String?> getAcceptedRequestId() async {
    String? requestid;

    var response = await drivercurrentrequestaccepted.get();

    if (response.docs.isNotEmpty) {
      final _docData = response.docs.map((doc) {
        requestid = doc.id;
        return doc.data();
      }).toList();
    } else {
      requestid = null;
    }

    return requestid;
  }

  var updating = false.obs;
  Future<String> updateTripStaus(BuildContext context) async {
    updating(true);
    String text;
    String status = ongoingtrip.value.tripstatus as String;

    if (status == "prepairing") {
      text = "coming";
    } else if (status == "coming") {
      text = "arrived";
    } else if (status == "arrived") {
      text = "travelling";
    } else if (status == "travelling") {
      text = "complete";
    } else {
      text = "check";
    }

    if (text != "check") {
      var response = await updateTripStatus(text);
      
      /// response use to interact with the screen

      if (response) {
        if (text == "coming") {

          if (driverxcontroller.latcurrentposition == null) {

            /// get current location to make sure it was accurate
            await driverxcontroller.getCurentDirection();

            /// change direction of polylines  to current location of driver to pickup location of passenger
            await changeRouteDirection(
                context,
                driverxcontroller.latcurrentposition as LatLng,
                ongoingtrip.value.pick_location as LatLng);
            updating(false);
          }
        } else if (text == "arrived") {

          /// send notification to passenger incase the app close or the app minimize the passenger get notified 
          
          sendNotification(
              ongoingtrip.value.device_token as String,
              'Driver is ready to pick up you\n. Your address is ${ongoingtrip.value.pickaddress_name}',
              'Driver has arrive',
              'ongoingtrip');

          /// stop updating driver location 
          
         await cancelDriverLiveLocation();
        } else if (text == "complete") {

          await cancelDriverLiveLocation();
        } else if (text == "travelling") {
          /// change direction to actual  request
          /// 
          await changeRouteDirection(
              context,
              ongoingtrip.value.pick_location as LatLng,
              ongoingtrip.value.actualmarker_position as LatLng);
              updating(false);
        }
      }
      updating(false);
      return text;
    } else {
      updating(false);
      return text;
    }
  }

  Future<bool> updateTripStatus(String value) async {
    try {
      await requestcollecctionrefference.doc(ongoingtrip.value.request_id).collection('ongoingtrip').doc(ongoingtrip.value.request_id).update({
        'tripstatus': value,
      }).then((_) {
        ///update local
        ongoingtrip.value.tripstatus = value as String;
        
      });

      return true;
    } catch (e) {
      Infodialog.showInfoToastCenter(e.toString());
      return false;
    }
  }

  var collecting = false.obs;
  void endTrip(String requestid, BuildContext context) async {
    collecting(true);

    Authdialog.showAuthProGress(context, 'Please wait...');

    await requestcollecctionrefference.doc(requestid).collection('ongoingtrip').doc(requestid).update({
      'payed': true,
    });

    ongoingtrip.value.payed = true;
    Map<String, dynamic> triphistorydata = ongoingtrip.value.toJson();
    
    /// save to driver
    await drivertriphistoryreferrence
        .doc(authinstance.currentUser!.uid)
        .collection('trips')
        .add(triphistorydata)
        .then((_) async {
          /// save to passenger
      await passengertriphistoryreferrence
          .doc(requestid)
          .collection('trips')
          .add(triphistorydata)
          .then((_) async {
            /// delete accepted request so that driver can accept request again
          await drivercurrentrequestaccepted
              .doc(requestid)
              .delete()
              .then((value) async {
            
                 collecting(false);
                 /// close progress dialog
                 Get.back();
                 await driverxcontroller.makeDriverOnline(context);
                  /// clear local data;
                 clearLocalData();
                 pageindexcontroller.updateIndex(0);

                Future.delayed(Duration(milliseconds: 300), () {
                 Get.offNamedUntil(HomeScreenManager.screenName, (route) => false);
              //Get.offNamed(HomeScreenManager.screenName);
            });
          });
        
      });
    });
  }

  var cancelling = false.obs;
  void cancelOngoingTrip(String requestid, BuildContext context) async {
    
    ///incase you are travelling  stop driver update first
    await cancelDriverLiveLocation();
    collecting(true);
    
    Authdialog.showAuthProGress(context, 'Please wait...');
    await requestcollecctionrefference.doc(requestid).collection('ongoingtrip').doc(requestid).update({'fee': 0, 'payed': true, 'tripstatus': 'canceled'});
    

    /// upodate field before recording
    ongoingtrip.value.payed = true;
    ongoingtrip.value.fee = 0;
    ongoingtrip.value.tripstatus = 'canceled';
    
    Map<String, dynamic> triphistorydata = ongoingtrip.value.toJson();
    
    /// save to driver 
    await drivertriphistoryreferrence
        .doc(authinstance.currentUser!.uid)
        .collection('trips')
        .add(triphistorydata)
        .then((_) async {

     /// save to passenger 
      await passengertriphistoryreferrence
          .doc(requestid)
          .collection('trips')
          .add(triphistorydata)
          .then((_) async {

          /// delete accepted request so that the driver cana accept request again
          await drivercurrentrequestaccepted
              .doc(requestid)
              .delete()
              .then((value) async {
                
            collecting(false);
            Get.back();
            await driverxcontroller.makeDriverOnline(context);

            //clear local data
            clearLocalData();

            pageindexcontroller.updateIndex(0);

            Future.delayed(Duration(milliseconds: 300), () {
              Get.offNamedUntil(HomeScreenManager.screenName, (route) => false);
              
            });
          });
       
      });
    });
  }

  void updateDriverTripPosition(LatLng position, String requestid) async {
    Map<String, dynamic> newdriverlocation = {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };

    await requestcollecctionrefference
        .doc(requestid).collection('ongoingtrip').doc(requestid)
        .update({'driver_location': newdriverlocation});
  }

  Future<void> cancelDriverLiveLocation()  async{
    print('cancel live');
    if (driverlocationstream != null) {
      driverlocationstream!.cancel();
    }
  }

  void sendNotification(
      String token, String title, String body, String screenname) async {
    var serverKey = Firebaseconfig.CLOUD_MESSAGING_SERVEY_KEY;

    Map<String, String> headerData = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    Map<String, dynamic> notificationData = {
      'body': title,
      'title': body,
    };

    Map<String, dynamic> passData = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      "id": 1,
      "status": "done",
      "screenname": screenname,
    };

    Map<String, dynamic> sendPushNotification = {
      "notification": notificationData,
      "data": passData,
      "priority": "high",
      //"registration_ids":token ,
      "to": token,
    };

    try {
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: headerData,
        body: jsonEncode(sendPushNotification),
      );
    } catch (e) {
      Infodialog.showInfoToast(e.toString());
    }
  }

  void checkIfHasOngingTrp() async {
    if (ongoingtrip.value.drop_location_id == null) {}
  }

  String? requestid;
  Future<bool> checkIfHasOngoingRequest() async {
    bool hastrip = false;

    //check database
    try {
      await drivercurrentrequestaccepted.get().then((value) async {
        if (value.docs.isNotEmpty) {
          value.docs.forEach((element) {
            requestid = element.id;
          });

          hastrip = true;
        } else {
          hastrip = false;
        }
      });
    } catch (e) {
      hastrip = false;
    }

    return hastrip;
  }

  Future<bool> getRequestData(BuildContext context) async {
    bool ready = false;

    try {
      await requestcollecctionrefference.doc(requestid).get().then((value) {
        if (value.exists) {
          requestdetails(
              RequestDetails.fromJson(value.data() as Map<String, dynamic>));
          requestdetails.value.request_id = requestid;
          ready = true;
        } else {
          ready = false;
          if(requestid !=  null){
            driverxcontroller.deleteAcceptedRequest(requestid as String);

          }
        }
      });
    } on SocketException {
      Failuredialog.showInternetConnectionInfoDialog(
          context, 'Ops', 'NO Enternet Connecttion');
      ready = false;
    } on HttpException catch (e) {
      print('a');
      Failuredialog.showErrorDialog(context, 'Ops', e.toString());
      ready = false;
    } on FormatException catch (e) {
      print('b');
      Failuredialog.showErrorDialog(context, 'Ops', e.toString());
      ready = false;
    }
    return ready;
  }

  void listenToOngoingRequest() async {
    getAccepteRequetId();
  }

  Future<String?> getAccepteRequetId() async {
    await drivercurrentrequestaccepted.get().then((value) {
      if (value.docs.length > 0) {
        value.docs.forEach((element) {
          requestid = element.id;
        });
      }
    });
    print('____________________________');
    print(requestid);
    print('_________');

    if (requestid != null) {
      await ongointripreferrence.doc(requestid).get().then((value) {
        if (value.exists) {
          ongoingtrip(OngoingTripDetails.fromJson(
              value.data() as Map<String, dynamic>));
          print(ongoingtrip.toJson());
        }
      });
    }
  }
  
  String? acceptedrequestid;
  void monitorOngingTrip() async {
    if (ongoingtrip.value.drop_location_id == null) {
      await drivercurrentrequestaccepted.get().then((value) {
        if (value.docs.length > 0) {
          value.docs.forEach((element) {
            acceptedrequest_id = element.id;
          });
        }
      });

      if (acceptedrequest_id != null) {
        await requestcollecctionrefference
            .doc(acceptedrequest_id)
            .snapshots()
            .listen((event) {
          if (event.exists) {
            monitorrequestdetails(
                RequestDetails.fromJson(event.data() as Map<String, dynamic>));
            print(monitorrequestdetails.toJson());
          } else {
            deleteAcceptedRequest(acceptedrequest_id as String);
          }
        });
      } else {

      }
    }
  }


  void monitorunacceptedrequest() async {
      
      if(ongoingtrip.value.driver_id == null){
        await drivercurrentrequestaccepted.get().then((value){
          if(value.docs.length > 0){
              value.docs.forEach((element) { 
                acceptedrequest_id  = element.id;
              });
            
          }else{
          
            acceptedrequest_id = null;
          /// clear local data to make sure no data is save
            clearLocalData();
          }
        });

        if(acceptedrequest_id != null){
             requestcollecctionrefference.doc(acceptedrequest_id).snapshots().listen((event) { 
                  if(event.exists){
                    monitorrequestdetails(RequestDetails.fromJson(event.data() as Map<String, dynamic>));
                   hasacceptedrequest(true);
                  }else{
                    if(acceptedrequest_id != null){

                    deleteAcceptedRequest(acceptedrequest_id as String);
                    hasacceptedrequest(false);
                    }
                  }
            });
        }else{
          
          clearLocalData();
        }

      }else{
          requestcollecctionrefference.doc(ongoingtrip.value.request_id).snapshots().listen((event) { 
                  if(event.exists){
                   
                   hasacceptedrequest(true);
                  }else{
                    if(ongoingtrip.value.request_id != null){
                    deleteAcceptedRequest(ongoingtrip.value.request_id as String);
                    hasacceptedrequest(false);
                    }
                  }
            });
      }
      print('______________');
      print(hasacceptedrequest);
  }

 void clearLocalData(){
     hasacceptedrequest(false);
     directiondetails = Directiondetails().obs;
     requestdetails = RequestDetails().obs;
     monitorrequestdetails = RequestDetails().obs;
     ongoingtrip = OngoingTripDetails().obs;
     ongoingtripmonitor = OngoingTripDetails().obs;
 }
}
