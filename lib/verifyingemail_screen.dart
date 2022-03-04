import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/signin_screen.dart';

class VerifyingemailScreen extends StatefulWidget {
const VerifyingemailScreen({ Key? key }) : super(key: key);

  static const screenName = "/verifyingemail";

  @override
  State<VerifyingemailScreen> createState() => _VerifyingemailScreenState();
}

class _VerifyingemailScreenState extends State<VerifyingemailScreen> with  WidgetsBindingObserver{

  bool mailverified = false;
  Timer? time;
  @override
  void initState() {

    WidgetsBinding.instance!.addObserver(this);
    checkIfEmailIsNotVerified();
    super.initState();
  }


  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    if(time !=  null){
    time!.cancel();

    }
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(state ==  AppLifecycleState.resumed){
      checkIfEmailIsNotVerified();
      print('resumed called');
    }

    if(state ==  AppLifecycleState.paused){
      time!.cancel();
      print('canc celd called');

    }
  }

void checkIfEmailIsNotVerified()  async{
  mailverified = authinstance.currentUser!.emailVerified;
  if(!mailverified){

      time =  Timer.periodic(Duration(seconds: 3), (_) {
         checkEmailVerified();

       });

  }
}

Future  checkEmailVerified() async{

    print("timer called___________________________________timer");

    await authinstance.currentUser!.reload();

    setState(() {
      mailverified =  authinstance.currentUser!.emailVerified;
    });

    if(mailverified){
    time!.cancel();
    Get.offAllNamed(HomeScreenManager.screenName);

    } 



  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      
      body:  Column(
        children: [
          Container(
            child: Center(child: Text('Verify email')),
          ),
          ElevatedButton(onPressed: (){
            authinstance.signOut();
            Get.offAllNamed(SigninScreen.screenName);
          }, child: Text('cancel')),
        ],
      ));
  }
}

