import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/UI/uicolor.dart';

class Profiledialog {
  static void showSimpleDialog(BuildContext context , Function pickImage) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: DIALOG_WHITE,
        title:  Text('Change Profile', style: Get.textTheme.headline4!.copyWith(fontWeight: FontWeight.w600),),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {   
              pickImage(ImageSource.camera);
                Get.back();
             }, 
            child: Row(
              children: [
                Icon( Icons.camera_alt_outlined, color: BACKGROUND_BLACK),SizedBox(
                  width: 12,
                ),
                 Text('Camera', style: Get.textTheme.subtitle1,)
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () { 
              pickImage(ImageSource.gallery);
                Get.back();
                
             },
            child: Row(
              children: [
                Icon( Icons.photo_outlined , color: BACKGROUND_BLACK,),SizedBox(
                  width: 12,
                ),
                 Text('Gallery', style: Get.textTheme.subtitle1,)
              ],
            ),
          ),
         
        ],
      );
        });
  }
}
