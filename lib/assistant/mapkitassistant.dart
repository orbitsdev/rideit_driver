import 'package:maps_toolkit/maps_toolkit.dart'as toolkit;

class Mapkitassistant {

static double getMarkerRotation(fromlat, fromlong, tolat, tolong){

  var rot = toolkit.SphericalUtil.computeHeading(toolkit.LatLng(fromlat,fromlong), toolkit.LatLng(fromlat,fromlong));
  return rot as double;
}
}