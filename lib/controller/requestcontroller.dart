import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleappdriver/config/mapconfig.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/pageindexcontroller.dart';
import 'package:tricycleappdriver/dialog/authdialog/authenticating.dart';
import 'package:tricycleappdriver/dialog/collectionofdialog.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/model/directiondetails.dart';
import 'package:tricycleappdriver/model/tripdetails.dart';
import 'package:tricycleappdriver/screens/ongoingtrip.dart';
import 'package:tricycleappdriver/screens/trips_screen.dart';
import 'package:tricycleappdriver/services/mapservices.dart';

class Requestcontroller extends GetxController {
  var driverxcontroller = Get.find<Drivercontroller>();
  var tripdetails = Tripdetails().obs;
  var directiondetails = Directiondetails().obs;
  var livedirectiondetails = Directiondetails().obs;
  var pageindexcontroller = Get.find<Pageindexcontroller>();
  var isDirectiionReady = false.obs;
  var isTripDetailsReady = false.obs;
  var testpositiono = "".obs;
  var buttontext= "GO";
  var tripTextIsloading = false.obs;
  Position? currentpostion;
  void confirmRequest(String? requestid) async {
    Get.back();
    progressDialog("Loading...");

    if (requestid != null) {
      requestcollecctionrefference
          .doc(requestid)
          .get()
          .then((documentsnapshot) async {
        if (documentsnapshot.data() != null) {
          driverxcontroller.disableLiveLocationUpdate();
         currentpostion = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          Map<String, dynamic> currentlocation = {
            'latitude': currentpostion!.latitude.toString(),
            'longitude': currentpostion!.longitude.toString(),
          };

          print('_________________________');
          print(currentlocation);
          var driverdata;
          await driversusers
              .doc(authinstance.currentUser!.uid)
              .get()
              .then((driverinformation) {
            driverdata = driverinformation.data() as Map<String, dynamic>;
          });

          var data = documentsnapshot.data() as Map<String, dynamic>;

          print(data);

          String request_status = data['status'];

          if (request_status == "pending") {
            requestcollecctionrefference.doc(requestid).update({
              'driver_id': authinstance.currentUser!.uid,
              'driver_name': driverdata['name'],
              'driver_phone': driverdata['phone'],
              'driver_location': currentlocation,
              'status': 'accepted',
              'tripstatus': 'prepairing',
            }).then((_) async {
              var isTripDetailsReady = await getRouteDirection(requestid);

              if (isTripDetailsReady) {
                Get.back();
                pageindexcontroller.updateIndex(2);
                Future.delayed(Duration(milliseconds: 300), () {
                  Get.offNamed(
                    Ongoingtrip.screenName,
                  );
                });
              } else {
                Get.back();
                infoDialog('Route Direction');
              }
            });
          } else if (request_status == "accepted") {
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

  Future<bool> getRouteDirection(String requestid) async {
    bool tripDetailsReady = false;

    var data;

    await requestcollecctionrefference
        .doc(requestid)
        .get()
        .then((snapshot) async {
      if (snapshot.data() != null) {
        data = snapshot.data() as Map<String, dynamic>;
        Tripdetails newtripdetails = Tripdetails.fromJson(data);
        newtripdetails.triprequestid = requestid;
        newtripdetails.driverid = authinstance.currentUser!.uid;
        tripdetails(newtripdetails);

        if (newtripdetails.driverid != null) {
          if (newtripdetails.driverid!.isNotEmpty) {
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
       
        var newdirectiondetails =  Directiondetails.fromJason(response);

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

    requestcollecctionrefference
        .doc(requestid)
        .update({'driver_location': newdriverlocation});
  }

  void getNewTripDirection(
      LatLng drivercurrentpostion, LatLng finaldestionation) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${drivercurrentpostion.latitude},${drivercurrentpostion.longitude}&destination=${finaldestionation.latitude},${finaldestionation.longitude}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";

    try {
      var response = await Mapservices.mapRequest(url);

      if (response != 'failed') {
 
        Directiondetails newdliveirectiondetails = Directiondetails.fromJason(response);
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
    await requestcollecctionrefference.doc(requestid).get().then((documentsnapshot) async {    
      if (documentsnapshot.data() != null)  {
        var data = documentsnapshot.data() as Map<String, dynamic>;
         if(data['tripstatus'] == "prepairing"){
          await requestcollecctionrefference.doc(requestid).update({
              'tripstatus': 'arrived',
             // from pickup to distination 
           });
          var isupdated =  await updatePolylines(LatLng(currentpostion!.latitude, currentpostion!.longitude), tripdetails.value.picklocation as LatLng);
              print('________________updated to arrive');
             isChange = isupdated;
             print(isChange);
         
             
            buttontext ="Arrived";
             tripdetails.value.tripstatus = "arrived";
             tripTextIsloading(false);
           
        }else if(data['tripstatus'] == "arrived"){
          await requestcollecctionrefference.doc(requestid).update({
              'tripstatus': 'travelling',
             // from pickup to distination 
           });
          var isupdated =  await updatePolylines( tripdetails.value.picklocation as LatLng, tripdetails.value.droplocation as LatLng);
              print('________________updated');
             isChange = isupdated;
             print(isChange);
             
            buttontext ="Start";
             tripdetails.value.tripstatus = "travelling";
             tripTextIsloading(false);

        }else{
          await requestcollecctionrefference.doc(requestid).update({
              'tripstatus': 'complete',
             // from pickup to distination 
           });

             isChange = true;
             print(isChange);
             
            buttontext ="End Trip";
             tripdetails.value.tripstatus = "complete";
             tripTextIsloading(false);

        }
      }else{
        isChange = false;
      }
    });
  print('before returning_____||||||||||||||');
  print(isChange);
            
  return isChange;
  }


  Future<bool> updatePolylines(LatLng from, LatLng to) async{
    bool isReady = false;
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";

    try {
      var response = await Mapservices.mapRequest(url);

      if (response != 'failed') {

        Directiondetails updatedirectiondetails = Directiondetails.fromJason(response);

        directiondetails(updatedirectiondetails);
            isReady = true;
        print('____________update response');
        print(response);

      }

  }catch (e){
    isReady = true;
    print(e);
  }

  return isReady;
  }


  void endTrip(){
    driverlocationstream!.cancel();
    tripdetails =  Tripdetails().obs;
    tripdetails.value.tripstatus = "prepairing";
    directiondetails = Directiondetails().obs;
    livedirectiondetails =  Directiondetails().obs;
  }


}
