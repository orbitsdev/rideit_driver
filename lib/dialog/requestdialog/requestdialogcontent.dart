import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart' as lottie;

import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/globaldata/globaldata.dart';
import 'package:tricycleappdriver/model/request_details.dart';

class Requestdialogcontent extends StatelessWidget {

    static const screenName = "/requestdialog";
  RequestDetails? requestdetails;
  Requestdialogcontent({
    this.requestdetails,
  });

  


  @override
  Widget build(BuildContext context){

  var requestxcontroller = Get.put(Requestcontroller());


    return Padding(
                padding: const EdgeInsets.all(0),
                child:  Container(
        
        color: Colors.white,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                width: 320,
                child: lottie.Lottie.asset("assets/images/43664-flappy-bird-delivering-a-message.json"),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,  
                
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 40,

                            child: Center(child: FaIcon(FontAwesomeIcons.mapMarkerAlt ,size: 34,))),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pickup Location', style: Get.theme.textTheme.headline6,),
                                
                                Text('${requestdetails!.pickaddress_name}', style: Get.theme.textTheme.bodyText1,),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        children: [
                          SizedBox(
                            width: 40,

                            child: Center(child: FaIcon(FontAwesomeIcons.mapMarkerAlt ,size: 34,))),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Drop Location', style: Get.theme.textTheme.headline6,),
                                
                                Text('${requestdetails!.dropddress_name}', style: Get.theme.textTheme.bodyText1,),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                      
                    ],
                  ),
              ),
               Row(
                    mainAxisAlignment:MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: () async{
                      //  assetaudioplayer.stop();
                        Get.back();


                      }, child: const Text('Reject')),
                      ElevatedButton(onPressed: () async{
                      // assetaudioplayer.stop();
                        requestxcontroller.confirmRequest(requestdetails!.request_id as String );                    
//                          Get.back();


                      }, child: const Text('Confirm')),
                    ],
                  )
            ],
          ),
        ),
      ),
              );
  }
}
