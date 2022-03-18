import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as toolkit;
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/assistant/debub_assistant.dart';
import 'package:tricycleappdriver/assistant/mapkitassistant.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/dialog/authdialog/authdialog.dart';
import 'package:tricycleappdriver/dialog/requestdialog/completetripdialog.dart';
import 'package:tricycleappdriver/dialog/requestdialog/dialog_collection.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/screens/complete_screen.dart';



import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

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

  var spinkit = SpinKitWave(
    color: Colors.white,
    size: 50.0,
  );

  var isTripReady = true;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 17.4746,
  );

  @override
  void initState() {
    super.initState();

    isTripDetailsReady();
  
    //isTripDetailsReady();
  }



  void boundCamera() {
    var bound_sw = requestxconroller.directiondetails.value.bound_sw as LatLng;
    var bound_ne = requestxconroller.directiondetails.value.bound_ne as LatLng;

    newgooglemapcontroller!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: bound_sw, northeast: bound_ne), 45));
  }

  void isTripDetailsReady() async {
    requestxconroller.loaderoftrip(true);
    print('caaled');
    var istripready = await requestxconroller.listenToOngoingTrip();

    if (istripready) {
      
    
      currentripstatus = requestxconroller.ongoingtrip.value.tripstatus;
      print('payed==');
      print(requestxconroller.ongoingtrip.value.payed);

      //set map ready
      setTripMapIsready(istripready);
      //set markder
      setTripMarkers();
      //draw lout
      setPolylines();

      requestxconroller.loaderoftrip(false);
      if (requestxconroller.ongoingtrip.value.tripstatus == "coming" ||
          requestxconroller.ongoingtrip.value.tripstatus == "picked") {
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

  void setTripMapIsready(bool value) {
    setState(() {
      isTripReady = value;
    });
  }

  void createCustomDriverMarker() {
    ImageConfiguration imageconfiguation =
        createLocalImageConfiguration(context, size: Size(2, 2));
    BitmapDescriptor.fromAssetImage(
            imageconfiguation, "assets/images/Motorcycle_8.png")
        .then((value) => drivermarkericon = value);
  }

  int _polylincecounter = 1;

  void setTripMarkers() async {
    pickupmarker = Marker(
      markerId: MarkerId("pickmarker"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      position: requestxconroller.ongoingtrip.value.pick_location as LatLng,
    );

    dropmarker =   Marker(
      markerId: MarkerId("dropmarker"),
      position:requestxconroller.ongoingtrip.value.actualmarker_position as LatLng,
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    //circle

    pickcircle = Circle(
        zIndex: 1,
        fillColor: Colors.purpleAccent.withOpacity(0.5),
        center: requestxconroller.ongoingtrip.value.pick_location as LatLng,
        strokeWidth: 1,
        radius: 26,
        strokeColor: Colors.purpleAccent,
        circleId: CircleId("pickcicrcle"));

    dropcircle = Circle(
        fillColor: Colors.redAccent.withOpacity(0.5),
        center:
            requestxconroller.ongoingtrip.value.actualmarker_position as LatLng,
        strokeWidth: 1,
        radius: 26,
        strokeColor: Colors.redAccent,
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
            color: ELSA_GREEN,
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

    driverlocationstream =
        Geolocator.getPositionStream().listen((Position position) async {
      driverposition = position;
      LatLng latlingpostion =
          LatLng(driverposition!.latitude, driverposition!.longitude);
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
        CameraPosition camerapostion =
            CameraPosition(target: latlingpostion, zoom: 17);
        newgooglemapcontroller!
            .animateCamera(CameraUpdate.newCameraPosition(camerapostion));
        // newgooglemapcontroller!
        //     .moveCamera(CameraUpdate.newCameraPosition(camerapostion));
        markerSet
            .removeWhere((marker) => marker.markerId.value == "drivermarker");
        markerSet.add(movingDriverMarker);
      });

      requestxconroller.getNewTripDirection(latlingpostion,
          requestxconroller.ongoingtrip.value.drop_location as LatLng);

      setState(() {
        //testpostion = requestxconroller.testpositiono;
        durationText =
            requestxconroller.directiondetails.value.durationText as String;
      });

      oldpostion = latlingpostion;
      requestxconroller.updateDriverTripPosition(latlingpostion,
          requestxconroller.ongoingtrip.value.request_id as String);
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
      appBar: AppBar(
        actions: [

          IconButton(
              onPressed: () {
                boundCamera();
              },
              icon: FaIcon(FontAwesomeIcons.mapMarked),)
        ],
        leading: IconButton(
            onPressed: () {
              Get.off(() => HomeScreenManager());
              
            },
            icon: FaIcon(FontAwesomeIcons.times)),
      ),
      body: isTripReady == false
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Stack(
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
                      newgooglemapcontroller!.setMapStyle(mapdarktheme);
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
                  child: SingleChildScrollView(
                    child: Container(
                      // width: MediaQuery.of(context).size.width,
                      constraints: BoxConstraints(
                        maxHeight: 300,
                      ),
                      decoration: BoxDecoration(
                          color: BACKGROUND_BOTTOM,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 10),
                        child: Obx(() {
                          if (requestxconroller.tripTextIsloading.value) {
                            return Center(
                              child: spinkit,
                            );
                          } else {
                            if (requestxconroller
                                    .ongoingtrip.value.request_id !=
                                null) {
                              return SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (durationText != "")
                                      Text(durationText,
                                          style: Get.theme.textTheme.headline5),
                                    Verticalspace(8),

                                    Text(
                                      'From',
                                      style: Get.theme.textTheme.bodyText1!
                                          .copyWith(
                                            color: Colors.purpleAccent
                                          ),
                                          
                                    ),
                                    Verticalspace(4),
                                    Text(
                                      '${requestxconroller.ongoingtrip.value.pickaddress_name}',
                                      style: Get.theme.textTheme.bodyText1!
                                          .copyWith(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Verticalspace(8),
                                    Text(
                                      'To',
                                      style: Get.theme.textTheme.bodyText1!
                                          .copyWith(
                                            color: Colors.redAccent
                                          ),
                                    ),
                                    Verticalspace(4),
                                    Text(
                                      '${requestxconroller.ongoingtrip.value.dropddress_name}',
                                      style: Get.theme.textTheme.bodyText1!
                                          .copyWith(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Verticalspace(8),
                                    Divider(
                                      thickness: 1,
                                      color: LIGHT_CONTAINER,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: Text(
                                        requestxconroller.ongoingtrip.value
                                                    .tripstatus ==
                                                "prepairing"
                                            ? 'Press the button if you are ready'
                                            : requestxconroller.ongoingtrip
                                                        .value.tripstatus ==
                                                    "coming"
                                                ? 'Press the button when you already arrived'
                                                : requestxconroller.ongoingtrip
                                                            .value.tripstatus ==
                                                        "arrived"
                                                    ? 'Wait for the customer and start the trip if ready'
                                                    : '',
                                        style: TextStyle(
                                            color: ELSA_GREEN,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    //   if (requestxconroller .ongoingtrip.value.tripstatus ==   "coming" || requestxconroller .ongoingtrip.value.tripstatus ==   "picked" )
                                    //  GestureDetector(
                                    //   onTap: () async {

                                    //        requestxconroller.launchMapsUrl(
                                    //             requestxconroller
                                    //                 .ongoingtrip
                                    //                 .value
                                    //                 .pick_location_id as String,
                                    //             requestxconroller
                                    //                 .ongoingtrip
                                    //                 .value
                                    //                 .drop_location_id as String,
                                    //             requestxconroller
                                    //                 .ongoingtrip
                                    //                 .value
                                    //                 .drop_location as LatLng);

                                    //   },
                                    //   child: Row(
                                    //     children: [
                                    //       Image.asset('assets/images/icons8-google-maps-48.png' , height: 34 ,width: 34,),
                                    //       Text('Google Map', )

                                    //     ],

                                    //   ),
                                    // ),
                                    Verticalspace(16),

                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      width: double.infinity,
                                      height: 60,
                                      decoration: const ShapeDecoration(
                                        shape: StadiumBorder(),
                                        gradient: LinearGradient(
                                          end: Alignment.bottomCenter,
                                          begin: Alignment.topCenter,
                                          colors: [
                                            ELSA_BLUE_1_,
                                            ELSA_BLUE_1_,
                                          ],
                                        ),
                                      ),
                                      child: MaterialButton(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: const StadiumBorder(),
                                        child: Text(
                                          requestxconroller.ongoingtrip.value
                                                      .tripstatus ==
                                                  "prepairing"
                                              ? 'LET\'S GO'
                                              : requestxconroller.ongoingtrip
                                                          .value.tripstatus ==
                                                      "coming"
                                                  ? 'ARRIVED'
                                                  : requestxconroller
                                                              .ongoingtrip
                                                              .value
                                                              .tripstatus ==
                                                          "arrived"
                                                      ? 'STAR TRIP'
                                                      : 'END TRIP',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () async {
                                          await updateTripStatus(context);
                                        },
                                      ),
                                    ),
                                    Verticalspace(12),
                                  ],
                                ),
                              );
                            } else {
                              return Container(child: spinkit);
                            }
                          }
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> updateTripStatus(BuildContext context) async {

print(requestxconroller.ongoingtrip.value.tripstatus);
    

    String response = await requestxconroller.updateOngoingTripStatus();

    DebubAssistant.printDataLine('response of update', response);

    //if changes
    if (currentripstatus != response) {
      //update trip status local to new valu
      setState(() {
        currentripstatus = requestxconroller.ongoingtrip.value.tripstatus;
      });

      if (currentripstatus == 'coming') {
        print('time ta called live update');
        //update driver location live
        getLiveLocationUpdate();
      }

      if (currentripstatus == 'picked') {
        print('time to resume live update');
        //update driver location live
        getLiveLocationUpdate();
      }
      if (currentripstatus == 'complete') {
        DialogCollection.showpaymentToCollect(context);
      }

      if (currentripstatus == "coming" || currentripstatus == "picked") {
        setState(() {
          setPolylines();
        });
      }
  
  
  }else{
   if (requestxconroller.ongoingtrip.value.tripstatus== 'complete' && requestxconroller.ongoingtrip.value.payed == false ) {
        DialogCollection.showpaymentToCollect(context);
      }
  }
  }
}
