import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Localnotificationservice {

  static final FlutterLocalNotificationsPlugin  _notificationplugin = FlutterLocalNotificationsPlugin();

  static void initialize(){

    final InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'),);
    _notificationplugin.initialize(initializationSettings, onSelectNotification: (String? payload) async{
      print('hhaha_____payload');
      print(payload);
      
    });
  }

  static void display(RemoteMessage message) async {
  
    try {
      final id =  DateTime.now().millisecondsSinceEpoch ~/1000;
      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
        
          "triograb",
          "triograb channerl",
          channelDescription: "This is our channel",
          importance: Importance.max,
          priority: Priority.high,
          ),
             
      );
         await _notificationplugin.show(
        id,
        message.notification!.title, 
        message.notification!.body, 
        notificationDetails,
        payload: message.data['mydata'],
        );
    } on Exception catch (e) {
      print(e.toString());
    }
  }

}