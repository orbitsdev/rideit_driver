import 'package:get/get.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/mapcontroller.dart';
import 'package:tricycleappdriver/controller/pageindexcontroller.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';

class Getxbinding implements Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut(() => Authcontroller());
    Get.lazyPut(() => Mapcontroller()); 
    Get.lazyPut(() => Requestcontroller()); 
    Get.lazyPut(() => Pageindexcontroller()  ) ; 
    Get.lazyPut(() => Drivercontroller()  ) ; 
  }

}