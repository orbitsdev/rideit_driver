import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/controller/mapcontroller.dart';
import 'package:tricycleappdriver/controller/pageindexcontroller.dart';
import 'package:tricycleappdriver/screens/earnings_screen.dart';
import 'package:tricycleappdriver/screens/home_screen.dart';
import 'package:tricycleappdriver/screens/me_screen.dart';
import 'package:tricycleappdriver/screens/trips_screen.dart';
import 'package:tricycleappdriver/services/notificationserves.dart';

class HomeScreenManager extends StatefulWidget {

static const screenName = '/homescreencontroller';

  @override
  _HomeScreenManagerState createState() => _HomeScreenManagerState();
}

class _HomeScreenManagerState extends State<HomeScreenManager> {

    var mapxcontroller = Get.find<Mapcontroller>();
    var pageindexcontroller = Get.find<Pageindexcontroller>();

  


  List<Widget> _pages = [
    HomeScreen(),
    EarningsScreen(),
    TripsScreen(),
    MeScreen()
  ];  

 
  @override
  void initState() {
    
     cloudMessagingSetup();
    super.initState();
  }

  void cloudMessagingSetup() async{
    Notificationserves notificationservces =  Notificationserves();
    notificationservces.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[pageindexcontroller.pageindex.value],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        unselectedItemColor: Colors.black54,
        unselectedLabelStyle: TextStyle(color: Colors.black54),
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(color: Colors.grey[350], fontSize: 10),
        type: BottomNavigationBarType.shifting,
        currentIndex: pageindexcontroller.pageindex.value,
        onTap: (index){
          pageindexcontroller.updateIndex(index);

          setState(() {
            
          });
        },
        
        items: [
             bottomNavigator(FontAwesomeIcons.home, 'Me'),
             bottomNavigator(FontAwesomeIcons.creditCard, 'Me'),
             bottomNavigator(FontAwesomeIcons.history, 'Me'),
             bottomNavigator(FontAwesomeIcons.userAlt, 'Me'),
          // BottomNavigationBarItem(
        ],
      ),
    );
  }
  BottomNavigationBarItem bottomNavigator(IconData icon, String label) {
    return BottomNavigationBarItem(
      backgroundColor: Colors.red[800],
      icon: Icon(icon),
      label: label,
    );
  }
}