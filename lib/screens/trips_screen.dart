import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/controller/tripcontroller.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/screens/ongoingtrip.dart';

class TripsScreen extends StatefulWidget {
  static const screenName = "/trips";

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen>
    with SingleTickerProviderStateMixin {
  var requestxcontroller = Get.find<Requestcontroller>();
  late TabController tabcontroller;

  Stream<QuerySnapshot> _tripsstream = firestore
      .collection('driverstriphistory')
      .doc(authinstance.currentUser!.uid)
      .collection('trips')
      .snapshots();

  
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
    // TODO: implement setState
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   
    tabcontroller = TabController(length: 2, vsync: this);
    tabcontroller.addListener(() {
      setState(() {});
    });
  }

  

  @override
  void dispose() {
    // TODO: implement dispose
    tabcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.blueAccent,
            height: 100,
            width: double.infinity,
            child: TabBar(
              indicatorColor: Colors.pinkAccent,
              controller: tabcontroller,
              tabs: [
                Tab(text: 'Ongoing', icon: Icon(Icons.document_scanner)),
                Tab(text: 'History', icon: Icon(Icons.time_to_leave)),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabcontroller,
              children: [
              Container(child: Text('no data'),),
                historyBuilder(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> historyBuilder() {
    return StreamBuilder<QuerySnapshot>(
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
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs;

              return ListTile(
                title: Text("${data[index]['pickuplocation_name']}"),
                subtitle: Text("${data[index]['dropplocation_name']}"),
              );
            });
      },
    );
  }
}
