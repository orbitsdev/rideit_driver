

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/requestdatacontroller.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/signin_screen.dart';
import 'package:tricycleappdriver/verifyingemail_screen.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class BlockAccountScreen extends StatefulWidget {
  const BlockAccountScreen({ Key? key }) : super(key: key);
  static const screenName = "/block_acount";

  @override
  _BlockAccountScreenState createState() => _BlockAccountScreenState();
}

class _BlockAccountScreenState extends State<BlockAccountScreen> {
  var drivercontroller =  Get.put(Drivercontroller());
  var requescontroller =  Get.put(Requestdatacontroller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              
              height: 1,
              width: double.infinity,
            ),
              Container(
           
        
                child:Text('Temporary Banned'.toUpperCase(), style: TextStyle(
                  color: BACKGROUND_BLACK,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height:1.3,
                  wordSpacing: 1,
                ), textAlign: TextAlign.center,),
              
              ),
              Verticalspace(8),
              Text('Your temporary banned from rideit because you may have violated our terms of service. Please Contact The administration if you have concern.', style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700]
              ),),
              
              Verticalspace(8),
              SizedBox(
                width:double.infinity,
                child: ElevatedButton(onPressed: () async{
                       if(drivercontroller.isOnline.value){
                                 await drivercontroller.makeDriverOffline(context);  
                                }
                       if(requescontroller.ongoingtrip.value.drop_location_id != null){
                                 await requescontroller.clearLocalData();
                                }
                                  authinstance.signOut();
                                  Get.offAll(()=> SigninScreen());
              
                }, child: Text('OK', style: TextStyle(
                  fontSize: 20
                ),)),
              )
        ],),
      ),
    );
  }
}