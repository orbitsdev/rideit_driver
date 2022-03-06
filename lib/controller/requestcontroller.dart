

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleappdriver/config/firebaseconfig.dart';
import 'package:tricycleappdriver/config/mapconfig.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/mapcontroller.dart';
import 'package:tricycleappdriver/controller/pageindexcontroller.dart';
import 'package:tricycleappdriver/dialog/authdialog/authenticating.dart';
import 'package:tricycleappdriver/dialog/collectionofdialog.dart';
import 'package:tricycleappdriver/dialog/requestdialog/completetripdialog.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/model/directiondetails.dart';
import 'package:tricycleappdriver/model/ongoing_trip_details.dart';
import 'package:tricycleappdriver/model/request_details.dart';
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

  var requestdetails = RequestDetails();
  var ongoingtrip = OngoingTripDetails().obs;
  var directiondetails = Directiondetails().obs;
  var livedirectiondetails = Directiondetails().obs;
  var pageindexcontroller = Get.find<Pageindexcontroller>();
  var isDirectiionReady = false.obs;
  var isOngoingReady = false.obs;
  var collecting = false.obs;
  var testpositiono = "".obs;
  var buttontext = "";
  var tripTextIsloading = false.obs;
  var hasongingtrip = false.obs;
  var hasacceptedrequest = false.obs;
  Position? currentpostion;
  Map<String, dynamic> ongoingtripdata = {};

  void confirmRequest(String? requestid) async {
    Get.back();
    progressDialog("Loading...");
    if (requestid != null) {
      await requestcollecctionrefference
          .doc(requestid)
          .get()
          .then((documentsnapshot) async {
        if (documentsnapshot.data() != null) {

          // get request details  ;
          RequestDetails requestdetails = RequestDetails.fromJson(
              documentsnapshot.data() as Map<String, dynamic>);
          

          //check request
          if (requestdetails.status == "pending") {
          //get current location
            currentpostion = mapxcontroller.currentposition;
            Map<String, dynamic> currentlocation = {
              'latitude': currentpostion!.latitude,
              'longitude': currentpostion!.longitude,
            };

            //accept request with  driver information
            requestcollecctionrefference.doc(requestid).update({
              'driver_id': authinstance.currentUser!.uid,
              'driver_name': authxcontroller.useracountdetails.value.name,
              'driver_phone': authxcontroller.useracountdetails.value.phone,
              'driver_location': currentlocation,
              "status": "accepted",
            }).then((_) async {
              
            


            // store requestid in driver for ongoinng trip screen used only
              await drivercurrentrequestaccepted.doc(requestid).set({'status': 'accepted'}).then((_) async {

            //get direction and ongoingtripdetails local
                var isOngoingReady = await getDirectionAndCreateOngoingTrip(requestid);

                if (isOngoingReady) {
                  await requestcollecctionrefference.doc(requestid).update({
                    'tripstatus': 'ready',
                  }).then((value) async {
                    
                      //make driver offline
                       mapxcontroller.makeDriverOffline();
                      
                      //close loading screen 
                        Get.back();

                       //update page to trip para pag back mo malakat ka sa trip screen 
                        pageindexcontroller.updateIndex(2);
                        
                        //after 300 milliseconds lakat ka sa ongoing trip screen 
                        
                        Future.delayed(Duration(milliseconds: 300), () {
                        
                        //then store data in local na may ongoing trip ka
                        hasongingtrip(true);
                          Get.toNamed(Ongoingtrip.screenName,
                              arguments: {"from": "request"});
                        });
                    
                  });


                } else {
                  Get.back();
                  infoDialog('Route Direction');
                }
              });

              // driverxcontroller.disableLiveLocationUpdate();
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

  Future<void> launchMapsUrl(String originPlaceId, String destionationplaceid,
      LatLng destinationposition) async {
    print('___________________ luncher');
    print(originPlaceId);
    print(destionationplaceid);
    print(destinationposition);
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
   

    bool ongoingTripDetailsReady = false;
    OngoingTripDetails ongoingtripdetails = OngoingTripDetails();

    await requestcollecctionrefference
        .doc(requestid)
        .get()
        .then((snapshot) async {
      
        //check it has ongoing trip data
      if (snapshot.data() != null) {

        //get request details with driver information then convert is as ongoingtrip details
        ongoingtripdetails = OngoingTripDetails.fromJson( snapshot.data() as Map<String, dynamic>);
   

        //add more field to null data
        ongoingtripdetails.tripstatus = 'prepairing';
        ongoingtripdetails.payed = false;
        ongoingtripdetails.read = false;
        ongoingtripdetails.request_id = requestid;
        // printDebugline();

        //conver to json
        ongoingtripdata = ongoingtripdetails.toJson();
     

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

              ongoingTripDetailsReady = isOngoingTripCreated;
              isOngoingReady(isrouteready);

            } else {

              ongoingTripDetailsReady = false;
              isOngoingReady(false);
            }

        }else{
          
           ongoingTripDetailsReady = false;
           isOngoingReady(false);

        }

      } else {
        ongoingTripDetailsReady = false;
        isOngoingReady(false);
      }
    });

    return ongoingTripDetailsReady;
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

      print(e);
      return false;
    }
  }

  Future<bool> createOngoingTrip(Map<String, dynamic> ongoingtripdata) async {
    bool isOngoingTripCreated = false;
    try {
      await ongointripreferrence
          .doc(ongoingtripdata['request_id'])
          .set(ongoingtripdata)
          .then((_) async {
        isOngoingTripCreated = true;
      });
      isOngoingTripCreated = true;
    } catch (e) {
      isOngoingTripCreated = false;
    }

    return isOngoingTripCreated;
  }

  void updateDriverTripPosition(LatLng position, String requestid) async {
    Map<String, dynamic> newdriverlocation = {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };

    await ongointripreferrence.doc(requestid).update({'driver_location': newdriverlocation});
  }

  void getNewTripDirection(



    LatLng startingposition, LatLng finaldestionation) async {
    String url =   "https://maps.googleapis.com/maps/api/directions/json?origin=${startingposition.latitude},${startingposition.longitude}&destination=${finaldestionation.latitude},${finaldestionation.longitude}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";

    try {
      var response = await Mapservices.mapRequest(url);

      if (response != 'failed') {
        Directiondetails newdliveirectiondetails =
        
        
        
        
        
        
        
        
        
        
        
        
        Directiondetails.fromJason(response);
        livedirectiondetails(newdliveirectiondetails);
 

        //testpositiono = drivercurrentpostion.latitude.toString();

      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> updateOngoingTripStatus() async {
    bool isChange = false;
    tripTextIsloading(true);
    String? tripstatus;
    String? newtripstatusvalue;
    // to make sur
    

    if(ongoingtrip.value.tripstatus == "prepairing"){
        newtripstatusvalue = "coming";
    }else if(ongoingtrip.value.tripstatus == "coming"){
        newtripstatusvalue = "arrived";
      
    }else if(ongoingtrip.value.tripstatus == "arrived"){

        newtripstatusvalue = "picked";
    }
    else if(ongoingtrip.value.tripstatus == "picked"){

        newtripstatusvalue = "complete";

    }
    else if(ongoingtrip.value.tripstatus == "complete"){
          
        newtripstatusvalue = "check";
    }

      
      

    if(newtripstatusvalue != "check"){
       isChange = await updateTripStatusAndChangeDirectionDetails(newtripstatusvalue as String);
      if(isChange){

      //check updated  local tripstatus details  
        if(ongoingtrip.value.tripstatus == "coming"){
            
             //from driver current location to pickup location
            getNewTripDirection(ongoingtrip.value.driver_location as LatLng, ongoingtrip.value.pick_location as LatLng);
        
          }else if(ongoingtrip.value.tripstatus == "arrived"){

              sendNotification(ongoingtrip.value.device_token as String, 'Drivers is waiting to your pickup location' , 'Your Diver Has Arrived' , 'ongoingtrip');

            //stop updating driver location
            cancelDriverLiveLocation();
            
           }  

          else if(ongoingtrip.value.tripstatus == "picked"){

                  //from pickup location to dropofflocation
              getNewTripDirection(ongoingtrip.value.pick_location as LatLng, ongoingtrip.value.drop_location as LatLng);

          }
          else if(ongoingtrip.value.tripstatus == "complete"){
            cancelDriverLiveLocation();

           }

     
      //return update tripstaus

       tripstatus =  ongoingtrip.value.tripstatus;   
    }else{

      tripstatus =  ongoingtrip.value.tripstatus;    
    }
      //check if succefull update
      
      }else{

        // await requestcollecctionrefference.doc(authinstance.currentUser!.uid).get().then((value) {
        //   if(value.data() !=  null){
        //     var data =  value.data() as Map<String , dynamic>;

        //     if(data['accepted'])
        //   }
        // });
        
      tripstatus =  ongoingtrip.value.tripstatus;    
       //same tripstatus
      }

    tripTextIsloading(false);

    return tripstatus as String;

  }

  void cancelDriverLiveLocation(){
    if(driverlocationstream != null){

              driverlocationstream!.cancel();

            }

  }
  Future<bool> updateTripStatusAndChangeDirectionDetails(String tripstaus_new_value) async{

    bool isUpdated =  false;
      try{
         await ongointripreferrence.doc(ongoingtrip.value.request_id).update({
        "tripstatus": tripstaus_new_value,
      }).then((_) async {
        //update local details
        ongoingtrip.value.tripstatus = tripstaus_new_value;
        isUpdated = true;
      });
      }catch(e){
        isUpdated = false;
      }
     

    return isUpdated;
  }

  


  Future<bool> updateTripStatusDetails(
      String requestid, bool isChange, bool? isupdated) async {
    var statusdata;
    await ongointripreferrence.doc(requestid).get().then((value) {

      statusdata = value.data() as Map<String, dynamic>;
      if (statusdata != null) {
        switch (statusdata['tripstatus']) {
          case 'coming':
            buttontext = 'Arrived';
            break;
          case 'arrived':
            buttontext = 'Picked';
            break;
          case 'picked':
            buttontext = 'End Trip';
            break;
          case 'complete':
            buttontext = "";
            break;
        }

        ongoingtrip.value.tripstatus = statusdata['tripstatus'];
        tripTextIsloading(false);
        isChange = true;
      }
    });

    return isChange;
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
        print('____________update response');
        print(response);
      }
    } catch (e) {
      isReady = true;
      print(e);
    }

    return isReady;
  }

  void endTrip(String requestid) async {
      collecting(true);
    await ongointripreferrence.doc(requestid).update({
      'payed': true,
    });


  ongoingtrip.value.payed  = true;
    Map<String , dynamic> triphistorydata = ongoingtrip.value.toJson();

  DebubAssistant.printDataLine('before deleting', triphistorydata);




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
            mapxcontroller.makeDriverOnline();
            cancelDriverLiveLocation();

            ongoingtrip = OngoingTripDetails().obs;
            directiondetails = Directiondetails().obs;
            livedirectiondetails = Directiondetails().obs;
            pageindexcontroller.updateIndex(2);
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

  Future<bool> listenToOngoingTrip() async {
    bool? isTripReady;
    String? requestid;
     
    if (ongoingtrip.value.request_id == null) {
      requestid = await getAcceptedRequestId();
         await ongointripreferrence.doc(requestid).get().then((value) async {
         ongoingtrip(OngoingTripDetails.fromJson(value.data() as Map<String, dynamic>));
         print(ongoingtrip.value.dropddress_name);
         print(ongoingtrip.value.pickaddress_name);
      
        //get direction
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



  void checkIfHasOngoingRequest() async {
    await drivercurrentrequestaccepted.get().then((value) async {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((snapshot) {
          var data = snapshot.id;

          hasongingtrip(true);
        });

        print('___________________');
        print('_______has accepted request__________');
        print('___________________');
      } else {
        print('___________________');
        print('_______empty__________');
        print('___________________');

        hasongingtrip(false);
      }
    });
  }


void  sendNotification(String token, String title, String body, String screenname) async {
    print('__________sending notfification');
    
  
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

        print(response.statusCode);
      } catch (e) {
        print("error push notification");
      }
    
  }


  
}


