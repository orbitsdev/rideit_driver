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
var data;
  // print('_________requestid hehe');
  // print(requestid);

  await requestcollecctionrefference.doc(requestid).get().then((documentSnapshot){
     if(documentSnapshot.data() != null){

        data = documentSnapshot.data() as Map<String , dynamic>;

          if(data['status'] == 'pending'){

            
          assetaudioplayer.open(Audio("assets/sounds/alert.mp3"));
          assetaudioplayer.play();
        
       
       requestdetails.requestid = requestid;
       requestdetails.name = data['passenger_name'];
       requestdetails.phone = data['passenger_phone'];
       requestdetails.pickaddressname= data['pickaddress_name'];
       requestdetails.dropaddressname= data['dropddress_name'];
       requestdetails.picklocation = LatLng(double.parse(data['pick_location']['latitude']) , double.parse(data['pick_location']['longitude']));
       requestdetails.droplocation = LatLng(double.parse(data['drop_location']['latitude']) , double.parse(data['drop_location']['longitude']));
       requestdetails.status = data['status'];

  // print('request_object hehehe_________');
  //      print(requestdetails.requestid);
  //      print(requestdetails.name);
  //      print(requestdetails.phone);
  //      print(requestdetails.pickaddressname);
  //      print(requestdetails.dropaddressname);
  //      print(requestdetails.picklocation);
  //      print(requestdetails.droplocation);
  //      print(requestdetails.status);

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

