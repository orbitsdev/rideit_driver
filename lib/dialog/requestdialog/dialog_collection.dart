import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/model/ongoing_trip_details.dart';

class DialogCollection {
  static var requestcontroller = Get.find<Requestcontroller>();

  static void showpaymentToCollect(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: Obx(() {
              if (requestcontroller.collecting.value) {
                return Column(
                  children:[ Center(
                    child: CircularProgressIndicator(),
                  ),
                  
                  Text('collection,....')


                  ]);
              }
              return Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(
                  height: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('₱ 50'),
                    Text('To Be Collected'),
                    ElevatedButton(
                        onPressed: () {
                          requestcontroller.endTrip(requestcontroller
                              .ongoingtrip.value.request_id as String);
                        },
                        child: Text("CONFIRM"))
                  ],
                ),
              ]);
            }),
          );
        });
  }
}
