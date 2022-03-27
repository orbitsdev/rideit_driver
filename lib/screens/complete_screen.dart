import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tricycleappdriver/controller/requestdatacontroller.dart';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({ Key? key }) : super(key: key);
  static const screenName = "/completescreen";

  @override
  _CompleteScreenState createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {

  var requestxcontroller = Get.find<Requestdatacontroller>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        SizedBox(
          height: 12,
        ),
        Container(
          color: Colors.red,
          width: double.infinity,
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('₱ 50'),
              Text('To Be Collected'),
              ElevatedButton(onPressed: () {
                requestxcontroller.endTrip(requestxcontroller.ongoingtrip.value.request_id as String,context);
                
              }, child: Text("CONFIRM"))
            ],
          ),
        ),
      ]),
    );
  }
}