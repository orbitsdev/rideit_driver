import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/UI/uicolor.dart';
import 'package:tricycleappdriver/binding/getxbinding.dart';
import 'package:tricycleappdriver/config/firebaseconfig.dart';
import 'package:tricycleappdriver/constant.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/mapcontroller.dart';
import 'package:tricycleappdriver/controller/permissioncontroller.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/dialog/collectionofdialog.dart';
import 'package:tricycleappdriver/dialog/requestdialog/completetripdialog.dart';
import 'package:tricycleappdriver/geotest.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/screens/complete_screen.dart';
import 'package:tricycleappdriver/screens/earnings_screen.dart';
import 'package:tricycleappdriver/screens/home_screen.dart';
import 'package:tricycleappdriver/screens/list_of_request.dart';
import 'package:tricycleappdriver/screens/me_screen.dart';
import 'package:tricycleappdriver/screens/ongoingtrip.dart';
import 'package:tricycleappdriver/screens/map/request_map_screen.dart';
import 'package:tricycleappdriver/screens/trips_screen.dart';
import 'package:tricycleappdriver/services/localnotificationservice.dart';
import 'package:tricycleappdriver/services/notificationserves.dart';
import 'package:tricycleappdriver/signin_screen.dart';
import 'package:tricycleappdriver/signup_screen.dart';
import 'package:tricycleappdriver/testwidgets/testdialog.dart';
import 'package:tricycleappdriver/verifyingemail_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

//recieve mesage when app backgound
Future<void> backgroundHandler(RemoteMessage message) async {
  print('fourground____________');

  print(message.data);
  print(message.data["recieve_request"]);

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
  const TricycleappDriver({Key? key}) : super(key: key);

  @override
  _TricycleappDriverState createState() => _TricycleappDriverState();
}

class _TricycleappDriverState extends State<TricycleappDriver> {
  String? token;
 late StreamSubscription<ConnectivityResult> sunscription;
 late StreamSubscription<User?> user;


  void listenToInternetConnection() async{
     sunscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {

          print('Connected to mobile');

        // I am connected to a mobile network.
      } else if (result == ConnectivityResult.wifi) {
        // I am connected to a wifi network.
          print('Connected to wifi');
      }else{
          infoDialog('No Enternet');
      }
      // Got a new connectivity status!
    });
  }

  @override
  void initState() {
    super.initState();
    Get.put(Permissioncontroller());
    listenToInternetConnection();



    pirmissioncontroller.geolocationServicePermission();

    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    if (authinstance.currentUser != null) {
      _saveDeviceToken();
    }
  }

  _saveDeviceToken() async {
    token = await messaginginstance.getToken() as String;

    if (token != null) {
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
    sunscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: Getxbinding(),
      smartManagement: SmartManagement.keepFactory,
      theme: ThemeData(
        scaffoldBackgroundColor: BACKGROUND_BLACK_LIGHT,
        textTheme: TEXT_THEME_DEFAULT_DARK, 
      ),
      home:

          //Testdialog(),
          // Ongoingtrip(),

          FirebaseAuth.instance.currentUser == null
              ? SigninScreen()
              : FirebaseAuth.instance.currentUser!.emailVerified == false
                  ? VerifyingemailScreen()
                  : HomeScreenManager(),
      getPages: [
        GetPage(
            name: SigninScreen.screenName,
            page: () => SigninScreen(),
            binding: Getxbinding()),
        GetPage(
            name: SignupScreen.screenName,
            page: () => SignupScreen(),
            binding: Getxbinding()),
        GetPage(
            name: HomeScreenManager.screenName,
            page: () => HomeScreenManager(),
            binding: Getxbinding()),
        GetPage(
            name: HomeScreen.screenName,
            page: () => HomeScreen(),
            binding: Getxbinding()),
        GetPage(name: EarningsScreen.screenName, page: () => EarningsScreen()),
        GetPage(
            name: TripsScreen.screenName,
            page: () => TripsScreen(),
            binding: Getxbinding()),
        GetPage(
            name: MeScreen.screenName,
            page: () => MeScreen(),
            binding: Getxbinding()),
        GetPage(
            name: Ongoingtrip.screenName,
            page: () => Ongoingtrip(),
            binding: Getxbinding()),
        GetPage(
            name: Completetripdialog.screenName,
            page: () => Completetripdialog(),
            binding: Getxbinding()),
        GetPage(
            name: CompleteScreen.screenName,
            page: () => CompleteScreen(),
            binding: Getxbinding()),
        GetPage(
            name: VerifyingemailScreen.screenName,
            page: () => VerifyingemailScreen(),
            binding: Getxbinding()),
        GetPage(
            name: ListOfRequest.screenName,
            page: () => ListOfRequest(),
            binding: Getxbinding()),
        GetPage(
            name: RequestMapScreen.screenName,
            page: () => RequestMapScreen(),
            binding: Getxbinding()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
