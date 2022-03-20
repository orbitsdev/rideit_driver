import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/model/request_details.dart';
import 'package:tricycleappdriver/screens/map/map_request_controller.dart';

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
    
    if(mounted){
    super.setState(fn);

    }// TODO: implement setState
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

    dropmarker =   Marker(
      markerId: MarkerId("dropmarker"),
      position:widget.request!.actualmarker_position as LatLng,
       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    //circle

    pickcircle = Circle(
        zIndex: 1,
        fillColor: Colors.purpleAccent.withOpacity(0.5),
        center: widget.request!.pick_location as LatLng,
        strokeWidth: 1,
        radius: 26,
        strokeColor: Colors.purpleAccent,
        circleId: CircleId("pickcicrcle"));

    dropcircle = Circle(
        fillColor: Colors.redAccent.withOpacity(0.5),
        center:
            widget.request!.actualmarker_position as LatLng,
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
        leading: IconButton(onPressed: (){
            Get.back();
        }, icon: FaIcon(FontAwesomeIcons.times)),
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
                 newgooglemapcontroller!.setMapStyle(mapdarktheme);
               _caneraBoundRoute(
          maprequestcontroller.requestmapdetails.value.bound_sw as LatLng,
          maprequestcontroller.requestmapdetails.value.bound_ne as LatLng);

              }
            },
          ),
      
    );
      
    
  }
}