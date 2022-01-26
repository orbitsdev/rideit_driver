import 'package:get/get.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/mapcontroller.dart';

class Getxbinding implements Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut(() => Authcontroller());
    Get.lazyPut(() => Mapcontroller()); 
  }

}