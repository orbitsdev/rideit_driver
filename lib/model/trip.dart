import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Trip {

  String? driver_id; 
  String? passenger_id;
  LatLng? pickuplocation;
  String? pickuplocation_name;
  String? dropplocation_name; 
  LatLng? destination;
  String? earn;
  String? fees;
  String? tripstatus;
  String? date;

  Trip({
    this.driver_id,
    this.passenger_id,
    this.pickuplocation,
    this.pickuplocation_name,
    this.dropplocation_name,
    this.destination,
    this.earn,
    this.fees,
    this.tripstatus,
    this.date,
  });
  
 factory Trip.fromMap(DocumentSnapshot query){   
   
   var data =  query.data() as Map<String, dynamic>;

  //  Map<String, dynamic> picklocation = {
  //   "latitude": double.parse(data["pickuplocation"]["latitude"]) ,
  //   "longitude": double.parse(data["pickuplocation"]["longitude"]) ,
  //  };

  //  Map<String, dynamic> droplocation = {
  //   "latitude":  double.parse(data["destination"]["latitude"]) ,
  //   "longitude": double.parse(data["destination"]["longitude"]) ,
  //  };
   
   LatLng picklocation = LatLng(double.parse( data["pickuplocation"]["latitude"]), double.parse( data["pickuplocation"]["longitude"]));
   LatLng droplocation = LatLng(double.parse(data["destination"]["latitude"]) ,double.parse(data["destination"]["longitude"])  );

  var newtrips = Trip();  
  newtrips.driver_id= data["driver_id"]; 
  newtrips.passenger_id= data["passenger_id"];
  newtrips.pickuplocation= picklocation as LatLng;
  newtrips.pickuplocation_name= data["dropplocation_name"];
  newtrips.dropplocation_name= data["dropplocation_name"]; 
  newtrips.destination=droplocation  as LatLng;
  newtrips.earn=  data["earn"].toString();
  newtrips.fees= data["fees"].toString();
  newtrips.tripstatus= data["tripstatus"];
  newtrips.date= data["date"];

  return newtrips;
   
 }
  }
