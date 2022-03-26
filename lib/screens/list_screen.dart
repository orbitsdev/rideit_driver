import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tricycleappdriver/UI/constant.dart';

import 'package:tricycleappdriver/model/ongoing_trip_details.dart';
import 'package:tricycleappdriver/screens/tripdetails_screen.dart';
import 'package:tricycleappdriver/widgets/tripwidget/listcontainer.dart';

class ListScreen extends StatelessWidget {
  static const screenName = "/listscren";

  List<OngoingTripDetails>? collection;
  ListScreen({
    Key? key,
    this.collection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       leading: IconButton(onPressed: (){
         Get.back();
       }, icon: FaIcon(FontAwesomeIcons.arrowLeft)),
      ),
      body:  Container(
        margin: EdgeInsets.only(top: 20),
        child: AnimationLimiter(
          child: ListView.builder(
          shrinkWrap: true,
          itemCount: collection!.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: FadeInAnimation(
              //verticalOffset: 50.0,
              child: ScaleAnimation(
                child:  Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      Get.to(
                          () => TripdetailsScreen(
                                trip: collection![index],
                              ),
                          fullscreenDialog: true,transition: Transition.zoom);
                    },
                    child: Listcontainer(
                        status: '${collection![index].tripstatus}',
                        statuscolor: ELSA_GREEN,
                        picklocation: '${collection![index].pickaddress_name}',
                        droplocation: '${collection![index].dropddress_name}',
                        date:   DateFormat.yMMMMd().format(DateTime.parse('${collection![index].created_at}')) ))),
              ),
            ),
          );
            
            //
          }),
        ),
      ),
    );
  }
}
