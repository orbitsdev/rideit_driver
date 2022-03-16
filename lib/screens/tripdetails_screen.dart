import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:tricycleappdriver/model/ongoing_trip_details.dart';

class TripdetailsScreen extends StatelessWidget {

  static const screenName = "/pastriprecordetailsscreen";

OngoingTripDetails? trip;
  TripdetailsScreen({
    Key? key,
    this.trip,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
                Get.back();
          }, icon: FaIcon(FontAwesomeIcons.times)),
        ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Text('${trip!.tripstatus}'),
                Text('${trip!.payed}'),
                Text('${trip!.payedamount}'),
                Text('${trip!.pickaddress_name}'),
                Text('${trip!.dropddress_name}'),
                Text('${trip!.pick_location}'),
                Text('${trip!.drop_location}'),
                Text('${trip!.driver_name}'),
                Text('${trip!.driver_phone}'),
                Text('${trip!.created_at}'),
            ],
          ),
        ),
      ),
    );
  }
}
