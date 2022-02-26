import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseApi {
  static Future<UploadTask?> uploadFile(String destionation, File file)  async {
    try {
      final ref = storage.ref(destionation);
      return ref.putFile(file);

      
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return null;  
    }
  }

   static Future<UploadTask?> uploauploadBytes(String destionation, Uint8List data)  async {
    try {
      final ref = storage.ref(destionation);
      return ref.putData(data);

      
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      return null;  
    }
  }

  static Future<bool> updateProfile(String imageurl) async{
  bool isupdate = false;
  
  try{

      await driversusers.doc(authinstance.currentUser!.uid).update({
    "profile_url": imageurl,
  }).then((value) => isupdate = true);


  }catch (e){
    isupdate = false;
  }

  return isupdate;
  
}
}
