import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/controller/tripcontroller.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';

class TripsScreen extends StatefulWidget {
  static const screenName ="/trips";

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {



@override
  void dispose() {
    // TODO: implement dispose
    
    super.dispose();
  }

Stream<QuerySnapshot> _tripsstream = firestore.collection('trip').snapshots();

  @override
  Widget build(BuildContext context){
    return  StreamBuilder<QuerySnapshot>(
      stream: _tripsstream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

           return ListView.builder(
             itemCount: snapshot.data!.docs.length,
             itemBuilder: (context, index){   
               var data = snapshot.data!.docs ;

                return ListTile(
                  title: Text("${data[index]['pickuplocation_name']}"),
                 subtitle: Text("${data[index]['dropplocation_name']}"),
                );
          });        
       
        
      },
    );
  }
}