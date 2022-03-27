import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tricycleappdriver/config/mapconfig.dart';
import 'package:tricycleappdriver/dialog/authdialog/authdialog.dart';
import 'package:tricycleappdriver/dialog/authdialog/authenticating.dart';
import 'package:tricycleappdriver/model/directiondetails.dart';
import 'package:tricycleappdriver/services/mapservices.dart';

class MapRequestController extends GetxController {


  static MapRequestController maprequestcontrooler =  Get.find();
  var requestmapdetails = Directiondetails().obs;
  String? requestdroplocatioinid;

 Future<bool> getDirection(BuildContext context, String pickuplocationid, String droplocationid,
      LatLng actularmarkerpostion) async {
     
        Authdialog.showAuthProGress(context, 'Getting Direction');
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:${pickuplocationid}&destination=${actularmarkerpostion.latitude},${actularmarkerpostion.longitude}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";
    //   String url =  "https://maps.googleapis.com/maps/api/directions/json?origin=place_id:${pickuplocationid}&destination=place_id:${droplocationid}&mode=walking&key=${Mapconfig.GOOGLEMAP_API_KEY}";
    //  var url = "https://maps.googleapis.com/maps/api/directions/json?origin=place_id=${pickuplocationid}&destinaion=place_id:${droplocationid}&mode=waking&key=${Mapconfig.GOOGLEMAP_API_KEY}";

    try {
      var response = await Mapservices.mapRequest(url);

      if (response != 'failed') {
        var newdirectiondetails = Directiondetails.fromJason(response);
        requestmapdetails(newdirectiondetails);
        requestdroplocatioinid = droplocationid;
    
   

        Get.back();
        return true;
      } else {

        Get.back();
        return false;
      }
    } catch (e) {


        Get.back();

      return false;
    }
  }

}


