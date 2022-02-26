import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
import 'package:tricycleappdriver/model/tripdetails.dart';
import 'package:tricycleappdriver/screens/ongoingtrip.dart';
import 'package:tricycleappdriver/screens/trips_screen.dart';
import 'package:tricycleappdriver/services/mapservices.dart';
import 'package:url_launcher/url_launcher.dart';

class Requestcontroller extends GetxController {
  var authxcontroller =  Get.find<Authcontroller>();
  var driverxcontroller = Get.find<Drivercontroller>();
  var mapxcontroller = Get.find<Mapcontroller>();
  var pagexcontroller = Get.find<Pageindexcontroller>();
  var tripdetails = Tripdetails().obs;
  var directiondetails = Directiondetails().obs;
  var livedirectiondetails = Directiondetails().obs;
  var pageindexcontroller = Get.find<Pageindexcontroller>();
  var isDirectiionReady = false.obs;
  var isTripDetailsReady = false.obs;
  var testpositiono = "".obs;
  var buttontext = "";
  var tripTextIsloading = false.obs;
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
          
            var data = documentsnapshot.data() as Map<String, dynamic>;
            print('__________________________________confriem');
            print(data);
            String request_status = data['status'];
          if(request_status == "pending"){

            currentpostion = mapxcontroller.currentposition;
          //     currentpostion = await Geolocator.getCurrentPosition(
          //     desiredAccuracy: LocationAccuracy.high);
               Map<String, dynamic> currentlocation = {
            'latitude': currentpostion!.latitude.toString(),
            'longitude': currentpostion!.longitude.toString(),
          };

          print('____________________get driverdata');
        

          // await driversusers
          //     .doc(authinstance.currentUser!.uid)
          //     .get()
          //     .then((driverinformation) {
          //   driverdata = driverinformation.data() as Map<String, dynamic>;
          // });

             requestcollecctionrefference.doc(requestid).update({
              'driver_id': authinstance.currentUser!.uid,
              'driver_name': authxcontroller.useracountdetails.value.name,
              'driver_phone': authxcontroller.useracountdetails.value.phone,
              'driver_location': currentlocation,
              "status": "accepted",
              
 
            }).then((_) async {
               // driverxcontroller.disableLiveLocationUpdate();
              var isTripDetailsReady = await getRouteDirection(requestid);

              if (isTripDetailsReady) {
                await ongointripreferrence
                    .doc(tripdetails.value.triprequestid)
                    .set(ongoingtripdata).then((_) async {
                        await requestcollecctionrefference.doc(requestid).update({
                           'tripstatus':'ready',  
                         });
                    });
                mapxcontroller.makeDriverOffline();

                Get.back();
                
                pageindexcontroller.updateIndex(2);
                Future.delayed(Duration(milliseconds: 300), () {  

                  //openMap(tripdetails.value.droplocation!.latitude,tripdetails.value.droplocation!.latitude);
                 //launchMapsUrl(tripdetails.value.picklocationid as String,tripdetails.value.droplocationid as String,tripdetails.value.droplocation as LatLng, directiondetails.value.polylines_encoded as List<PointLatLng>);
                //  Get.offNamedUntil(Ongoingtrip.screenName, (route) => false);
                  Get.toNamed(
                    Ongoingtrip.screenName,
                    arguments: {"coming": "request"}
                  );
                });
              } else {
                Get.back();
                infoDialog('Route Direction');
              }
            });
          }else{
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

Future<void> launchMapsUrl(String originPlaceId, String destionationplaceid, LatLng destinationposition )   async {

  print('___________________ luncher');
  print(originPlaceId);
  print(destionationplaceid);
  print(destinationposition);
   String googleUrl = 'https://www.google.com/maps/search/?api=1&query=${destinationposition.latitude},${destinationposition.longitude}&dir_action=navigate}';
  // // print('${tripdetails.value.actualmarkerposition!.latitude},${tripdetails.value.actualmarkerposition!.longitude}');
  //   String googleUrl = 'https://www.google.com/maps/search/?api=1&origin=${originPlaceId}&origin_place_id=${originPlaceId}&destination_place_id=${destionationplaceid}&destination=${destionationplaceid}&dir_action=navigate';
  // String googleUrl = 'https://www.google.com/maps/search/?api=1&origin_place_id=${originPlaceId}&destination=${destinationposition.latitude},${destinationposition.longitude}&travelmode=driving&dir_action=navigate';
  if(await canLaunch(googleUrl) != null) {
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
  Future<bool> getRouteDirection(String requestid) async {
    bool tripDetailsReady = false;

    var data;

    await requestcollecctionrefference
        .doc(requestid)
        .get()
        .then((snapshot) async {
      if (snapshot.data() != null) {


        ongoingtripdata.clear();
        data = snapshot.data() as Map<String, dynamic>;
        ongoingtripdata = data;
        ongoingtripdata['tripstatus']= 'prepairing';
        ongoingtripdata["payed"]=false;
        ongoingtripdata["read"]=false;
        

        Tripdetails newtripdetails = Tripdetails.fromJson(data);
        newtripdetails.triprequestid = requestid;
        newtripdetails.driverid = authinstance.currentUser!.uid;
        tripdetails(newtripdetails);

      

        if (newtripdetails.driverid != null) {
          if (newtripdetails.driverid!.isNotEmpty) {
            //show getting direction
            var isrouteready = await getDirection(
                newtripdetails.picklocationid as String,
                newtripdetails.droplocationid as String,
                newtripdetails.actualmarkerposition as LatLng);
            if (isrouteready) {
              tripDetailsReady = true;
              isTripDetailsReady(true);
            } else {
              tripDetailsReady = false;
              isTripDetailsReady(false);
            }
          } else {
            tripDetailsReady = false;
            isTripDetailsReady(false);
          }
        }
      }
    });

    return tripDetailsReady;
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

  void updateDriverTripPosition(LatLng position, String requestid) {
    Map<String, dynamic> newdriverlocation = {
      'latitude': position.latitude,
      'longitude': position.longitude,
    };
        ongointripreferrence.doc(requestid)
        .update({'driver_location': newdriverlocation});
  }

  void getNewTripDirection(
      LatLng drivercurrentpostion, LatLng finaldestionation) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${drivercurrentpostion.latitude},${drivercurrentpostion.longitude}&destination=${finaldestionation.latitude},${finaldestionation.longitude}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";

    try {
      var response = await Mapservices.mapRequest(url);

      if (response != 'failed') {
        Directiondetails newdliveirectiondetails =
            Directiondetails.fromJason(response);
        livedirectiondetails(newdliveirectiondetails);
        testpositiono(drivercurrentpostion.latitude.toString());

        //testpositiono = drivercurrentpostion.latitude.toString();

      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> updateTripStatus(String requestid) async {
    bool isChange = false;
    tripTextIsloading(true);
    await ongointripreferrence.doc(requestid).get().then((document) async {
      if (document.data() != null) {
        var data = document.data() as Map<String, dynamic>;

        if (data['tripstatus'] == "prepairing") {
          await ongointripreferrence.doc(requestid).update({
            'tripstatus': 'coming',
          });

          var isupdated = await updatePolylines(
              LatLng(currentpostion!.latitude, currentpostion!.longitude),
              tripdetails.value.picklocation as LatLng);
          isChange =
              await updateTripStatusDetails(requestid, isChange, isupdated);
        } else if (data['tripstatus'] == "coming") {
          await ongointripreferrence.doc(requestid).update({
            'tripstatus': 'arrived',
          });
          var isupdated = await updatePolylines(
              tripdetails.value.picklocation as LatLng,
              tripdetails.value.droplocation as LatLng);
          isChange = await updateTripStatusDetails(requestid, isChange, isupdated);
           if (driverlocationstream != null) {
            driverlocationstream!.cancel();
          }
        } else if (data['tripstatus'] == "arrived") {
          await ongointripreferrence.doc(requestid).update({
            'tripstatus': 'picked',
                        
          });

          isChange = await updateTripStatusDetails(requestid, isChange, null);
          
        } else if (data['tripstatus'] == "picked") {
          await ongointripreferrence.doc(requestid).update({
            'tripstatus': 'complete',
          });
          isChange = await updateTripStatusDetails(requestid, isChange, null);
         // showEarningDialog();
        }
      }
    });

    tripTextIsloading(false);
    print('before returning_____||||||||||||||');
    print(isChange);

    return isChange;
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

        tripdetails.value.tripstatus = statusdata['tripstatus'];
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
    await ongointripreferrence.doc(requestid).update({
       'payed': true,
    });

    Map<String, dynamic> pickuplocation = {
      "latitude": tripdetails.value.picklocation!.latitude.toString(),
      "longitude": tripdetails.value.picklocation!.longitude.toString(),
    };

    Map<String, dynamic> destionation = {
      "latitude": tripdetails.value.droplocation!.latitude.toString(),
      "longitude": tripdetails.value.droplocation!.longitude.toString(),
    };

    Map<String, dynamic> ongoingtripdata = {
       "driver_id": tripdetails.value.driverid,
      "passenger_id": requestid,
      "pickuplocation": pickuplocation,
      "pickuplocation_name": tripdetails.value.pickaddressname,
      "dropplocation_name": tripdetails.value.dropddressname,

      
      "destination": destionation,
      "earn": 100,
      "fees": 100,
      "tripstatus": "completed",
      "date": DateTime.now().toString(),
    };

    await drivertriphistoryreferrence.doc(authinstance.currentUser!.uid).collection('trips').add(ongoingtripdata).then((_) async {
      await passengertriphistoryreferrence.doc(requestid).collection('trips').add(ongoingtripdata).then((_)  async{
         await requestcollecctionrefference.doc(requestid).delete().then((value) {
         mapxcontroller.makeDriverOnline();
          if (driverlocationstream != null) {
            driverlocationstream!.cancel();
          }
          
          tripdetails = Tripdetails().obs;
          tripdetails.value.tripstatus = "prepairing";
          directiondetails = Directiondetails().obs;
          livedirectiondetails = Directiondetails().obs;
          pageindexcontroller.updateIndex(2);
         // driverxcontroller.enableLibeLocationUpdate();
         pagexcontroller.updateIndex(2);
          Get.back();
          Future.delayed(Duration(milliseconds: 300), () {
            Get.offNamedUntil(HomeScreenManager.screenName, (route) => false);
            //Get.offNamed(HomeScreenManager.screenName);
          });
      });
      });
     
    });
  }

  Future<bool> checkIsTripReady() async{
    bool? isTripReady; 


    if(tripdetails.value.triprequestid != null){

      print('_____insidecheckIsTripready');


    print(tripdetails.value.picklocation);
    print('_____before returning tripready');
    isTripReady = true;
    }else{
    isTripReady = false;
    }
 
    print(isTripReady);

    return isTripReady as bool;
  }
}
