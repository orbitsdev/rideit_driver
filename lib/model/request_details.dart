import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestDetails {
  String? request_id;
  String? pick_location_id;
  String? drop_location_id;

  String? pickaddress_name;
  String? dropddress_name;

  String? passenger_name;
  String? passenger_phone;

  LatLng? pick_location;
  LatLng? drop_location;
  LatLng? actualmarker_position;

  String? status;
  String? tripstatus;
  String? created_at;
  String? device_token;

  

  RequestDetails({
    this.request_id,
    this.pick_location_id,
    this.drop_location_id,
    this.pickaddress_name,
    this.dropddress_name,
    this.passenger_name,
    this.passenger_phone,
    this.pick_location,
    this.drop_location,
    this.actualmarker_position,
    this.status,
    this.tripstatus,
    this.created_at,
    this.device_token,
  });

  factory RequestDetails.fromJson(Map<String, dynamic> json){

    LatLng picklocation = LatLng(json['pick_location']['latitude'], json['pick_location']['longitude']);
    LatLng droplocation = LatLng(json['drop_location']['latitude'], json['drop_location']['longitude']);
    LatLng actualmarker = LatLng(json['actualmarker_position']['latitude'], json['actualmarker_position']['longitude']);

    RequestDetails requestdetails = RequestDetails();
    requestdetails.request_id= json['request_id']; 
    requestdetails.pick_location_id= json['pick_location_id']; 
    requestdetails.drop_location_id= json['drop_location_id']; 
    requestdetails.pickaddress_name= json['pickaddress_name']; 
    requestdetails.dropddress_name= json['dropddress_name']; 
    requestdetails.passenger_name= json['passenger_name']; 
    requestdetails.passenger_phone= json['passenger_phone']; 
    requestdetails.pick_location= picklocation; 
    requestdetails.drop_location= droplocation; 
    requestdetails.actualmarker_position= actualmarker; 
    requestdetails.status= json['status']; 
    requestdetails.tripstatus= json['tripstatus']; 
    requestdetails.created_at= json['created_at']; 
    requestdetails.device_token = json['device_token'];

    return requestdetails;

    
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> picklocation = {
      "latitude": pick_location!.latitude,
      "longitude": pick_location!.longitude,
    };

    Map<String, dynamic> droplocation = {
      "latitude": drop_location!.latitude,
      "longitude": drop_location!.longitude,
    };

    Map<String, dynamic> actualdropmarker = {
      "latitude": actualmarker_position!.latitude,
      "longitude": actualmarker_position!.longitude,
    };

    return {
      "pick_location_id": pick_location_id,
      "drop_location_id": drop_location_id,
      "pick_location": picklocation,
      "drop_location": droplocation,
      "pickaddress_name": pickaddress_name,
      "dropddress_name": dropddress_name,
      "passenger_name": passenger_name,
      "passenger_phone": passenger_phone,
      "actualmarker_position": actualdropmarker,
      "status": status,
      'tripstatus': tripstatus,
      "created_at": created_at,
      'device_token': device_token
    };
  }
}
