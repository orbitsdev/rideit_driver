import 'package:get/get.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/mapcontroller.dart';
import 'package:tricycleappdriver/controller/pageindexcontroller.dart';
import 'package:tricycleappdriver/controller/permissioncontroller.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/controller/requestdatacontroller.dart';
import 'package:tricycleappdriver/controller/tripcontroller.dart';
import 'package:tricycleappdriver/screens/map/map_request_controller.dart';

class Getxbinding implements Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut(() => Authcontroller());
    Get.lazyPut(() => Mapcontroller()); 
    Get.lazyPut(() => Requestcontroller()); 
    Get.lazyPut(() => Pageindexcontroller()  ) ; 
    Get.lazyPut(() => Drivercontroller()  ) ; 
    Get.lazyPut(() => Tripcontroller()  ) ; 
    Get.lazyPut(() => Permissioncontroller()  ) ; 
    Get.lazyPut(() => MapRequestController()  ) ; 
    Get.lazyPut(() => Requestdatacontroller()  ) ; 
 
  }

}