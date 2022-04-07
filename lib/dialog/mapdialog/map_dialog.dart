import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/dialog/mapdialog/maptype_builder.dart';
import 'package:tricycleappdriver/screens/map/request_map_screen.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class MapDialog {

 static void showMapOption(BuildContext context, Function changeMapType) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: BOTTOMNAVIGATOR_COLOR,
            child: Container(
              decoration: BoxDecoration(
                  color: BOTTOMNAVIGATOR_COLOR,
                  borderRadius:
                      BorderRadius.all(Radius.circular(containerRadius))),
              padding:EdgeInsets.symmetric(vertical: 16,),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [   

                    Text(
                      'Select Map Type',
                      style: Get.textTheme.bodyText1!.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Verticalspace(12),                    
                    Wrap(
                      children: [

                       GestureDetector(
                         onTap: (){
                            changeMapType(MapMode.hybrid);
                            Get.back();
                         },
                         child: MaptypeBuilder(name: 'Hybrid', image: 'assets/images/138621.png')
                         ),

                       GestureDetector(
                         onTap: (){
                            changeMapType(MapMode.satelite);
                            Get.back();
                         },
                         child: MaptypeBuilder(name: 'Satilite', image: 'assets/images/flutter-google-maps31.png',)
                         ),
                     
                      
                      
                       GestureDetector(
                         onTap: (){
                            changeMapType(MapMode.darkmode);
                            Get.back();
                         },
                         child: MaptypeBuilder(name: 'Darkmode', image: 'assets/images/darkmode.png',)
                         ),
                     
                       GestureDetector(
                         onTap: (){
                            changeMapType(MapMode.normal);
                            Get.back();
                         },
                         child: MaptypeBuilder(name: 'Normal', image: 'assets/images/normalmap.png',)
                         ),

                      ],
                    ),

                  ]),
            ),
          );
        });
  }
}