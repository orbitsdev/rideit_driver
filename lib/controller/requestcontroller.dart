import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart';
import 'package:tricycleappdriver/config/firebaseconfig.dart';
import 'package:tricycleappdriver/config/mapconfig.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/mapcontroller.dart';
import 'package:tricycleappdriver/controller/pageindexcontroller.dart';
import 'package:tricycleappdriver/dialog/Failuredialog/failuredialog.dart';
import 'package:tricycleappdriver/dialog/authdialog/authdialog.dart';
import 'package:tricycleappdriver/dialog/authdialog/authenticating.dart';
import 'package:tricycleappdriver/dialog/collectionofdialog.dart';
import 'package:tricycleappdriver/dialog/infodialog/infodialog.dart';
import 'package:tricycleappdriver/dialog/requestdialog/completetripdialog.dart';
import 'package:tricycleappdriver/dialog/toastdialog/toastdialog.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/model/directiondetails.dart';
import 'package:tricycleappdriver/model/ongoing_trip_details.dart';
import 'package:tricycleappdriver/model/request_details.dart';
import 'package:tricycleappdriver/model/un_accepted_request.dart';
import 'package:tricycleappdriver/screens/ongoingtrip.dart';
import 'package:tricycleappdriver/screens/trips_screen.dart';
import 'package:tricycleappdriver/services/mapservices.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../assistant/debub_assistant.dart';

class Requestcontroller extends GetxController {
  var authxcontroller = Get.find<Authcontroller>();
  var driverxcontroller = Get.find<Drivercontroller>();
  var mapxcontroller = Get.find<Mapcontroller>();

  var requestdetails = RequestDetails().obs;
  var ongoingtrip = OngoingTripDetails().obs;
  var monitorongoingtrip = OngoingTripDetails().obs;
  var directiondetails = Directiondetails().obs;
  var livedirectiondetails = Directiondetails().obs;
  var pageindexcontroller = Get.find<Pageindexcontroller>();
  var isDirectiionReady = false.obs;
  var collecting = false.obs;
  var testpositiono = "".obs;
  var buttontext = "";
  var tripTextIsloading = false.obs;
  var hasongingtrip = false.obs;

  var isPaymentShowed = false.obs;

  var lisofunacceptedrequest = <RequestDetails>[].obs;
  var lengthofunacceptedrequest = 0.obs;
  Position? currentpostion;

  String? newtripstatusvalue;

  var loaderoftrip = false.obs;
  Map<String, dynamic> ongoingtripdata = {};

  //
  var hasacceptedrequest = false.obs;
  String? requestid;
  void confirmRequest(BuildContext context, String? requestid) async {
    hasacceptedrequest(true);
   // Authdialog.showAuthProGress(context, 'Please wait...');
    if (requestid != null) {
      await requestcollecctionrefference
          .doc(requestid)
          .get()
          .then((documentsnapshot) async {
        if (documentsnapshot.data() != null) {
          // get request details  ;
          RequestDetails getrequestdetails = RequestDetails.fromJson(
              documentsnapshot.data() as Map<String, dynamic>);

          //store to local after confirming

          requestdetails(getrequestdetails);
          requestdetails.value.request_id = requestid;

          //check request
          if (getrequestdetails.status == "pending") {
            //get current location
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
              'driver_image_url': authxcontroller.useracountdetails.value.image_url,
              'driver_location': currentlocation,
              'payed': false,
              'read': false,
            }).then((_) async {
              // store requestid in driver for ongoinng trip screen used only
              await drivercurrentrequestaccepted
                  .doc(requestid)
                  .set({'status': 'accepted'}).then((_) async {
//Get.back();
                // close lisscreen
                //Get.back();

                //get direction and ongoingtripdetails local
               // Authdialog.showAuthProGress(context, 'Prepairing trip ...');

                //hand this make sure to delete i
                  var iscreatd  =  await  getDirectionAndCreateOngoingTrip(requestid);
                  if(iscreatd){
                     await requestcollecctionrefference.doc(requestid).update({
                    'tripstatus': 'ready',
                  }).then((value) async {
                    //make driver offline
//Get.back();
                  driverxcontroller.makeDriverOffline(context);

                    //close loading screen

                    //update page to trip para pag back mo malakat ka sa trip screen
                    pageindexcontroller.updateIndex(1);

                    //after 300 milliseconds lakat ka sa ongoing trip screen

                    Future.delayed(Duration(milliseconds: 300), () {
                      //then store data in local na may ongoing trip ka
                      hasongingtrip(true);
                      Get.offNamed(Ongoingtrip.screenName,
                          arguments: {"from": "request"});
                    });
                  });
                  }else{
                    //Get.back();
                    Infodialog.showInfo(context, 'Failed to create trip');
                    driverxcontroller.deleteAcceptedRequest(requestid);
                  }
                 
                
              });
            });
          } else {

            hasacceptedrequest(false);
           // Get.back();
          
            infoDialog('Request already accepted by other driver');
          }
        } else {
          hasacceptedrequest(false);
         // Get.back();
          infoDialog('Request Has been canceled');
        }
      });
    }
  }

  Future<void> launchMapsUrl(String originPlaceId, String destionationplaceid,
      LatLng destinationposition) async {
    
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${destinationposition.latitude},${destinationposition.longitude}&dir_action=navigate}';
    // // print('${tripdetails.value.actualmarkerposition!.latitude},${tripdetails.value.actualmarkerposition!.longitude}');
    //   String googleUrl = 'https://www.google.com/maps/search/?api=1&origin=${originPlaceId}&origin_place_id=${originPlaceId}&destination_place_id=${destionationplaceid}&destination=${destionationplaceid}&dir_action=navigate';
    // String googleUrl = 'https://www.google.com/maps/search/?api=1&origin_place_id=${originPlaceId}&destination=${destinationposition.latitude},${destinationposition.longitude}&travelmode=driving&dir_action=navigate';
    if (await canLaunch(googleUrl) != null) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }

    // static Future<void> openMap(double latitude,double longitude) async {

    // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    // if(await canLaunch(googleUrl) != null) {
    //   await launch(googleUrl);
    // } else {
    //   throw 'Could not open the map.';
    // }
  }

  Future<bool> getDirectionAndCreateOngoingTrip(String requestid) async {
    bool issucces = false;
    OngoingTripDetails ongoingtripdetails = OngoingTripDetails();

    await requestcollecctionrefference
        .doc(requestid)
        .get()
        .then((snapshot) async {
      //check it has ongoing trip data
      if (snapshot.data() != null) {
   
        //update local request data to latest
        requestdetails( RequestDetails.fromJson(snapshot.data() as Map<String, dynamic>));
       
        //prepaire ongring trip data
        ongoingtripdetails = OngoingTripDetails.fromJson( snapshot.data() as Map<String, dynamic>);
        ongoingtripdata = ongoingtripdetails.toJson();
        ongoingtripdata['tripstatus'] = 'prepairing';

        //get deriction details
        var isrouteready = await getDirection(
            ongoingtripdetails.pick_location_id as String,
            ongoingtripdetails.drop_location_id as String,
            ongoingtripdetails.actualmarker_position as LatLng);
        //is route ready
        if (isrouteready) {
          //store converted data to ongoingtrip database
          var isOngoingTripCreated = await createOngoingTrip(ongoingtripdata);

          //is created
          if (isOngoingTripCreated) {
            issucces  =true;
          } else {
            issucces  =false;
          }
        } else {
          
          issucces  =false;
        }
      } else {
       // Infodialog.showInfoToastCenter('No Ongoing tip');
        issucces  =false;
      }
    });
    return issucces;
  }

  Future<bool> getDirection(String pickuplocationid, String droplocationid,
      LatLng actularmarkerpostion) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:${pickuplocationid}&destination=${actularmarkerpostion.latitude},${actularmarkerpostion.longitude}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";
    //   String url =  "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:${pickuplocationid}&destination=place_id:${droplocationid}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";
    //  var url = "https://maps.googleapis.com/maps/api/directions/json?origin=place_id=${pickuplocationid}&destinaion=place_id:${droplocationid}&mode=waking&key=${Mapconfig.GOOGLEMAP_API_KEY}";

    try {
      var response = await Mapservices.mapRequest(url);

      if (response != 'failed') {
        var newdirectiondetails = Directiondetails.fromJason(response);
        directiondetails(newdirectiondetails);
        livedirectiondetails(newdirectiondetails);
        isDirectiionReady(true);
        return true;
      } else {
        isDirectiionReady(false);
        return false;
      }
    } catch (e) {
      isDirectiionReady(false);
      print('DRIECTIO FGAIE');
     Infodialog.showInfoToastCenter(e.toString());
      return false;
    }
  }

  Future<bool> createOngoingTrip(Map<String, dynamic> ongoingtripdata) async {
    bool iscreated = false;
    try {
      await ongointripreferrence
          .doc(ongoingtripdata['request_id'])
          .set(ongoingtripdata)
          .then((_) async {
        iscreated =  true;
      });
    } catch (e) {
      Toastdialog.showInfoToastCenter(e.toString());
      iscreated= false;
      
    }

    return iscreated;

  }

  void updateDriverTripPosition(LatLng position, String requestid) async {
    Map<String, dynamic> newdriverlocation = {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };

    await ongointripreferrence
        .doc(requestid)
        .update({'driver_location': newdriverlocation});
  }

  void getNewTripDirection( BuildContext context,LatLng startingposition, LatLng finaldestionation) async {

      print('_____________________________________________');
      print('origin latlng');
      print(startingposition);
      print('end latling');
      print(finaldestionation);
      print('__________________________________________');
      print('____________________________________________');
    
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startingposition.latitude},${startingposition.longitude}&destination=${finaldestionation.latitude},${finaldestionation.longitude}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";


    try {
          Authdialog.showAuthProGress(context, 'Getting direction');
      var response = await Mapservices.mapRequest(url);

      if (response != 'failed') {
        Directiondetails newdliveirectiondetails =Directiondetails.fromJason(response);
        directiondetails(newdliveirectiondetails);
        
          Infodialog.showInfoToastCenter('success');
        //testpositiono = drivercurrentpostion.latitude.toString();
        Get.back();
      }
    } catch (e) {
      print('GET NEW DIRECTn');
        Infodialog.showInfoToastCenter(e.toString());
          Get.back();
    }
  }
  void getNewTripDirectionforLive(LatLng startingposition, LatLng finaldestionation) async {

      
    String url = "https://maps.googleapis.com/maps/api/directions/json?origin=${startingposition.latitude},${startingposition.longitude}&destination=${finaldestionation.latitude},${finaldestionation.longitude}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";


    try {
      
      var response = await Mapservices.mapRequest(url);

      if (response != 'failed') {
        Directiondetails newdliveirectiondetails = Directiondetails.fromJason(response);
        livedirectiondetails(newdliveirectiondetails);
      }
    } catch (e) {
         
    }
  }

  var updateLoad = false.obs;

  Future<String> updateOngoingTripStatus(BuildContext context) async {
    
    bool isChange = false;
    tripTextIsloading(true);
    String? tripstatus;

    // to make sur

    if (ongoingtrip.value.tripstatus == "prepairing") {
      newtripstatusvalue = "coming";
    } else if (ongoingtrip.value.tripstatus == "coming") {
      newtripstatusvalue = "arrived";
    } else if (ongoingtrip.value.tripstatus == "arrived") {
      newtripstatusvalue = "travelling";
    } else if (ongoingtrip.value.tripstatus == "travelling") {
      newtripstatusvalue = "complete";
    } else if (ongoingtrip.value.tripstatus == "complete") {
      newtripstatusvalue = "check";
    }

    if (newtripstatusvalue != "check") {
      isChange = await updateTripStatusAndChangeDirectionDetails( newtripstatusvalue as String);
      if (isChange) {
        //check updated  local tripstatus details
        if (ongoingtrip.value.tripstatus == "coming") {
          //from driver current location to pickup location
          getNewTripDirection(context, driverxcontroller.latcurrentposition as LatLng,
              ongoingtrip.value.pick_location as LatLng);
        } else if (ongoingtrip.value.tripstatus == "arrived") {
          sendNotification(
              ongoingtrip.value.device_token as String,
              'Drivers is waiting to your pickup location',
              'Your Diver updaterrived',
              'ongoingtrip');

          //stop updating driver location
          cancelDriverLiveLocation();
        } else if (ongoingtrip.value.tripstatus == "travelling") {
          //from pickup location to dropofflocation
          getNewTripDirection(context, ongoingtrip.value.pick_location as LatLng,
              ongoingtrip.value.drop_location as LatLng);
        } else if (ongoingtrip.value.tripstatus == "complete") {
          cancelDriverLiveLocation();
        }

        //return update tripstaus

        tripstatus = ongoingtrip.value.tripstatus;
      } else {
        tripstatus = ongoingtrip.value.tripstatus;
      }
      //check if succefull update

    } else {
  

      tripstatus = ongoingtrip.value.tripstatus;
      //same tripstatus
    }

    tripTextIsloading(false);

    return tripstatus as String;
  }
 void getCurrentPostion(BuildContext context) async{
    Authdialog.showAuthProGress(context, 'getting current location');
   Position position = await Geolocator.getCurrentPosition( desiredAccuracy: LocationAccuracy.high);
        driverxcontroller.latcurrentposition =LatLng(position.latitude, position.longitude);
         getNewTripDirection(context, driverxcontroller.latcurrentposition as LatLng ,  ongoingtrip.value.pick_location as LatLng);
    Get.back();
    
}
  Future<bool> updateTripStatusValue(String value) async{
      bool succes = false;
       
      try{
          await ongointripreferrence.doc(ongoingtrip.value.request_id).update({
            'tripstatus': value,
          }).then((value) {
            ongoingtrip.value.tripstatus = value as String;
          });
        return true;
      }catch(e){
        return false;
      }
  }

  
  

  void cancelDriverLiveLocation() {
    if (driverlocationstream != null) {
      driverlocationstream!.cancel();
    }
  }

  Future<bool> updateTripStatusAndChangeDirectionDetails(
    String tripstaus_new_value) async {
    bool isUpdated = false;
    try {
      await ongointripreferrence.doc(ongoingtrip.value.request_id).update({
        "tripstatus": tripstaus_new_value,
      }).then((_) async {
        //update local details
        ongoingtrip.value.tripstatus = tripstaus_new_value;
        isUpdated = true;
      });
    } catch (e) {
      isUpdated = false;
    }

    return isUpdated;
  }

  

  Future<bool> updatePolylines(LatLng from, LatLng to) async {
    bool isReady = false;
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";

    try {
      var response = await Mapservices.mapRequest(url);

      if (response != 'failed') {
        Directiondetails updatedirectiondetails =
            Directiondetails.fromJason(response);

        directiondetails(updatedirectiondetails);
        isReady = true;
       
      }
    } catch (e) {
      isReady = true;
     
    }

    return isReady;
  }

  void endTrip(String requestid, BuildContext context) async {
    hasacceptedrequest(false);
    collecting(true);

    Authdialog.showAuthProGress(context, 'Please wait...');
    //temporary value
    await ongointripreferrence.doc(requestid).update({
      'payed': true,
    });

//update variable local to be safe
    
    ongoingtrip.value.payed = true;
    Map<String, dynamic> triphistorydata = ongoingtrip.value.toJson();


    await drivertriphistoryreferrence
        .doc(authinstance.currentUser!.uid)
        .collection('trips')
        .add(triphistorydata)
        .then((_) async {
      //add to passenger
      await passengertriphistoryreferrence
          .doc(requestid)
          .collection('trips')
          .add(triphistorydata)
          .then((_) async {
        await requestcollecctionrefference
            .doc(requestid)
            .delete()
            .then((value) async {
          await drivercurrentrequestaccepted
              .doc(requestid)
              .delete()
              .then((value) async {
            collecting(false);
            Get.back();
            driverxcontroller.makeDriverOnline(context);
            cancelDriverLiveLocation();

            ongoingtrip = OngoingTripDetails().obs;
            directiondetails = Directiondetails().obs;
            livedirectiondetails = Directiondetails().obs;
            requestdetails = RequestDetails().obs;
            pageindexcontroller.updateIndex(1);
            newtripstatusvalue = null;
          
            // driverxcontroller.enableLibeLocationUpdate();
            hasongingtrip(false);

            Future.delayed(Duration(milliseconds: 300), () {
              Get.offNamedUntil(HomeScreenManager.screenName, (route) => false);
              //Get.offNamed(HomeScreenManager.screenName);
            });
          });
        });
      });
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

void monitorOngoingTrip() async{
        ongointripreferrence.doc(ongoingtrip.value.request_id).snapshots().listen((event) { 
          monitorongoingtrip(OngoingTripDetails.fromJson(event.data() as Map<String, dynamic>));
          print('Yowss__________');
          print('Yowss____________');
          print('Yowss______________');
          print(monitorongoingtrip.toJson());
        });
}


  Future<bool> getOngoingtripdetails() async {
    bool? isTripReady;
    String? requestid;

    if (ongoingtrip.value.request_id == null) { 


      //check database if request null
      requestid = await getAcceptedRequestId();
      await ongointripreferrence.doc(requestid).get().then((value) async {
         ongoingtrip(OngoingTripDetails.fromJson(value.data() as Map<String, dynamic>));
       
      //get direction again
        await getDirection(
            ongoingtrip.value.pick_location_id as String,
            ongoingtrip.value.drop_location_id as String,
            ongoingtrip.value.actualmarker_position as LatLng);
        // getRouteDirection(requestid as String);
      });

      isTripReady = true;
    } else {
      isTripReady = true;
    }

    return isTripReady;
  }

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
          requestdetails(RequestDetails.fromJson(value.data() as Map<String, dynamic>));
          requestdetails.value.request_id = requestid;
          ready = true;
          
        }else{
           ready = false;
           driverxcontroller.deleteAcceptedRequest(requestid as String);
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

  void cancelOngoingTrip(BuildContext context) async {
  
    
    Authdialog.showAuthProGress(context, 'Please wait...');

    try {
      await ongointripreferrence.doc(requestid).update({
        'fee': 0,
        'tripstatus': 'canceled',
        'payed': true,
      });
    } catch (e) {
      
      
           Infodialog.showInfoToast(e.toString());

    }

//update variable local to be safe
    ongoingtrip.value.tripstatus = 'canceled';
    ongoingtrip.value.payed = true;
    Map<String, dynamic> triphistorydata = ongoingtrip.value.toJson();

    await drivertriphistoryreferrence
        .doc(authinstance.currentUser!.uid)
        .collection('trips')
        .add(triphistorydata)
        .then((_) async {
      //add to passenger
    
      await passengertriphistoryreferrence
          .doc(requestid)
          .collection('trips')
          .add(triphistorydata)
          .then((_) async {
                 
        await requestcollecctionrefference
            .doc(requestid)
            .delete()
            .then((_) async {
          await drivercurrentrequestaccepted
              .doc(requestid)
              .delete()
              .then((value) async {

              await ongointripreferrence.doc(requestid).delete().then((value) async{
                      collecting(false);
            Get.back();
            driverxcontroller.makeDriverOnline(context);
            cancelDriverLiveLocation();

            ongoingtrip = OngoingTripDetails().obs;
            directiondetails = Directiondetails().obs;
            livedirectiondetails = Directiondetails().obs;
            requestdetails = RequestDetails().obs;
            pageindexcontroller.updateIndex(1);
            newtripstatusvalue = null;
            // driverxcontroller.enableLibeLocationUpdate();
            hasongingtrip(false);

            hasacceptedrequest(false);
            Future.delayed(Duration(milliseconds: 300), () {
              Get.offNamedUntil(HomeScreenManager.screenName, (route) => false);
              //Get.offNamed(HomeScreenManager.screenName);
            });
              });  

          
          });
        });
      });
    });
  }
}
