

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
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
           
        
                child:Text('Account temporary block'.toUpperCase(), style: TextStyle(
                  color: BACKGROUND_BLACK,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height:1.3,
                  wordSpacing: 1,
                ), textAlign: TextAlign.center,),
              
              ),
              Verticalspace(8),
              Text('Please Contact the authorize person', style: TextStyle(
                fontSize: 16,
              ),textAlign: TextAlign.center,),
              
              ElevatedButton(onPressed: () async{
                     if(drivercontroller.isOnline.value){
                               await drivercontroller.makeDriverOffline(context);  
                              }
                                authinstance.signOut();
                                Get.offAll(()=> SigninScreen());
              }, child: Text('OK'))
        ],),
      ),
    );
  }
}