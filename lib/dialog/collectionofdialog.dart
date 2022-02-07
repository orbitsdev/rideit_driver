

import 'package:flutter/material.dart';
import 'package:get/get.dart';

void infoDialog(String message){
  Get.defaultDialog(
    radius: 2,
    backgroundColor: Colors.black54,
    title: '',
    titlePadding: EdgeInsets.all(0),
    content: Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            children: [
              Text(message, style: Get.theme.textTheme.headline6,),
              SizedBox(
                height: 12,
              ),
              ElevatedButton(onPressed: (){
                Get.back();
                Get.back();
        
              }, child: Text('Ok')),
            ],
        ),
      ) ,
    ),); 
}