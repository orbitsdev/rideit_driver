import 'package:google_maps_flutter/google_maps_flutter.dart';

class RequestDetails {


  String? requestid;
  String? name;
  String? phone;
  String? picklocationid;
  String? droplocationid;
  LatLng? picklocation;
  LatLng? droplocation;
  String? pickaddressname;
  String? dropaddressname;
  String? status;

  
  RequestDetails({
    this.requestid,
    this.name,
    this.phone,
    this.picklocationid,
    this.droplocationid,
    this.picklocation,
    this.droplocation,
    this.pickaddressname,
    this.dropaddressname,
    this.status,
  });



}
