import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Testdialog extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        
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
                child: Lottie.asset("assets/images/43664-flappy-bird-delivering-a-message.json"),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: double.infinity,  
                color: Colors.yellow,
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
                                Text('Pickuplocation', style: Get.theme.textTheme.headline6,),
                                
                                Text('Pickuplocation Pickuplocation  Pickuplocation Pickuplocation ', style: Get.theme.textTheme.bodyText1,),
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
                                Text('Pickuplocation', style: Get.theme.textTheme.headline6,),
                                
                                Text('Pickuplocation Pickuplocation  Pickuplocation Pickuplocation ', style: Get.theme.textTheme.bodyText1,),
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
                      ElevatedButton(onPressed: (){
                        Get.back();
                      }, child: const Text('Reject')),
                      ElevatedButton(onPressed: (){
                        Get.back();
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