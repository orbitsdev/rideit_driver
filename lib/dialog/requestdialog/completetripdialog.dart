  

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
  static const screenName = '/completedialog';
  var requestxcontroller = Get.put(Requestcontroller());
  @override
  Widget build(BuildContext context) {
    return Container(
          color: Colors.white,

          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                height: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('₱ 50'),
                  Text('To Be Collected'),
                  ElevatedButton(onPressed: () {
                    requestxcontroller.endTrip(requestxcontroller.ongoingtrip.value.request_id as String);
                    
                  }, child: Text("CONFIRM"))
                ],
              ),
            ]),
          ));
  }
}
