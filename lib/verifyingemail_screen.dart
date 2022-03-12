import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:tricycleappdriver/UI/uicolor.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
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

  var authxcontroller = Get.find<Authcontroller>();

  bool mailverified = false;
  Timer? time;
  bool canreSendEmail = false;
  

  Timer? _timer;
int _start = 60;

void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timer =  Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
        setState(() {
          
          timer.cancel();
     canreSendEmail = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    },
  );
}

@override
  void setState(VoidCallback fn) {
    
    if(mounted){
    super.setState(fn);

    }
  }

  @override
  void initState() {
    startTimer();


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
    _timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }


  
  void resentVerification () async{
    
   setState(() {
    _start = 60;
  canreSendEmail = false;
   });
   //await authxcontroller.sendVerification();

   startTimer();
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
      
      body:  Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Verify Your Email',  style: TextStyle(fontSize: LageTextSize ),),
            
            Row(
              children: [

            Container(child: Text('We have sent an email to ',  style: TextStyle(fontSize:bodyText , color: TEXT_BLACK_DARK),)), SizedBox(
              width: 3,
            ),
            Container(child: Text('${ authinstance.currentUser!.email }',  style: TextStyle(fontSize:bodyText , color: GREEN_LIGHT_3),)), SizedBox(
            )],
            ),
            SizedBox(
              height: 12,
            ),
            Center(child: Text(_start == 0 ? '' : 'Wait ${_start} seconds before you can send email verification again ',  style: TextStyle(fontSize: bodyText , ),)),
           
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                             
                                
                                primary: DARK_GREEN,
                                minimumSize: const Size.fromHeight(40)),
              onPressed: canreSendEmail? (){
resentVerification();
            }: null, child: Text('SEND VERIFICATION AGAIN')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                             
                                
                                primary: Colors.red,
                                ),
              onPressed: (){
              
              authinstance.signOut();
              Get.offAllNamed(SigninScreen.screenName);
            }, child: Text('CANCEL')),
          ],
        ),
      ));
  }
}

