
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
CollectionReference driversusers = firestore.collection('drivers');
CollectionReference availabledriverrefference = firestore.collection('availabledrivers');
CollectionReference requestcollecctionrefference = firestore.collection('request');
CollectionReference drivertriphistoryreferrence = firestore.collection('driverstriphistory');
CollectionReference passengertriphistoryreferrence = firestore.collection('passengertriphistory');
CollectionReference ongointripreferrence = firestore.collection('ongointrip');


//streams



//realtimedatabase
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference availablereference = database.ref("availableDrivers");
StreamSubscription<Position>? driverslocationstream; 
StreamSubscription<Position>? driverlocationstream;
//clound messaging
FirebaseMessaging messaginginstance = FirebaseMessaging.instance;

