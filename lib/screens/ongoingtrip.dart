import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;
import 'package:tricycleappdriver/assistant/debub_assistant.dart';
import 'package:tricycleappdriver/assistant/mapkitassistant.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/dialog/requestdialog/completetripdialog.dart';
import 'package:tricycleappdriver/dialog/requestdialog/dialog_collection.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/screens/complete_screen.dart';

class Ongoingtrip extends StatefulWidget {
  static const screenName = "/ongoingtrip";

  @override
  State<Ongoingtrip> createState() => _OngoingtripState();
}

class _OngoingtripState extends State<Ongoingtrip> {
  var requestxconroller = Get.find<Requestcontroller>();
  var driverxcontroller = Get.put(Drivercontroller());

  double mappadding = 0;
  Completer<GoogleMapController> googlemapcontrollercompleter = Completer();
  GoogleMapController? newgooglemapcontroller;
  Set<Marker> markerSet = {};
  Set<Polyline> polylineSet = {};
  Set<Circle> circleSet = {};
  Marker? pickupmarker;
  Marker? dropmarker;
  Circle? pickcircle;
  Circle? dropcircle;
  CameraPosition? cameraposition;
  BitmapDescriptor? drivermarkericon;
  Position? driverposition;
  LatLng? driverlatlingposition;
  String durationText = "";
  String testpostion = "";
  String? currentripstatus;
  


  var isTripReady = true;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
isTripDetailsReady();
    //isTripDetailsReady();
  }


  void isTripDetailsReady() async {


      var istripready =  await  requestxconroller.listenToOngoingTrip();

      if(istripready){
        //
        currentripstatus = requestxconroller.ongoingtrip.value.tripstatus;


        
        //set map ready
        setTripMapIsready(istripready);
        //set markder
        setTripMarkers();
        //draw lout
        setPolylines();

        if(requestxconroller.ongoingtrip.value.tripstatus == "coming" || requestxconroller.ongoingtrip.value.tripstatus =="picked"){
          getLiveLocationUpdate();
        }

          
      }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
    // TODO: implement setState
  }

  void setTripMapIsready(bool value){
    setState(() {
      isTripReady = value;
    });
  }

  void createCustomDriverMarker() {
    ImageConfiguration imageconfiguation =
        createLocalImageConfiguration(context, size: Size(2, 2));
    BitmapDescriptor.fromAssetImage(
            imageconfiguation, "assets/images/052car-android.png")
        .then((value) => drivermarkericon = value);
  }

  int _polylincecounter = 1;


  void setTripMarkers() async {
 

     pickupmarker = Marker(
      markerId: MarkerId("pickmarker"),
      position: requestxconroller.ongoingtrip.value.pick_location as LatLng,
    );

     dropmarker = Marker(
      markerId: MarkerId("dropmarker"),
      position:requestxconroller.ongoingtrip.value.actualmarker_position as LatLng,
    );

    //circle
    
      pickcircle = Circle(
        zIndex: 1,
        fillColor: Colors.blueAccent,
        center:  requestxconroller.ongoingtrip.value.pick_location as LatLng,
        strokeWidth: 4,
        radius: 12,
        strokeColor: Colors.white,
        circleId: CircleId("pickcicrcle"));

     dropcircle = Circle(
        fillColor: Colors.blueAccent,
        center:
            requestxconroller.ongoingtrip.value.actualmarker_position as LatLng,
        strokeWidth: 4,
        radius: 12,
        strokeColor: Colors.white,
        circleId: CircleId("dropcircle"));
    

    setState(() { 

        markerSet.add(pickupmarker as Marker);
        markerSet.add(dropmarker as Marker);
        circleSet.add(pickcircle as Circle);
        circleSet.add(dropcircle as Circle);
    });
    

  }

  void _caneraBoundRoute(LatLng bound_sw, LatLng bound_ne) {
    newgooglemapcontroller!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: bound_sw, northeast: bound_ne), 50));
  }

  void setPolylines() {
    if (requestxconroller.directiondetails.value.polylines_encoded != null) {
      String polylineIdVal = "polyline_id${_polylincecounter}";
      polylineSet.clear();
      polylineSet.add(
        Polyline(
            polylineId: PolylineId(polylineIdVal),
            width: 6,
            jointType: JointType.mitered,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
            color: Colors.deepPurple,
            points: requestxconroller.directiondetails.value.polylines_encoded!
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList()),
      );

      _caneraBoundRoute(
          requestxconroller.directiondetails.value.bound_sw as LatLng,
          requestxconroller.directiondetails.value.bound_ne as LatLng);
    }
  }

  setisTripReady(bool value) {
    setState(() {
      isTripReady = value;
    });
  }

  void getLiveLocationUpdate() {

    DebubAssistant.printDataLine('live location called', 'test');
    LatLng oldpostion = LatLng(0, 0);

    driverlocationstream = Geolocator.getPositionStream().listen((Position position) async {
      driverposition = position;
      LatLng latlingpostion = LatLng(driverposition!.latitude, driverposition!.longitude);
      var rot = Mapkitassistant.getMarkerRotation(
          oldpostion.latitude,
          oldpostion.longitude,
          latlingpostion.latitude,
          latlingpostion.longitude);
      Marker movingDriverMarker = Marker(
        markerId: MarkerId("drivermarker"),
        position: latlingpostion,
        rotation: rot,
        anchor: Offset(0.5, 0.5),
        icon: drivermarkericon as BitmapDescriptor,
        infoWindow: InfoWindow(title: "current Location"),
      );

      setState(() {
        CameraPosition camerapostion = CameraPosition(target: latlingpostion, zoom: 17);
        newgooglemapcontroller!  .moveCamera(CameraUpdate.newCameraPosition(camerapostion));
        markerSet .removeWhere((marker) => marker.markerId.value == "drivermarker");
        markerSet.add(movingDriverMarker);
      });

      requestxconroller.getNewTripDirection(latlingpostion,requestxconroller.ongoingtrip.value.drop_location as LatLng);

      setState(() {
        //testpostion = requestxconroller.testpositiono;
        durationText = requestxconroller.directiondetails.value.durationText as String;
      });

      oldpostion = latlingpostion;
      requestxconroller.updateDriverTripPosition(latlingpostion,  requestxconroller.ongoingtrip.value.request_id as String);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (driverlocationstream != null) {
      driverlocationstream!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    createCustomDriverMarker();
  
    return Scaffold(
      body:

          isTripReady == false ? Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ) :

          Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mappadding),
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            polylines: polylineSet,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: markerSet,
            circles: circleSet,
            compassEnabled: true,
            mapToolbarEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController mapcontroller) {
              if (!googlemapcontrollercompleter.isCompleted) {
                googlemapcontrollercompleter.complete(mapcontroller);
                newgooglemapcontroller = mapcontroller;
                // setTripMarkers();
                // setPolylines();
                // getallDetails();

                // getLiveLocationUpdate();
              }
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              // width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Obx(() {

                  if(requestxconroller.ongoingtrip.value.request_id != null){
                      return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(durationText, style: Get.theme.textTheme.headline5),
                      // Text(requestxconroller.testpositiono.value,
                      //     style: Get.theme.textTheme.headline5),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${currentripstatus}',
                        style: Get.theme.textTheme.bodyText1,
                      ),
                      Text(
                        '${requestxconroller.ongoingtrip.value.pickaddress_name}',
                        style: Get.theme.textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${requestxconroller.ongoingtrip.value.dropddress_name}',
                        style: Get.theme.textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          
                            
                          TextButton(onPressed: () async {

                             // DebubAssistant.printDataLine('called', 'tesat');
                            
                              String response =  await requestxconroller.updateOngoingTripStatus();

                              DebubAssistant.printDataLine('response of update', response);

                            
                              //if changes
                              if(currentripstatus != response){

                               


                              //update trip status local to new valu
                              setState(() {
                                currentripstatus = requestxconroller.ongoingtrip.value.tripstatus;
                               });
                                
                                
                                if(currentripstatus == 'coming'){
                                   print('time ta called live update');
                                    //update driver location live
                                    getLiveLocationUpdate();
                                 
                                 
                                }

                                if(currentripstatus == 'picked'){
                                   print('time to resume live update');
                                    //update driver location live
                                  getLiveLocationUpdate();
                                  
                                }
                                if(currentripstatus == 'complete'){

                                    DialogCollection.showpaymentToCollect(context);
                                    


                                  // Get.offNamedUntil(CompleteScreen.screenName, (route) => false);
                                  
                                   //  showEarningDialog();

                                 

                                    // showDialog(context: context, builder: (context){

                                    //   return Scaffold(
                                    //     body: Container(
                                    //         child: Column(mainAxisSize: MainAxisSize.min, children: [
                                    //                 SizedBox(
                                    //                   height: 12,
                                    //                 ),
                                    //                 Column(
                                    //                   crossAxisAlignment: CrossAxisAlignment.start,
                                    //                   children: [
                                    //                     Text('₱ 50'),
                                    //                     Text('To Be Collected'),
                                    //                     ElevatedButton(onPressed: () {
                                    //                       requestxconroller.endTrip(requestxconroller.ongoingtrip.value.request_id as String);
                                                          
                                    //                     }, child: Text("CONFIRM"))
                                    //                   ],
                                    //                 ),
                                    //               ])
                                    //     ),
                                    //   );
                                    // });

                                    // driverlocationstream!.cancel();
                                    // setState(() {
                                    //   polylineSet.clear();
                                    //   markerSet.clear();
                                    //   circleSet.clear();
                                    // });

                                  
                                }

                                if(currentripstatus == "coming" || currentripstatus == "picked"){
                                  setState(() {
                                     setPolylines(); 
                                    
                                  });
                                }

                                
                                


                              }


                          }, child:requestxconroller.tripTextIsloading.value
                                ? SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  )
                                : Text(requestxconroller.buttontext != ""
                                    ? requestxconroller.buttontext
                                    : "Start"),),
                          TextButton(onPressed: () {}, child: Text('Info')),
                          TextButton(onPressed: () {
                            Get.offNamed(HomeScreenManager.screenName);
                          }, child: Text('BACK')),
                        ],
                      ),

                      if(requestxconroller.ongoingtrip.value.tripstatus == "coming")
                          ElevatedButton(onPressed: () async {
                            requestxconroller.launchMapsUrl( requestxconroller.ongoingtrip.value.pick_location_id as String, requestxconroller.ongoingtrip.value.drop_location_id as String,
     
                  requestxconroller.ongoingtrip.value.drop_location as LatLng);
                          }, child:Text('Open With Google Map Assistant ')),

                          
                    ],
                  );
                  }

                  return Container( child: Text("no Trip"),);

                  
                }),
              ),
            ),
          ),
        ],

        
      ),
    );
  }


}
