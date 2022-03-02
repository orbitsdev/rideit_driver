import 'package:flutter/foundation.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Directiondetails {

  LatLng? bound_ne;
  LatLng? bound_sw;
  LatLng? startlocation;
  LatLng? endlocation;
  String? polylines;
  List<PointLatLng>? polylines_encoded;
  String? distanceText;
  String? durationText;
  int? distanceValue;
  int? durationValue;
  
  Directiondetails({
    this.bound_ne,
    this.bound_sw,
    this.startlocation,
    this.endlocation,
    this.polylines,
    this.polylines_encoded,
    this.distanceText="",
    this.durationText="",
    this.distanceValue,
    this.durationValue,
  });



 factory Directiondetails.fromJason(Map<String,dynamic> json){


        var boundne = json['routes'][0]['bounds']['northeast'];
        var boundswe = json['routes'][0]['bounds']['southwest'];
        var startlocations = json['routes'][0]['legs'][0]['start_location'];
        var endlocation = json['routes'][0]['legs'][0]['end_location'];
        

       Directiondetails newdirectiondetails = Directiondetails();
        newdirectiondetails.bound_ne = LatLng(checkDouble(boundne['lat']) ,checkDouble( boundne['lng']));
        newdirectiondetails.bound_sw = LatLng(checkDouble(boundswe['lat']) , checkDouble( boundswe['lng']));
        newdirectiondetails.startlocation =  LatLng( checkDouble(startlocations['lat']) , checkDouble( startlocations['lng']));
        newdirectiondetails.endlocation =  LatLng(checkDouble(endlocation['lat']) , checkDouble(endlocation['lng']) );
        newdirectiondetails.polylines =  json['routes'][0]['overview_polyline']['points'];
        newdirectiondetails.polylines_encoded = PolylinePoints().decodePolyline( json['routes'][0]['overview_polyline']['points']);
        newdirectiondetails.distanceText =  json['routes'][0]['legs'][0]['distance']['text'];
        newdirectiondetails.distanceValue =json['routes'][0]['legs'][0]['distance']['value'];
        newdirectiondetails.durationText = json['routes'][0]['legs'][0]['duration']['text'];
        newdirectiondetails.durationValue = json['routes'][0]['legs'][0]['duration']['value'];

              return newdirectiondetails;

  }

  static double checkDouble(dynamic value) {
    if (value is String) {
      return double.parse(value);
    } else {
      return value;
    }
  }


}

