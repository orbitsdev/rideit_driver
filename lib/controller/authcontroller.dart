import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/config/twilioconfig.dart';
import 'package:tricycleappdriver/controller/permissioncontroller.dart';
import 'package:tricycleappdriver/constant.dart';
import 'package:tricycleappdriver/controller/requestdatacontroller.dart';
import 'package:tricycleappdriver/dialog/Failuredialog/failuredialog.dart';
import 'package:tricycleappdriver/dialog/authdialog/authdialog.dart';
import 'package:tricycleappdriver/dialog/authdialog/authenticating.dart';
import 'package:tricycleappdriver/dialog/infodialog/infodialog.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/home_screen_manager.dart';
import 'package:tricycleappdriver/model/users.dart';
import 'package:tricycleappdriver/screens/block_account_screen.dart';
import 'package:tricycleappdriver/screens/onboard_screen.dart';
import 'package:tricycleappdriver/verifyingemail_screen.dart';
import 'package:twilio_phone_verify/twilio_phone_verify.dart';

class Authcontroller extends GetxController {
   var pirmissioncontroller = Get.put(Permissioncontroller());
  var hasinternet = false.obs;
  var useracountdetails = Users().obs;
  var monitoraccountuser = Users().obs;
  var isscreenshowed =false.obs;
  late TwilioPhoneVerify _twilioPhoneVerify;
  var isSignUpLoading = false.obs;
  var isCodeSent = false.obs;
  var isVerifying = false.obs;
  var timercoundown = 60.obs;
  bool mailverified = false;
  String? devicetoken;
  String? gname;
  String? gphone;
  String? gemail;
  String? gpassword;
  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();

    _twilioPhoneVerify = TwilioPhoneVerify(
        accountSid: Twilioconfig.ACCOUNT_SID,
        serviceSid: Twilioconfig.SERVICE_SID,
        authToken: Twilioconfig.AUTH_TOKEN);
    ;
  }

  void createUser(String name, String phone, String email, String password,
      BuildContext context) async {

  String defaultimage = 'https://firebasestorage.googleapis.com/v0/b/tricyleapp-f8fff.appspot.com/o/passengerusers%2Fdefaultprofile.jpg?alt=media&token=7b691d04-8406-45c7-9182-fb13f600ae4a';   


    Permissioncontroller.instance.geolocationServicePermission();
      

    gname = name.trim();
    gphone = "+63" + phone.trim();
    gemail = email.trim();
    gpassword = password.trim();

   

    try {
      isSignUpLoading(true);
       Authdialog.showAuthProGress( "Creating account...");
      await authinstance
          .createUserWithEmailAndPassword(
              email: gemail as String, password: gpassword as String)
          .then((credential) async {
            

        //get device tokem
        await getDeviceToken();
        Map<String, dynamic> userdetailsdata = {
          "name": gname as String,
          "email": gemail as String,
          "phone": gphone as String,
          "image_url": defaultimage,
           "image_file": null,
          'device_token': devicetoken,
           'map_mode':  null,
           'authorize':  true,
           'new_acount': true

        };


        await firestore.collection('drivers').doc(credential.user!.uid).set(userdetailsdata).then((_) async {
          Get.back();
           Authdialog.showAuthProGress( "Please Wait...");
          useracountdetails(Users.fromJson(userdetailsdata));
          useracountdetails.value.id = credential.user!.uid;
          isSignUpLoading(false);
          await  pirmissioncontroller.geolocationServicePermission();
          
          Position position =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).catchError((e){
            
          });
              Map<String, dynamic> driverposition;
          if(position == null){
                         driverposition = {
            "latitude": 0.0,
            "longitude":0.0,
          };
          }else{
                           driverposition = {
            "latitude": position.latitude,
            "longitude":position.longitude
          };

          }

          Map<String, dynamic> availabilitydata = {
              "device_token" : devicetoken,
              "status" : "offline",
              "driver_location" : driverposition,
          };

           await  availabledriverrefference.doc(authinstance.currentUser!.uid).set(availabilitydata).then((value)  async{

          
          //verifyPhone(context);
          // Get.offAllNamed(HomeScreenManager.screenName);

          mailverified = authinstance.currentUser!.emailVerified;

          if (mailverified == false) {
            await sendVerification();
            Get.back();
            Future.delayed(Duration(milliseconds: 300),
                () => Get.offNamed(VerifyingemailScreen.screenName));
          } else {
            Get.back();
         
            Future.delayed(Duration(seconds: 1), () {
              if(useracountdetails.value.new_acount == true){
                Get.offAndToNamed(OnboardScreen.screenName);
              }else{
                Get.offAndToNamed(HomeScreenManager.screenName);

              }
            });
          }

           });

          
        });
      });
    } on FirebaseAuthException catch (e) {
      
      isSignUpLoading(false);
      Get.back();

      Failuredialog.showErrorDialog(context, 'OPS', e.message.toString());
    } catch (e) {
      rethrow;
    }
  }

  void verifyPhone(BuildContext context) async {
    var twilioResponse = await _twilioPhoneVerify.sendSmsCode(gphone as String);
    if (twilioResponse.successful as bool) {
      isSignUpLoading(false);
      isCodeSent(true);
    } else {
      isSignUpLoading(false);
      isCodeSent(false);
     
      notificationDialog(context, twilioResponse.errorMessage.toString());
   
    }
  }

  void verifyCode(String smsCode, BuildContext context) async {
    isVerifying(true);
    var twilioResponse = await _twilioPhoneVerify.verifySmsCode(
        phone: gphone as String, code: smsCode.trim());

    if (twilioResponse.successful as bool) {
      if (twilioResponse.verification!.status == VerificationStatus.approved) {
        isVerifying(false);
        progressDialog('Authenticating...');
        Future.delayed(Duration(seconds: 1), () {
          Get.back();

          Get.offAndToNamed(HomeScreenManager.screenName);
        });
      } else {
        isVerifying(false);
        notificationDialog(context, 'Inavlid Code');
      }
    } else {
      isVerifying(false);
      notificationDialog(context, twilioResponse.errorMessage.toString());
    }
  }

  void logInUser(String email, String password, BuildContext context) async {
    try {
      Authdialog.showAuthProGress('Please wait...');
      var authuser = await authinstance.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());

     
      
      await firestore
          .collection('drivers')
          .doc(authuser.user!.uid)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.data() != null) {
          var data = querySnapshot.data() as Map<String, dynamic>;
          var useracount = Users.fromJson(data);
          useracount.id = authuser.user!.uid;
          useracountdetails(useracount);


           await getDeviceToken();
          if(devicetoken !=  null){
            if(useracountdetails.value.device_token != devicetoken){
              await updateDeviceToken(devicetoken);
              useracountdetails.value.device_token = devicetoken;
            }
          }
          //check mail
          mailverified = authinstance.currentUser!.emailVerified;

          if (mailverified == false) {
            await sendVerification();
           Get.back();
            Future.delayed(Duration(milliseconds: 300),
                () => Get.offNamed(VerifyingemailScreen.screenName));
          } else {
              
            Future.delayed(Duration(seconds: 1), () {
           
            Get.back();
            
             if(useracountdetails.value.new_acount == true){
                Get.offAndToNamed(OnboardScreen.screenName);
              }else{
                Get.offAndToNamed(HomeScreenManager.screenName);

              }
            });
          }

        } else {
          Get.back();
          Failuredialog.noDataDialog(context,'Ops', 'User doesnt exist');
  //        notificationDialog(context, 'User doesnt exist');
          authinstance.signOut();
        }
      });
    } on FirebaseAuthException catch (e) {
      Get.back();
       // notificationDialog(context, e.message.toString());
          Failuredialog.noDataDialog(context,'Ops' ,e.message.toString());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkIfMailVerified() async {
    mailverified = authinstance.currentUser!.emailVerified;

    if (mailverified == false) {
      await sendVerification();
      Get.back();
      Future.delayed(Duration(milliseconds: 300),
          () => Get.offNamed(VerifyingemailScreen.screenName));
    } else {
      Get.back();
      progressDialog('Authenticating..');
      Future.delayed(Duration(seconds: 1), () {
        Get.back();
        Get.offAndToNamed(HomeScreenManager.screenName);
      });
    }
  }

  void checkIfAcountDetailsIsNull() async {
    

    if (useracountdetails.value.id == null) {
      await firestore
          .collection('drivers')
          .doc(authinstance.currentUser!.uid)
          .get()
          .then((querySnapshot) async {
        if (querySnapshot.data() != null) {
        var data =  querySnapshot.data() as Map<String,dynamic>;
        data['id'] = authinstance.currentUser!.uid;
        useracountdetails(Users.fromJson(data));
        
        
        

        if(useracountdetails.value.new_acount == true){
          Get.off(()=> OnboardScreen());
        }


          
          

           await getDeviceToken();
       
          if(devicetoken !=  null){
            if(useracountdetails.value.device_token !=  devicetoken){
              await updateDeviceToken(devicetoken);
              useracountdetails.value.device_token = devicetoken;
            }
          }
        
        }
      });
    }
  }

  Future<void> sendVerification() async {
    try {
      final user = authinstance.currentUser;
      await user!.sendEmailVerification();
    }
     catch (e) {
       Infodialog.showInfoToastCenter(e.toString());
    }
  }

  Future<void> getDeviceToken() async {
  
    devicetoken =  await messaginginstance.getToken();
   if (devicetoken != null) {

    }
  }
 Future<void> updateDeviceToken(String? devicetoken) async{

    await driversusers.doc(authinstance.currentUser!.uid).update({
      "device_token": devicetoken
    });
   
  }


  var gettingstartedload = false.obs;
  Future<void> updateToOld() async{
    gettingstartedload(true);
    await driversusers.doc(authinstance.currentUser!.uid).update({
      'new_acount': false,
    }).then((value) {
           gettingstartedload(false);
        Get.offAndToNamed(HomeScreenManager.screenName);
    }).catchError((e){
       gettingstartedload(false);
       Infodialog.showInfoToastCenter(e.toString());
    });

  }
  Future<void> updateMapOfUser(String mapmode) async{  

      
    await driversusers.doc(authinstance.currentUser!.uid).update({
       'map_mode': mapmode,
     }).then((value) {
       useracountdetails.value.map_mode =mapmode;
     }).catchError((e){
       
       Infodialog.showInfoToastCenter(e.toString());  
     });
   }


   void monitorAccountifblock() async{
      driversusers.doc(authinstance.currentUser!.uid).snapshots().listen((event) async{
        if(event.exists){
             monitoraccountuser(Users.fromJson(event.data() as Map<String, dynamic>));

             if(monitoraccountuser.value.authorize == false){ 
                await drivercurrentrequestaccepted.get().then((value) {
                if(value.docs.isNotEmpty){
                  
                  
                }else{
                  isscreenshowed(true);
                  Get.offAll(()=> BlockAccountScreen());
                }
          });
        }else{
          if(isscreenshowed.value){
            Get.off(HomeScreenManager());
          }
        }
             
        }else{
           monitoraccountuser(Users());
        }
      });
    
   }

}
