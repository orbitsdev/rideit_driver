import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/UI/hex_color.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/mapcontroller.dart';
import 'package:tricycleappdriver/controller/pageindexcontroller.dart';
import 'package:tricycleappdriver/screens/earnings_screen.dart';
import 'package:tricycleappdriver/screens/home_screen.dart';
import 'package:tricycleappdriver/screens/me_screen.dart';
import 'package:tricycleappdriver/screens/trips_screen.dart';
import 'package:tricycleappdriver/services/notificationserves.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';

// optional, only if using provided badge style
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';

class HomeScreenManager extends StatefulWidget {

static const screenName = '/homescreencontroller';

  @override
  _HomeScreenManagerState createState() => _HomeScreenManagerState();
}

class _HomeScreenManagerState extends State<HomeScreenManager>  with TickerProviderStateMixin,  WidgetsBindingObserver{

    var authxcontroller = Get.find<Authcontroller>();
    var mapxcontroller = Get.find<Mapcontroller>();
    var pageindexcontroller = Get.find<Pageindexcontroller>();
    Color colorwhite = HexColor("#fbfefb");
    Color iconcolor = HexColor("#2F2191");
    Color iconcolorsecondary = HexColor("#594DAF");
     

  TabController? _tabController;


  List<Widget> _pages = [
    HomeScreen(),
    EarningsScreen(),
    TripsScreen(),
    MeScreen()
  ];  

  List<String?> _pagename = [
"Dashboard", "Home", "Trip", "Me"
  ];

 
  @override
  void initState() {
   
 WidgetsBinding.instance!.addObserver(this);
  _tabController =  TabController(
    initialIndex: pageindexcontroller.pageindex.value,
    length: _pages.length,
    vsync: this 
    );

     cloudMessagingSetup();
      authxcontroller.checkIfAcountDetailsIsNull();   


    super.initState();
  
  }

  void cloudMessagingSetup() async{
    Notificationserves notificationservces =  Notificationserves();
    notificationservces.initialize();
  }

  @override
  void setState(VoidCallback fn) {
   
   if(mounted){

    super.setState(fn);
   }
  }
@override

  void dispose() {
     WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
    _tabController!.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
      if(state == AppLifecycleState.resumed){

        if(mapxcontroller.isonlinelastime.value){
         // mapxcontroller.makeDriverOnline();
        }
        print("resumed_______________ called");
      }
     
      if(state == AppLifecycleState.paused){

          if(mapxcontroller.isOnline.value){
            mapxcontroller.isonlinelastime.value = true;
         //   mapxcontroller.makeDriverOffline();
               print("paused aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

          }else{
            mapxcontroller.isonlinelastime.value =  false;
          }
      }

      if(state == AppLifecycleState.detached)  {
        print("ditached..........................");
      }
  }
  @override
  Widget build(BuildContext context) {
     final ThemeData theme =  Theme.of(context);
    return Scaffold(
    
      bottomNavigationBar: MotionTabBar(
        initialSelectedTab: _pagename[pageindexcontroller.pageindex.value] as String,
        useSafeArea: true, // default: true, apply safe area wrapper
        labels: _pagename ,
        icons: const [Icons.dashboard, Icons.home, Icons.history, Icons.people_alt],

        // optional badges, length must be same with labels
        badges: [
          
          // Default Motion Badge Widget
          // const MotionBadgeWidget(
          //   text: '99+',
          //   textColor: Colors.white, // optional, default to Colors.white
          //   color: Colors.red, // optional, default to Colors.red
          //   size: 18, // optional, default to 18
          // ),

          // // custom badge Widget
          // Container(
          //   color: Colors.black,
          //   padding: const EdgeInsets.all(2),
          //   child: const Text(
          //     '48',
          //     style: TextStyle(
          //       fontSize: 14,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),

          // // allow null
          // null,

          // // Default Motion Badge Widget with indicator only
          // const MotionBadgeWidget(
          //   isIndicator: true,
          //   color: Colors.red, // optional, default to Colors.red
          //   size: 5, // optional, default to 5,
          //   show: true, // true / false
          // ),
        ],
        tabSize: 50,
        tabBarHeight: 55,
        textStyle:theme.textTheme.subtitle2,
        tabIconColor: iconcolor,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: iconcolorsecondary,
        tabIconSelectedColor: COLOR_WHITE,
        tabBarColor: colorwhite,
        onTabItemSelected: (int value) {
            pageindexcontroller.updateIndex(value);
             setState(() {
            _tabController!.index = pageindexcontroller.pageindex.value;
            
             });
        },
      ),
        body: 
        
        TabBarView(
          physics: NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
          controller: _tabController,
          // ignore: prefer_const_literals_to_create_immutables
          children:_pages,
        ),
    );
  }
  
}