import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/binding/getxbinding.dart';
import 'package:tricycleappdriver/config/firebaseconfig.dart';
import 'package:tricycleappdriver/controller/mapcontroller.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/dialog/requestdialog/completetripdialog.dart';
import 'package:tricycleappdriver/geotest.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/screens/complete_screen.dart';
import 'package:tricycleappdriver/screens/earnings_screen.dart';
import 'package:tricycleappdriver/screens/home_screen.dart';
import 'package:tricycleappdriver/screens/me_screen.dart';
import 'package:tricycleappdriver/screens/ongoingtrip.dart';
import 'package:tricycleappdriver/screens/trips_screen.dart';
import 'package:tricycleappdriver/services/localnotificationservice.dart';
import 'package:tricycleappdriver/services/notificationserves.dart';
import 'package:tricycleappdriver/signin_screen.dart';
import 'package:tricycleappdriver/sigup_screen.dart';
import 'package:tricycleappdriver/testwidgets/testdialog.dart';
import 'package:tricycleappdriver/verifyingemail_screen.dart';

//recieve mesage when app backgound
Future<void> backgroundHandler(RemoteMessage message) async {
  

  // print('_______backgroundhandler');
  // print(message.data.toString());
  // print(message.notification!.title);
 
}
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Localnotificationservice.initialize();
  try {
    await Firebaseconfig.firebaseinitilizeapp();
    
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
    } else {
      throw e;
    }
  } catch (e) {
    rethrow;
  }
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(const TricycleappDriver());
}
class TricycleappDriver extends StatefulWidget {
  const TricycleappDriver({ Key? key }) : super(key: key);

  @override
  _TricycleappDriverState createState() => _TricycleappDriverState();
}

class _TricycleappDriverState extends State<TricycleappDriver>  {
 
String? token;



    late StreamSubscription<User?> user;

    @override
  void initState() {
    super.initState();
  

    // FirebaseMessaging.instance.onTokenRefresh.listen((refreshtoken) { 
    //   token = refreshtoken;
    // });

   
   
    user = FirebaseAuth.instance.authStateChanges().listen((user) { 
       if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

  

      if(authinstance.currentUser!=null){

      _saveDeviceToken();
      }



  }





  

  _saveDeviceToken() async{

     token  = await messaginginstance.getToken() as String;
    

    if(token !=null){
      // print('_________token');
      // print(token);
    }

    
driversusers.doc(authinstance.currentUser!.uid).update({
  "token": token,
});
    messaginginstance.subscribeToTopic("alldrivers");
    messaginginstance.subscribeToTopic("allusers");

  }
  @override
  void dispose() {
   
    user.cancel();
    super.dispose();
  }
    
  
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: Getxbinding(),
      smartManagement: SmartManagement.keepFactory,
      home: 
      
      //Testdialog(),
     // Ongoingtrip(),
      
      FirebaseAuth.instance.currentUser == null ?   SigninScreen() : FirebaseAuth.instance.currentUser!.emailVerified == false ? VerifyingemailScreen() :  HomeScreenManager(),
      getPages: [

         GetPage(name: SigninScreen.screenName, page: () => SigninScreen() ,binding: Getxbinding() ),
         GetPage(name: SigupScreen.screenName, page: () => SigupScreen(), binding: Getxbinding()),
         GetPage(name: HomeScreenManager.screenName, page: () => HomeScreenManager(), binding: Getxbinding()),
         GetPage(name: HomeScreen.screenName, page: () => HomeScreen(), binding: Getxbinding()),
         GetPage(name: EarningsScreen.screenName, page: () => EarningsScreen()),
         GetPage(name: TripsScreen.screenName, page: () => TripsScreen() , binding: Getxbinding()),
         GetPage(name: MeScreen.screenName, page: () => MeScreen(), binding: Getxbinding()),
         GetPage(name: Ongoingtrip.screenName, page: () => Ongoingtrip(), binding: Getxbinding()),
         GetPage(name: Completetripdialog.screenName, page: () => Completetripdialog(), binding: Getxbinding()),
         GetPage(name: CompleteScreen.screenName, page: () => CompleteScreen(), binding: Getxbinding()),
         GetPage(name: VerifyingemailScreen.screenName, page: () => VerifyingemailScreen(), binding: Getxbinding()),


         
         
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
