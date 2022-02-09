import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleappdriver/controller/mapcontroller.dart';

class HomeScreen extends StatefulWidget {
  static const screenName ="/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var mapxcontroller = Get.find<Mapcontroller>();
  Completer<GoogleMapController> _googlemapcontroller = Completer();
  GoogleMapController? _newgooglemapcontroller;
  Position? currentposition;
  CameraPosition? cameraposition;
  bool isMapReady = false;
  bool isOnline = false;


@override
  void setState(VoidCallback fn) {
    if(mounted){

    super.setState(fn);
    }
    // TODO: implement setState
  }
  


  void setIsOnline(bool value) {
    setState(() {
      isOnline = value;
    });
  }

  void setMapIsReady(bool value) {
    setState(() {
      isMapReady = value;
    });
  }

  void setInitialMapCameraPosition() async {
    bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

    // setMapIsReady(false);


    // LocationPermission permission;
    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.deniedForever) {
    //     return Future.error('Location Not Available');
    //   }
    // } else {
    //   throw Exception('Error');
    // } 

  

    var getcurrentposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    String? currentpositonvalue;
    cameraposition = CameraPosition(
        target: LatLng(
          getcurrentposition.latitude,
          getcurrentposition.longitude,
        ),
        zoom: 14);
    //setMapIsReady(true);

    currentpositonvalue = currentposition.toString();

    if (currentpositonvalue.isEmpty || currentpositonvalue == '') {
      setMapIsReady(false);
    } else {
      setMapIsReady(true);
    }
  }

  void makeDriverOnlineAndOffline() {
    //mapxcontroller.makeDriverOnline();
    if (mapxcontroller.isOnline.value != true) {
      mapxcontroller.makeDriverOnline();
     mapxcontroller.liveUpdateLocation();
    } else {
     mapxcontroller.makeDriverOffline();
    }
  }

  @override
  void initState() {
    setInitialMapCameraPosition();
    super.initState();
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    currentposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng position =
        LatLng(currentposition!.latitude, currentposition!.longitude);
    cameraposition = CameraPosition(target: position);
    _newgooglemapcontroller!.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 16.500)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isMapReady == false
            ? Expanded(
                child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ))
            : Expanded(
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    GoogleMap(
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        mapType: MapType.hybrid,
                        zoomControlsEnabled: true,
                        zoomGesturesEnabled: true,
                        initialCameraPosition: cameraposition as CameraPosition,
                        onMapCreated: (GoogleMapController mapcontroller) {

                          if (!_googlemapcontroller.isCompleted) {
                      _googlemapcontroller.complete(mapcontroller);
                      _newgooglemapcontroller = mapcontroller;
                        _determinePosition();
                     
                    }
                          // _googlemapcontroller.complete(mapcontroller);
                          
                        
                        }),
                    Positioned(
                      top: 0,
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                        ),
                        child: Center(
                          child: Obx(() {
                            return Container(
                              decoration: BoxDecoration(
                                color: mapxcontroller.isOnline.value
                                    ? Colors.green
                                    : Colors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              // ignore: prefer_const_constructors

                              child: Material(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.transparent,
                                  child: InkWell(
                                      onTap: () {
                                        makeDriverOnlineAndOffline();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: mapxcontroller
                                                .isOnlineLoading.value
                                            ? SizedBox(
                                                width: 15,
                                                height: 15,
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                )))
                                            : Text(
                                                mapxcontroller.isOnline.value
                                                    ? ' Online'
                                                    : 'Offline-',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ))),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
