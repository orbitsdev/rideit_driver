import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/dialog/requestdialog/requestdialog.dart';
import 'package:tricycleappdriver/services/localnotificationservice.dart';

class Notificationserves {
  
  var requestcontroller = Get.find<Requestcontroller>();

  Future initialize() async{


      FirebaseMessaging.instance.getInitialMessage().then((message) {

      if(message != null){
         // print('______from terminated push notification');
              
          


          showRequestDialog(message.data['request_id']);
            
    
       
        }
      
    });
    //forground
    FirebaseMessaging.onMessage.listen((message) {
        if(message.notification != null){

         
          showRequestDialog(message.data['request_id']);
       
    


        }
      //Localnotificationservice.display(message);
     });
      //when at the backgroudn and user tap the notfication 
      FirebaseMessaging.onMessageOpenedApp.listen((message)  {
          
        if(message.notification != null){
          // print('______from push notificaion backround ');
          // print(message.data["request_id"]);

                    

          showRequestDialog(message.data['request_id']);
           
    
         

        }
        
      });    
  }
}