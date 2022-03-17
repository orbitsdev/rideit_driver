import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';

import 'package:tricycleappdriver/model/ongoing_trip_details.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class TripdetailsScreen extends StatelessWidget {
  static const screenName = "/pastriprecordetailsscreen";

  OngoingTripDetails? trip;
  TripdetailsScreen({
    Key? key,
    this.trip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: FaIcon(FontAwesomeIcons.times)),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
             columnBuilder('Name', '${trip!.passenger_name}'),
             Verticalspace(12),
             columnBuilder('Phone', '${trip!.driver_phone}'),
             Verticalspace(12),
            seperator(),
             columnBuilder('Pickup address', '${trip!.pickaddress_name}'),
             Verticalspace(12),
             columnBuilder('Drop address', '${trip!.dropddress_name}'),
             Verticalspace(12),
             seperator(),
             columnBuilder('Total Amount Collected', '${trip!.payedamount}'),
             Verticalspace(12),
             columnBuilder('Trip Status', '${trip!.tripstatus}'),
             Verticalspace(12),
             columnBuilder('Date', '${trip!.created_at}'),
             Verticalspace(12),
             
            ],
          ),
        ),
      ),
    );
  }

  Widget seperator(){
    return  Divider(
               height: 1,
               color: ELSA_DARK_LIGHT_TEXT,
             );
  }
  Widget columnBuilder(String title, String subtitle){
    return  Column(
        mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${title}',  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),),
                  Text('${subtitle}',  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w100)),
                ],
              );
  }
}
