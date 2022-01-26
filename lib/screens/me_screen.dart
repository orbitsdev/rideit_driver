import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/signin_screen.dart';

class MeScreen extends StatelessWidget {
static const screenName ="/me";
  @override
  Widget build(BuildContext context){
   return Center(
      child: ElevatedButton(
        onPressed: () {
          authinstance.signOut();
           Get.offAllNamed(SigninScreen.screenName);
        },
        child: Text('Signout'),
      ),
    );
  }
}