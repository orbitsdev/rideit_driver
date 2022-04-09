import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:tricycleappdriver/UI/constant.dart';

import 'package:tricycleappdriver/controller/requestdatacontroller.dart';
import 'package:tricycleappdriver/model/ongoing_trip_details.dart';
import 'package:tricycleappdriver/widgets/horizontalspace.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class DialogCollection {
  static var requestcontroller = Get.find<Requestdatacontroller>();

  static void showpaymentToCollect(BuildContext context, String? payment) {
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
                  Text('Total amount to collect'.toUpperCase(), style: Get.textTheme.bodyText1!.copyWith(color: ELSA_TEXT_WHITE, fontSize: 14, fontWeight: FontWeight.w100)),
                  Verticalspace(6),
                  Text('₱ ${payment}.00', style: Get.textTheme.headline1!.copyWith(color: ELSA_TEXT_WHITE, fontSize: 34),),
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

  static void showCancelCOnfirmaation(BuildContext context) {
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
              padding: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Verticalspace(12),
                    Text(
                      'Are you sure do you want to cancel the trip?',
                      style: Get.textTheme.headline1!.copyWith(
                        color: ELSA_TEXT_WHITE,
                        fontWeight: FontWeight.w600
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Verticalspace(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        height: 50,
                        decoration: const ShapeDecoration(
                          shape: StadiumBorder(),
                          gradient: LinearGradient(
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                            colors: [
                              ELSA_BLUE_1_,
                              ELSA_BLUE_1_,
                            ],
                          ),
                        ),
                        child: MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: const StadiumBorder(),
                          child: Text('Yes',
                              style: Get.textTheme.bodyText1!
                                  .copyWith(fontWeight: FontWeight.w400)),
                          onPressed: () async {

                            
                              Get.find<Requestdatacontroller>().cancelOngoingTrip(requestcontroller.ongoingtrip.value.request_id as String, context);
                          },
                        ),
                      ),
                    

                      Horizontalspace(10),
                      Container(
                        height: 50,
                        decoration: const ShapeDecoration(
                          shape: StadiumBorder(),
                          gradient: LinearGradient(
                            end: Alignment.bottomCenter,
                            begin: Alignment.topCenter,
                            colors: [
                              ELSA_BLUE_1_,
                              ELSA_BLUE_1_,
                            ],
                          ),
                        ),
                        child: MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: const StadiumBorder(),
                          child: Text('No',
                              style: Get.textTheme.bodyText1!
                                  .copyWith(fontWeight: FontWeight.w400)),
                          onPressed: () async {
                           Get.back();
                          },
                        ),
                      ),
                    ]),
                  ]),
            ),
          );
        });
  }

  
}
