import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/UI/uicolor.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/requestdatacontroller.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/signin_screen.dart';
import 'package:tricycleappdriver/widgets/horizontalspace.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class Authdialog {
  static void showAuthProGress( String message) {
  
  Get.defaultDialog(
    barrierDismissible: false,
    backgroundColor: Colors.transparent,
  title: '',
  content:Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3,
                    color: GREEN_LIGHT,
                  ),
                  SizedBox(
                    width: 23,
                  ),
                  Expanded(
                      child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            message,
                            style: Get.textTheme.bodyText2,
                          )))
                ],
              ),
            ) 
  );
    // showDialog(
    //     barrierDismissible: false,
    //     context: context,
    //     builder: (context) {
    //       return Dialog(
    //         backgroundColor: Colors.transparent,
    //         child: Container(
    //           decoration: BoxDecoration(
    //             color: Colors.black,
    //             borderRadius: BorderRadius.all(Radius.circular(6)),
    //           ),
    //           padding: EdgeInsets.all(16),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               CircularProgressIndicator(
    //                 strokeWidth: 3,
    //                 color: GREEN_LIGHT,
    //               ),
    //               SizedBox(
    //                 width: 23,
    //               ),
    //               Expanded(
    //                   child: Container(
    //                       margin: EdgeInsets.only(left: 20),
    //                       child: Text(
    //                         message,
    //                         style: Get.textTheme.bodyText2,
    //                       )))
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }

  static void shouwLogoutDialog(BuildContext context) {
    var drivercontroller = Get.find<Drivercontroller>();
    var requestatacontroller = Get.find<Requestdatacontroller>();
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
                      'Are you sure you want to log out?',
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
                              if(drivercontroller.isOnline.value){
                               await drivercontroller.makeDriverOffline(context);  
                              }

                              if(requestatacontroller.ongoingtrip.value.drop_location_id != null){
                                await requestatacontroller.clearLocalData();
                              }
                                authinstance.signOut();
                                Get.offAll(()=> SigninScreen());
                              

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
  static void showConfirmationDialog(BuildContext context, String question, Function function) {
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
                      question,
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

                             function();

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
