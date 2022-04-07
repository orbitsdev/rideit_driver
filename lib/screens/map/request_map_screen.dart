import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/dialog/mapdialog/map_dialog.dart';
import 'package:tricycleappdriver/model/request_details.dart';
import 'package:tricycleappdriver/screens/map/map_request_controller.dart';
import 'package:tricycleappdriver/widgets/horizontalspace.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

enum MapMode { normal, hybrid, satelite, darkmode }

class RequestMapScreen extends StatefulWidget {
  RequestDetails? request;
  RequestMapScreen({
    Key? key,
    this.request,
  }) : super(key: key);
  static const String screenName = "/requestmap";

  @override
  _RequestMapScreenState createState() => _RequestMapScreenState();
}

class _RequestMapScreenState extends State<RequestMapScreen> {
  var authcontroller = Get.find<Authcontroller>();

  MapMode mapmode = MapMode.hybrid;
  MapType maptype = MapType.hybrid;
  void getCurrenMaptyoe() {
    print(authcontroller.useracountdetails.value.map_mode);
    print('_______________|||||||||');
    print('_______________|||||||||asdasd');
    print('_______________|||||||||dasdas');

    if (authcontroller.useracountdetails.value.map_mode == "normal") {
      setState(() {
        maptype = MapType.normal;
        mapmode = MapMode.normal;
        newgooglemapcontroller!.setMapStyle(null);
      });
    }
    if (authcontroller.useracountdetails.value.map_mode == "satelite") {
      setState(() {
        maptype = MapType.satellite;
        mapmode = MapMode.satelite;
      });
    }
    if (authcontroller.useracountdetails.value.map_mode == "darkmode") {
      setState(() {
        maptype = MapType.normal;
        mapmode = MapMode.darkmode;
        newgooglemapcontroller!.setMapStyle(mapdarktheme);
      });
      print("DARKMODE");
    }
    if (authcontroller.useracountdetails.value.map_mode == "hybrid") {
      setState(() {
        maptype = MapType.hybrid;
        mapmode = MapMode.hybrid;
      });
    }
  }

  void mapTypeChange(MapMode value) async {
    print('MAP MODE');
    print(value);

    if (value == MapMode.normal) {
      setState(() {
        mapmode = value;
        maptype = MapType.normal;
        newgooglemapcontroller!.setMapStyle(null);
      });
    }
    if (value == MapMode.darkmode) {
      setState(() {
        mapmode = value;
        maptype = MapType.normal;
        newgooglemapcontroller!.setMapStyle(mapdarktheme);
      });
    }
    if (value == MapMode.satelite) {
      setState(() {
        mapmode = value;
        maptype = MapType.satellite;
      });
    }
    if (value == MapMode.hybrid) {
      setState(() {
        mapmode = value;
        maptype = MapType.hybrid;
      });
    }

    await authcontroller.updateMapOfUser(value.name);
  }

  var maprequestcontroller = Get.put(MapRequestController());
  Completer<GoogleMapController> googlemapcontrollercompleter = Completer();
  GoogleMapController? newgooglemapcontroller;
  Set<Marker> markerSet = {};
  Set<Polyline> polylineSet = {};
  Set<Circle> circleSet = {};
  Marker? pickupmarker;
  Marker? dropmarker;
  Circle? pickcircle;
  Circle? dropcircle;
  double mappadding = 0;
  CameraPosition? cameraPosition;

  Completer<GoogleMapController> _mapcontroller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GoogleMapController? _newgooglemapcontroller;

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    } // TODO: implement setState
  }

  @override
  void initState() {
    super.initState();
    setTripMarkers();
    setPolylines();
  }

  void setTripMarkers() async {
    pickupmarker = Marker(
      markerId: MarkerId("pickmarker"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      position: widget.request!.pick_location as LatLng,
    );

    dropmarker = Marker(
      markerId: MarkerId("dropmarker"),
      position: widget.request!.actualmarker_position as LatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    //circle

    pickcircle = Circle(
        zIndex: 1,
        fillColor: Colors.purpleAccent.withOpacity(0.5),
        center: widget.request!.pick_location as LatLng,
        strokeWidth: 1,
        radius: 15,
        strokeColor: Colors.purpleAccent,
        circleId: CircleId("pickcicrcle"));

    dropcircle = Circle(
        fillColor: Colors.redAccent.withOpacity(0.5),
        center: widget.request!.actualmarker_position as LatLng,
        strokeWidth: 1,
        radius: 15,
        strokeColor: Colors.redAccent,
        circleId: CircleId("dropcircle"));

    setState(() {
      markerSet.add(pickupmarker as Marker);
      markerSet.add(dropmarker as Marker);
      circleSet.add(pickcircle as Circle);
      circleSet.add(dropcircle as Circle);
    });
  }

  int _polylincecounter = 1;

  void setPolylines() async {
    print(maprequestcontroller.requestmapdetails.value.polylines_encoded);
    print(maprequestcontroller.requestmapdetails.value.bound_ne);
    print(maprequestcontroller.requestmapdetails.value.bound_sw);
    // if (maprequestcontroller.requestmapdetails.value.polylines_encoded != null) {
    String polylineIdVal = "polyline_id${_polylincecounter}";
    polylineSet.clear();
    setState(() {
      polylineSet.add(
        Polyline(
            polylineId: PolylineId(polylineIdVal),
            width: 6,
            jointType: JointType.mitered,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
            color: ELSA_GREEN,
            points: maprequestcontroller
                .requestmapdetails.value.polylines_encoded!
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList()),
      );
    });
  }

  void _caneraBoundRoute(LatLng bound_sw, LatLng bound_ne) {
    newgooglemapcontroller!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: bound_sw, northeast: bound_ne), 80));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: FaIcon(FontAwesomeIcons.times)),
        actions: [
          GestureDetector(
            onTap: () {
              MapDialog.showMapOption(context, mapTypeChange);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomLeft,
                    colors: [
                      LIGHT_CONTAINER,
                      LIGHT_CONTAINER2,
                    ],
                  )),
              margin: EdgeInsets.all(10),
              width: 35,
              child: Center(
                  child: FaIcon(
                FontAwesomeIcons.satellite,
                size: 20,
              )),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              padding: EdgeInsets.only(bottom: mappadding),
              initialCameraPosition: _kGooglePlex,
              mapType: maptype,
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

                  _caneraBoundRoute(
                      maprequestcontroller.requestmapdetails.value.bound_sw
                          as LatLng,
                      maprequestcontroller.requestmapdetails.value.bound_ne
                          as LatLng);
                }

                getCurrenMaptyoe();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Container(
                  color: BOTTOMNAVIGATOR_COLOR,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: Text('From')),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(containerRadius)),
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 14),
                                child: FaIcon(
                                  FontAwesomeIcons.mapMarkerAlt,
                                  color: ELSA_PINK,
                                )),
                            Horizontalspace(2),
                            Expanded(
                              child: Text(
                                '${widget.request!.pickaddress_name}',
                                style: Get.theme.textTheme.bodyText1!.copyWith(
                                  color: ELSA_TEXT_WHITE,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Verticalspace(8),
                                     Container(
                                              margin: EdgeInsets.only(left: 15),
                                              child: Text('To')),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(containerRadius)),
                        ),
                        child: Row(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 14),
                                child: FaIcon(
                                  FontAwesomeIcons.mapPin,
                                  color: ELSA_GREEN,
                                )),
                            Horizontalspace(2),
                            Expanded(
                              child: Text(
                                '${widget.request!.pickaddress_name}',
                                style: Get.theme.textTheme.bodyText1!.copyWith(
                                  color: ELSA_TEXT_WHITE,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
