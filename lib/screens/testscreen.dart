import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';

class Testscreen extends StatefulWidget {
  const Testscreen({ Key? key }) : super(key: key);

  @override
  _TestscreenState createState() => _TestscreenState();
}

class _TestscreenState extends State<Testscreen> {
  
  Stream<QuerySnapshot> _tripsstream = firestore.collection('driverstriphistory').doc(authinstance.currentUser!.uid).collection('trips').snapshots();
  @override
  Widget build(BuildContext context) {
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
