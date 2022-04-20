import 'package:firebase_core/firebase_core.dart';

class Firebaseconfig {

static const String API_KEY = "AIzaSyBAu_0jNcwH8OC8Mva4f_5ARKEgsu6Hz5U";
static const String APP_ID = "1:162571879335:android:ec6b46b05c804a3517ac82";
static const String MESSAGING_SENDER_ID = "162571879335";
static const String PROJECT_ID = "tricyleapp-f8fff";


static Future<FirebaseApp> firebaseinitilizeapp() async{
 var firebaseapp =   await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBAu_0jNcwH8OC8Mva4f_5ARKEgsu6Hz5U",
            appId: "1:162571879335:android:8b1e81380c3c34f417ac82",
            messagingSenderId: "162571879335",
            projectId: "tricyleapp-f8fff"));

  return firebaseapp;
}


//cloud messaging

static const String CLOUD_MESSAGING_SERVEY_KEY = "AAAAJdoKA6c:APA91bGaGnzJj03VxQF7qnG717G-XE2BHFHGDg4yWwndr1xkOpzMxNe5HUj39WeUI48Bpsc0r80U22tcKbdkGewpQ1zBnsjOUTrLKOHY6sA6UXWbjPjAPWLKuMDrpUOEs4y0qYnnL9_f";



}