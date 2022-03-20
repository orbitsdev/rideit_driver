import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

import '../../widgets/elsabutton.dart';

class InfoDialog {
  static void noDataDialog(BuildContext context, String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(15),
            backgroundColor: Colors.transparent,
            child: Container(

                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: const BoxDecoration(
                  color: colorwhite,
                  borderRadius:
                      BorderRadius.all(Radius.circular(containerRadius)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          message, style: TextStyle(fontSize: 14, color: LIGHT_CONTAINER, fontWeight: FontWeight.w300),),
                          Verticalspace(8),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        width: double.infinity,
                        height: 40,
                        decoration: const ShapeDecoration(
                          shape: StadiumBorder(),
                          color: ELSA_BLUE_2_,
                          // gradient: LinearGradient(
                          //   end: Alignment.bottomCenter,
                          //   begin: Alignment.topCenter,
                          //   colors: [

                          //       ELSA_BLUE_1_,
                          //   ],
                          // ),
                        ),
                        child: MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: const StadiumBorder(),
                          child: Text(
                            'Got it!',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      )
                    ],
                  ),
                )),
          );
        });
  }
}
