import 'package:flutter/material.dart';
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
                   child: Text(message, style: TextStyle(fontWeight: FontWeight.w600),)))
              ],
            ),
             ),
           
         );
        });
  }

}