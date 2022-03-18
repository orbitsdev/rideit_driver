import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/UI/uicolor.dart';

class Authdialog {



 static void showAuthProGress(BuildContext context , String message) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
         return Dialog(
           backgroundColor: Colors.transparent,
           child: Container(
             decoration: BoxDecoration(
                color: Colors.black,
               borderRadius: BorderRadius.all(Radius.circular(6)),
             ),
             padding: EdgeInsets.all(16),
            
            child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                strokeWidth: 3,
                color: GREEN_LIGHT,
                 ),
                 SizedBox(

                   width: 23,
                 ),
                 Expanded(child: Container(
                   margin: EdgeInsets.only(left: 20),
                   child: Text(message, style: Get.textTheme.bodyText2,)))
              ],
            ),
             ),
           
         );
        });
  }
 static void shouwLogoutDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
         return Dialog(
           backgroundColor: Colors.transparent,
           child: Container(
             decoration: BoxDecoration(
                color: Colors.black,
               borderRadius: BorderRadius.all(Radius.circular(6)),
             ),
             padding: EdgeInsets.all(16),
            
            child:Column(
              children: [
                Text('Are you sure you want to log out?', style: Get.textTheme.headline1!.copyWith(
                  color: Colors.black
                ),),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const StadiumBorder(),
                      child: Text('Yes'),
                      onPressed: () async {},
                    ),
                  ],
                )
              ],
            ),
             ),
           
         );
        });
  }

}