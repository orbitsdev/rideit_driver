import 'package:firebase_core/firebase_core.dart';

class Firebaseconfig {

static const String API_KEY = "AIzaSyBAu_0jNcwH8OC8Mva4f_5ARKEgsu6Hz5U";
static const String APP_ID = "1:162571879335:android:a5d578c78b77241617ac82";
static const String MESSAGING_SENDER_ID = "162571879335";
static const String PROJECT_ID = "162571879335";
static const String NAME = "162571879335";

static Future<FirebaseApp> firebaseinitilizeapp() async{
 var firebaseapp =   await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBAu_0jNcwH8OC8Mva4f_5ARKEgsu6Hz5U",
            appId: "1:162571879335:android:8b1e81380c3c34f417ac82",
            messagingSenderId: "162571879335",
            projectId: "tricyleapp-f8fff"));

  return firebaseapp;
}

}