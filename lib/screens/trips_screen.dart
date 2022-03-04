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
    requestxcontroller.checkIfHasOngoingRequest();
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
               
                Obx((){
                  if(requestxcontroller.hasongingtrip.value ){
                    return Container(
                      height: 200,
                      child: Center(child: InkWell(
                        onTap: ()=> Get.offNamed(Ongoingtrip.screenName , arguments: {"from ": "trip"}),
                        child: Text(" View"))),
                    );
                  }
                  return Text('No Data');

                }),
                //firestore.collection('driverstriphistory').doc(authinstance.currentUser!.uid).collection('trips').snapshots()
             StreamBuilder(
    stream: firestore.collection('driverstriphistory').doc(authinstance.currentUser!.uid).collection('trips').snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
      if(!snapshot.hasData){
        return Center(
          child: CircularProgressIndicator(),
        );
          }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){
          return ListTile(
            title: Text("${snapshot.data!.docs[index]['dropddress_name']}"),
            subtitle: Text("${snapshot.data!.docs[index]['created_at']}"),
          );
        });

    }
  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
}
