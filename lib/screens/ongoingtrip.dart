import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/assistant/mapkitassistant.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/requestdatacontroller.dart';
import 'package:tricycleappdriver/dialog/authdialog/authdialog.dart';
import 'package:tricycleappdriver/dialog/mapdialog/map_dialog.dart';
import 'package:tricycleappdriver/dialog/requestdialog/dialog_collection.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/screens/map/request_map_screen.dart';
import 'package:tricycleappdriver/widgets/horizontalspace.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class Ongoingtrip extends StatefulWidget {
  const Ongoingtrip({Key? key}) : super(key: key);
  static const String screenName = "/ongointrip";
  @override
  _OngoingtripState createState() => _OngoingtripState();
}

class _OngoingtripState extends State<Ongoingtrip> {

    var authcontroller = Get.find<Authcontroller>();

  MapMode mapmode = MapMode.hybrid;
  MapType maptype = MapType.hybrid;

void getCurrenMaptyoe() {
   

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
   
    }
    if (authcontroller.useracountdetails.value.map_mode == "hybrid") {
      setState(() {
        maptype = MapType.hybrid;
        mapmode = MapMode.hybrid;
      });
    }
  }

  void mapTypeChange(MapMode value) async {
    

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

  var requestxcontroller = Get.find<Requestdatacontroller>();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? newgooglemapcontroller;
  
  

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  Marker? startingMrker;
  Marker? destinationMarker;
  Marker? driverMarker;
  Circle? startingCircle;
  Circle? destinationCircle;
  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  Set<Polyline> polylineSet = {};
  LatLng? driverpostion;
    BitmapDescriptor? drivermarkericon;


  bool isMapReady = false;
  bool hastrip = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value){
      listenToOngoingTrip();
    });
    super.initState();

  }


  
  void setSuccesMap() {
    setState(() {
      isMapReady = true;
      hastrip = true;
    });
  }

  void setFailedMap() {
    setState(() {
      isMapReady = true;
      hastrip = false;
    });
  }

  void listenToOngoingTrip() async {
    var response = await requestxcontroller.checkOngoingTripDetails(context);

    if (response) {
      print('FROM INITSTATE');
      print(requestxcontroller.ongoingtrip.value.tripstatus);
   setSuccesMap();
   setMarker();
   setPolyline();
    if(requestxcontroller.ongoingtrip.value.tripstatus == "coming" || requestxcontroller.ongoingtrip.value.tripstatus == "travelling"){
           await updatePolyline();
           getLiveLocationUpdate();
        }
    } else {
     setFailedMap();
    }
  }


  void setMarker(){

  startingMrker = Marker(
    markerId: MarkerId('startingmarker'),
    position: requestxcontroller.ongoingtrip.value.pick_location as LatLng,
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
  );
 destinationMarker = Marker(
    markerId: MarkerId('destinationmarker'),
    position: requestxcontroller.ongoingtrip.value.actualmarker_position as LatLng,
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  );

  startingCircle =  Circle(
        zIndex: 1,
        fillColor: Colors.purpleAccent.withOpacity(0.5),
        center: requestxcontroller.ongoingtrip.value.pick_location as LatLng,
        strokeWidth: 1,
        radius: 15,
        strokeColor: Colors.purpleAccent,
        circleId: CircleId("startingcircle"));

 


  destinationCircle =  Circle(
        fillColor: Colors.redAccent.withOpacity(0.5),
        center:   requestxcontroller.ongoingtrip.value.actualmarker_position as LatLng,
        strokeWidth: 1,
        radius: 15,
        strokeColor: Colors.redAccent,
        circleId: CircleId("destination"));

    
    setState(() {
      markerSet.add(startingMrker as Marker);
      markerSet.add(destinationMarker as Marker);
      circleSet.add(startingCircle as Circle);
      circleSet.add(destinationCircle as Circle);

    });

}



int _polylincecounter = 1;

  void setPolyline(){
    if (requestxcontroller.directiondetails.value.polylines_encoded != null) {

      String polylineIdVal = "polyline_id${_polylincecounter}";
      setState(() {
        
      polylineSet.clear();
      polylineSet.add(
        Polyline(
            polylineId: PolylineId(polylineIdVal),
            width: 6,
            jointType: JointType.mitered,
            endCap: Cap.roundCap,
            startCap: Cap.roundCap,
            color: ELSA_GREEN,
            points: requestxcontroller.directiondetails.value.polylines_encoded!
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList()),
      );
      });
      

     
    }
  }

  void _caneraBoundRoute(LatLng? bound_sw, LatLng? bound_ne) {

   
    try {
      newgooglemapcontroller!.animateCamera(CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: bound_sw as LatLng, northeast: bound_ne as LatLng),
          80));
    } catch (e) {
    }
  }


  void updateTripStaus(BuildContext context) async{

    var response = await requestxcontroller.updateTripStaus(context);
      if(response != "check"){
        print('______________________________hdhashdhasdas');
        print(requestxcontroller.ongoingtrip.value.tripstatus);
        print('_______________________');
        print(requestxcontroller.ongoingtrip.value.tripstatus);
        /// If coming and travelling upte driver location live so that passenger will know where is the driver is
        if(response == "coming" || response == "travelling"){
           await updatePolyline();
           getLiveLocationUpdate();
        }
        /// show payment 
         if (requestxcontroller.ongoingtrip.value.tripstatus == 'complete' &&
          requestxcontroller.ongoingtrip.value.payed == false) {
            DialogCollection.showpaymentToCollect(context, requestxcontroller.ongoingtrip.value.fee.toString(),requestxcontroller.ongoingtrip.value.request_id);
          }
        


      }else{
         /// incase the app close and passenger not payed show payment againg
        if (requestxcontroller.ongoingtrip.value.tripstatus == 'complete' &&
          requestxcontroller.ongoingtrip.value.payed == false) {
            DialogCollection.showpaymentToCollect(context,requestxcontroller.ongoingtrip.value.fee.toString(),requestxcontroller.ongoingtrip.value.request_id);
        }
         if (requestxcontroller.ongoingtrip.value.tripstatus == 'complete' &&
          requestxcontroller.ongoingtrip.value.payed == true) {
            Authdialog.showAuthProGress('Please wait...');
            await requestxcontroller.deleteAcceptedRequest(requestxcontroller.ongoingtrip.value.request_id as String);
            Get.back();
            Get.offAll(HomeScreenManager());
          }

      }
  }

  Future<void> updatePolyline() async{
     setPolyline();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  

void createCustomDriverMarker() {
    ImageConfiguration imageconfiguation =
        createLocalImageConfiguration(context, size: Size(2, 2));
    BitmapDescriptor.fromAssetImage(
            imageconfiguation, "assets/images/Motorcycle_8.png")
        .then((value) => drivermarkericon = value);
  }
 void getLiveLocationUpdate() {
   
    LatLng oldpostion = LatLng(0, 0);

    driverlocationstream = Geolocator.getPositionStream().listen((Position position) async {
        

        LatLng driverpositionlat = LatLng(position.latitude, position.longitude);

    
        var rot = Mapkitassistant.getMarkerRotation(
          oldpostion.latitude,
          oldpostion.longitude,
          driverpositionlat.latitude,
          driverpositionlat.longitude);
          
          Marker movingDriverMarker = Marker(
        markerId: MarkerId("drivermarker"),
        position: driverpositionlat,
        rotation: rot,
        anchor: Offset(0.5, 0.5),
        icon: drivermarkericon as BitmapDescriptor,
        infoWindow: InfoWindow(title: "current Location"),

        
        
      );
        setState(() {
             CameraPosition camerapostion =
            CameraPosition(target: driverpositionlat, zoom: 17);  newgooglemapcontroller!
            .animateCamera(CameraUpdate.newCameraPosition(camerapostion));

        markerSet.removeWhere((marker) => marker.markerId.value == "drivermarker");
        markerSet.add(movingDriverMarker);
        });


        oldpostion = driverpositionlat;
          requestxcontroller.updateDriverTripPosition(driverpositionlat, requestxcontroller.ongoingtrip.value.request_id as String);

      

    });
  }

  @override
  Widget build(BuildContext context) {
     createCustomDriverMarker();
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(onPressed: () {
              Get.off(()=> HomeScreenManager());
            }, icon: FaIcon(FontAwesomeIcons.times)),
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
      body: isMapReady == false
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: ELSA_BLUE_2_,
                ),
              ),
            )
          : hastrip == false
              ? Container(
                  child: Center(
                    child: Text('No data', style: TextStyle(color: Colors.red)),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          GoogleMap(
                            mapType: maptype,
                            initialCameraPosition: _kGooglePlex,
                            myLocationButtonEnabled: true,
                            myLocationEnabled: true,
                            zoomControlsEnabled: true,
                            zoomGesturesEnabled: true,
                            markers: markerSet,
                            polylines: polylineSet,
                            circles: circleSet,
                            onMapCreated: (GoogleMapController controller) {
                              if (!_controller.isCompleted){

                                _controller.complete(controller);
                              newgooglemapcontroller = controller;
                              newgooglemapcontroller!.setMapStyle(mapdarktheme);
                               _caneraBoundRoute(requestxcontroller.directiondetails.value.bound_sw,
                                 requestxcontroller.directiondetails.value.bound_ne);
                              }
                              getCurrenMaptyoe();
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      constraints:
                          BoxConstraints(minHeight: 200, maxHeight: 300),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                                colors: [
                                  BACKGROUND_TOP,
                                  BACKGROUND_CEENTER,
                                  BACKGROUND_BOTTOM,
                                ],
                                end: Alignment.bottomCenter,
                                begin: Alignment.topCenter,
                              ),
                              
                      ),
                      child: SingleChildScrollView(
                          child: Obx((){
                            return Column(
                        children: [
                         
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: LIGHT_CONTAINER,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'From',
                                  style: Get.textTheme.bodyText1!
                                      .copyWith(fontWeight: FontWeight.w100),
                                ),
                                Horizontalspace(8),
                                Flexible(
                                    child: Text(requestxcontroller.ongoingtrip.value.tripstatus == 'coming'? 'Your Current Location ' :
                                  '${requestxcontroller.ongoingtrip.value.pickaddress_name}',
                                  textAlign: TextAlign.right,
                                )),
                              ],
                            ),
                          ),
                          Verticalspace(8),
                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical: 1,
                            ),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: LIGHT_CONTAINER,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'To',
                                  style: Get.textTheme.bodyText1!
                                      .copyWith(fontWeight: FontWeight.w100),
                                ),
                                Horizontalspace(8),
                                Flexible(
                                    child: Text(requestxcontroller.ongoingtrip.value.tripstatus == 'coming'? '${requestxcontroller.ongoingtrip.value.pickaddress_name}' :
                                  '${requestxcontroller.ongoingtrip.value.dropddress_name}',
                                  textAlign: TextAlign.right,
                                )),
                              ],
                            ),
                          ),
                          Verticalspace(8),
                          Container(
                           
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            child: Center(
                              child: Text(
                                requestxcontroller.ongoingtrip.value.tripstatus == "prepairing"
                                          ? 'Click the button if you are ready'.toUpperCase()
                                          :requestxcontroller.ongoingtrip.value.tripstatus == "coming"
                                          ?'Click the button if you arrived'.toUpperCase()
                                          :requestxcontroller.ongoingtrip.value.tripstatus == "arrived"
                                          ? 'Click the button to start trip'.toUpperCase()
                                          :requestxcontroller.ongoingtrip.value.tripstatus == "travelling"
                              
                                          ?'Click the button to end trip'.toUpperCase()
                                          :requestxcontroller.ongoingtrip.value.tripstatus == "complete"
                                          ?'Cick the button to show fee'.toUpperCase()
                                          :'Cick the button '.toUpperCase(),
                                style: Get.textTheme.bodyText1!
                                    .copyWith(color: ELSA_TEXT_GREY),
                              ),
                            ),
                          ),
                          Verticalspace(12),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              if(requestxcontroller.ongoingtrip.value.tripstatus != "complete")
                              Container(
                                      

                                            height: 50,
                                        decoration: const ShapeDecoration(
                                          shape: StadiumBorder(),
                                          gradient: LinearGradient(
                                            end: Alignment.bottomCenter,
                                            begin: Alignment.topCenter,
                                            colors: [
                                                ELSA_PINK,
                                                PINK_1  ,
                                            ],
                                          ),
                                        ),
                                        child: MaterialButton(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: const StadiumBorder(),
                                          child:  Text(
                                            'CANCEL '
                                           ,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () async{
                                              Authdialog.showConfirmationDialog(context, 'Are you sure do you want to cancel the trip ?', cancelTrip );
                                          },  
                                        ),
                                      ),
                                
                                if(requestxcontroller.ongoingtrip.value.tripstatus != "complete")
                                Horizontalspace(24),
                              
                                Expanded(
                                  child: requestxcontroller.updating.value?Container(
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: ELSA_BLUE_2_,
                                      ),
                                    ),
                                  ) : Container(
                                        
                                       
                                            height: 50,
                                        decoration: const ShapeDecoration(
                                          shape: StadiumBorder(),
                                          gradient: LinearGradient(
                                            end: Alignment.bottomCenter,
                                            begin: Alignment.topCenter,
                                            colors: [
                                                ELSA_BLUE_2_,
                                                ELSA_BLUE_1_,
                                            ],
                                          ),
                                        ),
                                        child: MaterialButton(
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          shape: const StadiumBorder(),
                                          child:  Text(
                                            requestxcontroller.ongoingtrip.value.tripstatus == "prepairing"
                                          ? 'ready'.toUpperCase()
                                          :requestxcontroller.ongoingtrip.value.tripstatus == "coming"
                                          ?'Arrived'.toUpperCase()
                                          :requestxcontroller.ongoingtrip.value.tripstatus == "arrived"
                                          ? 'LET\'s go'.toUpperCase()
                                          :requestxcontroller.ongoingtrip.value.tripstatus == "travelling"
                                          ?'End Trip'.toUpperCase()
                                          :'Check'.toUpperCase()
                                           ,
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 20),
                                          ),
                                          onPressed: () async{
                                              updateTripStaus(context);
                                          },  
                                        ),
                                      ),
                                )
                              ],
                            ),
                          ),
                          // ElevatedButton(onPressed: (){
                          //     Authdialog.showAuthProGress(context,'DASDAS');
                          // }, child: Text('test')),
                          Verticalspace(12),
                        ],
                            );
                          }), 
                    ),)
                  ],
                ),
    );
  }

  void cancelTrip() {
    requestxcontroller.cancelOngoingTrip(requestxcontroller.ongoingtrip.value.request_id as String, context);
  }
}
