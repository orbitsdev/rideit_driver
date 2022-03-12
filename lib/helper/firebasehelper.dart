
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tricycleappdriver/model/un_accepted_request.dart';


FirebaseAuth authinstance = FirebaseAuth.instance;
User? firebaseuser;

//cloudfirestore
FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference driversusers = firestore.collection('drivers');
 CollectionReference drivercurrentrequestaccepted = driversusers.doc(authinstance.currentUser!.uid).collection('acceptedrequest');
CollectionReference availabledriverrefference = firestore.collection('availabledrivers');
CollectionReference requestcollecctionrefference = firestore.collection('request');
CollectionReference drivertriphistoryreferrence = firestore.collection('driverstriphistory');
CollectionReference passengertriphistoryreferrence = firestore.collection('passengertriphistory');
CollectionReference ongointripreferrence = firestore.collection('ongointrip');
CollectionReference ratingsreferrence = firestore.collection('ratings');

//streams
StreamController<List<DocumentSnapshot>> streamofunaacceptedrequest = StreamController<List<DocumentSnapshot>>.broadcast(); 

//realtimedatabase
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference availablereference = database.ref("availableDrivers");
StreamSubscription<Position>? driverslocationstream; 
StreamSubscription<Position>? driverlocationstream;
StreamSubscription<DocumentSnapshot>? collectiontrip;
//clound messaging
FirebaseMessaging messaginginstance = FirebaseMessaging.instance;

//storage
FirebaseStorage storage = FirebaseStorage.instance;
