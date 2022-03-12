
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/UI/uicolor.dart';

class Failuredialog {
static void noDataDialog(BuildContext context, String title, String body){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
         return Dialog(
           insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
           backgroundColor: Colors.transparent,
           child: Container(
             decoration: BoxDecoration(
                color: colorwhite,
               borderRadius: BorderRadius.all(Radius.circular(6)),
             ),
           
            
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(


                mainAxisSize: MainAxisSize.min,
                children: 
                [ 

                  Container(
                  
                    width: double.infinity,
                    child:  Lottie.asset('assets/images/86045-no-data-found-json.json', )
                  ),

            
                  Column(
                    children: [
                      Text(title.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: LageTextSize, color: BACKGROUND_BLACK ),),
                      SizedBox(height: 5,),
                      Container(child: Text(body,  textAlign: TextAlign.center, style: TextStyle(fontSize: MediumTextSize, color: BACKGROUND_BLACK_LIGHT,),)),
                      SizedBox(height: 20,),
                      ElevatedButton(
                            
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                                  
                                  primary: Colors.redAccent,
                                  minimumSize: const Size.fromHeight(50)),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('OK'.toUpperCase() , style: TextStyle(fontSize: 20, color: BACKGROUND_BLACK, fontWeight: FontWeight.w700),)),
                    ],
                  )
                ],
              ),
            )
             ),
           
         );
        });
  }
static void showErrorDialog(BuildContext context, String title, String body){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
         return Dialog(
           insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 40),
           backgroundColor: Colors.transparent,
           child: Container(
             decoration: BoxDecoration(
                color: colorwhite,
               borderRadius: BorderRadius.all(Radius.circular(6)),
             ),
           
            
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(


                mainAxisSize: MainAxisSize.min,
                children: 
                [ 

                  Container(
                  
                    width: double.infinity,
                    child:  Lottie.asset('assets/images/84655-swinging-sad-emoji.json', )
                  ),

            
                  Column(
                    children: [
                      Text(title.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: LageTextSize, color: BACKGROUND_BLACK ),),
                      SizedBox(height: 5,),
                      Container(child: Text(body,  textAlign: TextAlign.center, style: TextStyle(fontSize: MediumTextSize, color: BACKGROUND_BLACK_LIGHT,),)),
                      SizedBox(height: 20,),
                      ElevatedButton(
                            
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                                  
                                  primary: ORRANGE ,
                                  minimumSize: const Size.fromHeight(50)),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('OK'.toUpperCase() , style: TextStyle(fontSize: 20, color: BACKGROUND_BLACK, fontWeight: FontWeight.w700),)),
                    ],
                  )
                ],
              ),
            )
             ),
           
         );
        });
  }
}

