  

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';


void showEarningDialog(){
   Get.defaultDialog(
              title: '',
              radius: 2,
              barrierDismissible: false,
              titlePadding: EdgeInsets.all(0),
              content:Completetripdialog() ,
      );
}
class Completetripdialog extends StatelessWidget {
  var requestxcontroller = Get.find<Requestcontroller>();
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
            color: Colors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  height: 12,
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('₱ 50'),
                      ElevatedButton(onPressed: () {
                        requestxcontroller.endTrip(requestxcontroller.tripdetails.value.triprequestid as String);
                        
                      }, child: Text("CONFIRM"))
                    ],
                  ),
                ),
              ]),
            )));
  }
}
