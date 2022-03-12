import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleappdriver/screens/map/map_request_controller.dart';

class RequestMapScreen extends StatefulWidget {
  
  
  static const String screenName = "/requestmap";
  @override
  _RequestMapScreenState createState() => _RequestMapScreenState();
}

class _RequestMapScreenState extends State<RequestMapScreen> {

var maprequestcontroller = Get.put(MapRequestController());
  Completer<GoogleMapController> googlemapcontrollercompleter = Completer();
  GoogleMapController? newgooglemapcontroller;
  Set<Marker> markerSet = {};
  Set<Polyline> polylineSet = {};
  Set<Circle> circleSet = {};
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
    
    if(mounted){
    super.setState(fn);

    }// TODO: implement setState
  }
@override
  void initState() {
    super.initState();
   setPolylines();
     

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
            color: Colors.deepPurple,
            points: maprequestcontroller.requestmapdetails.value.polylines_encoded!
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList()),
      );
      });
     

    

     
      
    
  }
void _caneraBoundRoute(LatLng bound_sw, LatLng bound_ne) {
    newgooglemapcontroller!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(southwest: bound_sw, northeast: bound_ne), 50));
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body:  GoogleMap(
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
               _caneraBoundRoute(
          maprequestcontroller.requestmapdetails.value.bound_sw as LatLng,
          maprequestcontroller.requestmapdetails.value.bound_ne as LatLng);

              }
            },
          ),
      
    );
      
    
  }
}