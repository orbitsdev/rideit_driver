
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';

FirebaseAuth authinstance = FirebaseAuth.instance;
User? firebaseuser;

//cloudfirestore
FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference requestcollecctionrefference = firestore.collection('request');
CollectionReference driversusers = firestore.collection('drivers');
CollectionReference availabledriverrefference = firestore.collection('availabledrivers');


//realtimedatabase
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference availablereference = database.ref("availableDrivers");
StreamSubscription<Position>? driverslocationstream; 

//clound messaging
FirebaseMessaging messaginginstance = FirebaseMessaging.instance;

