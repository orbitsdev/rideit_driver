import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseApi {



static Future<void> uploadProfile() async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String filePath = '${appDocDir.absolute}/file-to-upload.png';
  // ...
  // e
  //.g. await uploadFile(filePath);
}

static Future<void> uploadFile(String destionation,  File file) async {
  
  try {
    await storage
        .ref(destionation)
        .putFile(file);
  } on FirebaseException catch (e) {
    // e.g, e.code == 'canceled'
  }
}

}