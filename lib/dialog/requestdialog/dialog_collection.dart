import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/model/ongoing_trip_details.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class DialogCollection {
  static var requestcontroller = Get.find<Requestcontroller>();

  static void showpaymentToCollect(BuildContext context) {
    showDialog(
    
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: BOTTOMNAVIGATOR_COLOR,
            child: 
              
              Container(
                decoration: BoxDecoration(
                color: BOTTOMNAVIGATOR_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(containerRadius))
                ),
                padding: EdgeInsets.all(20),

                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    height: 12,
                  ),
                  Text('amount to be payed'.toUpperCase(), style: Get.textTheme.bodyText1!.copyWith(color: ELSA_TEXT_WHITE, fontSize: 14, fontWeight: FontWeight.w100)),
                  Verticalspace(6),
                  Text('₱ 10.00', style: Get.textTheme.headline1!.copyWith(color: ELSA_TEXT_WHITE, fontSize: 34),),
                  Verticalspace(16),
                 // FaIcon(FontAwesomeIcons.moneyBill, color: Colors.amber[400], size: 34,),
              
                  ConfirmationSlider(
                    height: 60,
                    backgroundColor: LIGHT_CONTAINER,
                    foregroundColor: ELSA_BLUE_2_,
                    textStyle: TextStyle(color: Colors.white, fontSize: 16),
                    onConfirmation: () {
                    requestcontroller.endTrip(requestcontroller
                            .ongoingtrip.value.request_id as String, context);
                    },
                  ),
                ]),
              ),
            
          );
        });
  }
}
