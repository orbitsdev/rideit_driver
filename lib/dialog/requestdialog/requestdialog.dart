import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:tricycleappdriver/dialog/requestdialog/requestdialogcontent.dart';
import 'package:tricycleappdriver/globaldata/globaldata.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/model/request_details.dart';

void showRequestDialog(String requestid)  async {
RequestDetails requestdetails = RequestDetails();

  // print('_________requestid hehe');
  // print(requestid);

  await requestcollecctionrefference.doc(requestid).get().then((documentSnapshot) async{
     if(documentSnapshot.data() != null){

       //get request coming from notification  and store request id local

        requestdetails  =  RequestDetails.fromJson(documentSnapshot.data() as Map<String , dynamic>);
        requestdetails.request_id = requestid;

          if(requestdetails.status == 'pending'){
          //  assetaudioplayer.open(Audio("assets/sounds/alert.mp3"));
          //   assetaudioplayer.play();


               Get.defaultDialog(
              title: '',
              radius: 2,
              barrierDismissible: false,
              titlePadding: EdgeInsets.all(0),
              content: Requestdialogcontent(requestdetails: requestdetails,),
      );

          }
        

     }

         
     
    
  });

  
    



}

