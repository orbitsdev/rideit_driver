import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/UI/uicolor.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/dialog/requestdialog/dialog_collection.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/screens/onboard_screen.dart';
import 'package:tricycleappdriver/signin_screen.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class VerifyingemailScreen extends StatefulWidget {
  const VerifyingemailScreen({Key? key}) : super(key: key);

  static const screenName = "/verifyingemail";

  @override
  State<VerifyingemailScreen> createState() => _VerifyingemailScreenState();
}

class _VerifyingemailScreenState extends State<VerifyingemailScreen>
    with WidgetsBindingObserver {
  var authxcontroller = Get.put(Authcontroller());

  bool mailverified = false;
  Timer? time;
  bool canreSendEmail = false;

  Timer? _timer;
  int _start = 24;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
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

void askPermission() async{

  bool serviceEnabled;
  LocationPermission permission;

  
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    
     DialogCollection.showInfo('Location services are disabled. Please Enable the location'); 
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      
          DialogCollection.showInfo('Dinied Permission you cannot use the if you dont allow permission');  
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    DialogCollection.showInfo('since you denied location permission Twice we could not send request permission again but you can clear app caches to refresh the app');
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

    

}


  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
        
    //askPermission();
    startTimer();
    WidgetsBinding.instance!.addObserver(this);
    checkIfEmailIsNotVerified();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    if (time != null) {
      time!.cancel();
    }
    _timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void resentVerification() async {
    setState(() {
      _start = 60;
      canreSendEmail = false;
    });
    await authxcontroller.sendVerification();

    startTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      checkIfEmailIsNotVerified();
      print('resumed called');
    }

    if (state == AppLifecycleState.paused) {
      time!.cancel();
      print('canc celd called');
    }
  }

  void checkIfEmailIsNotVerified() async {
    mailverified = authinstance.currentUser!.emailVerified;
    if (!mailverified) {
      time = Timer.periodic(Duration(seconds: 3), (_) {
        checkEmailVerified();
      });
    }
  }

  Future checkEmailVerified() async {
    print("timer called___________________________________timer");

    try{
    await authinstance.currentUser!.reload();

    }catch (e){
      print(e);
    }

    setState(() {
      mailverified = authinstance.currentUser!.emailVerified;
    });

    if (mailverified) {
      time!.cancel();

        if(authxcontroller.useracountdetails.value.new_acount == true){
             Get.offAllNamed(OnboardScreen.screenName);
        }else{
           Get.offAllNamed(HomeScreenManager.screenName);

        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(screenPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            child: Lottie.asset("assets/images/88708-email.json",
                fit: BoxFit.cover),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Verify Email',
            style: Get.textTheme.headline5,
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            child: Text(
              'An email has been sent to your email address Please open your gmail and verify your acount. You can also click the link below, it will redirect you to google Signin',
              style: Get.textTheme.bodyText1,
            ),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
              width: double.infinity,
              child: InkWell(
                  onTap: () async {
                    String url = "https://accounts.google.com";
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                  },
                  child: Text('https://accounts.google.com',
                      style: Get.textTheme.bodyText1!.copyWith(color: Colors.blue)))),
          SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Expanded(
                child: Container(
              
                  width: double.infinity,

                  height: 4,
                ),
              ),
              Expanded(
                child: Center(
                    child: Text(
                  _start == 0
                      ? ''
                      : '00: ${_start} to resend ',
                  style: Get.textTheme.bodyText1,
                )),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: DARK_GREEN, minimumSize: const Size.fromHeight(40)),
              onPressed: canreSendEmail
                  ? () {
                      resentVerification();
                    }
                  : null,
              child: Text('SEND VERIFICATION AGAIN')),
          
          ElevatedButton(
             style: ElevatedButton.styleFrom(
                             
                                
                                primary: Colors.red,
                                minimumSize: const Size.fromHeight(40)),
              onPressed: canreSendEmail ? () {
                authinstance.signOut();
                Get.offAllNamed(SigninScreen.screenName);
              }: null,
              child: Text('CANCEL')),
        ],
      ),
    ));
  }
}
