import 'package:google_maps_flutter/google_maps_flutter.dart';

class UnAcceptedRequest {

String? request_id;
String? picklocation_name;
String? droplocation_name;
LatLng? pick_location;
LatLng? drop_location;


  UnAcceptedRequest({
    this.request_id,
    this.picklocation_name,
    this.droplocation_name,
    this.pick_location,
    this.drop_location,
  });




  factory UnAcceptedRequest.fromJson(Map<String, dynamic> json) {

    LatLng picklocation = LatLng(checkDouble(json['pick_location']['latitude']),  checkDouble(json['pick_location']['longitude'] ));
    LatLng droplocation = LatLng(checkDouble(json['drop_location']['latitude']),  checkDouble(json['drop_location']['longitude'] ));
    UnAcceptedRequest request = UnAcceptedRequest();
    request.request_id = json['request_id'];
    request.picklocation_name = json['picklocation_name'];
    request.droplocation_name = json['droplocation_name'];
    request.pick_location = picklocation;
    request.drop_location = droplocation;

    return request;
    
  }

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value;
    }
  }
}
