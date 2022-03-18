import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/UI/hex_color.dart';
import 'package:tricycleappdriver/UI/uicolor.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/controller/mapcontroller.dart';
import 'package:tricycleappdriver/controller/pageindexcontroller.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';
import 'package:tricycleappdriver/helper/firebasehelper.dart';
import 'package:tricycleappdriver/screens/earnings_screen.dart';
import 'package:tricycleappdriver/screens/home_screen.dart';
import 'package:tricycleappdriver/screens/me_screen.dart';
import 'package:tricycleappdriver/screens/trips_screen.dart';
import 'package:tricycleappdriver/services/notificationserves.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:getwidget/getwidget.dart';

// optional, only if using provided badge style
import 'package:motion_tab_bar_v2/motion-badge.widget.dart';

class HomeScreenManager extends StatefulWidget {

static const screenName = '/homescreencontroller';

  @override
  _HomeScreenManagerState createState() => _HomeScreenManagerState();
}

class _HomeScreenManagerState extends State<HomeScreenManager>  with SingleTickerProviderStateMixin,  WidgetsBindingObserver{

    var authxcontroller = Get.find<Authcontroller>();
    var mapxcontroller = Get.find<Mapcontroller>();
    var pageindexcontroller = Get.find<Pageindexcontroller>();
    var driverxcontroller = Get.find<Drivercontroller>();
    var requestxcontroller = Get.find<Requestcontroller>();
    Color colorwhite = HexColor("#fbfefb");
    Color iconcolor = HexColor("#2F2191");
    Color iconcolorsecondary = HexColor("#594DAF");
    bool status = false;     
    

  TabController? _tabController;


  List<Widget> _pages = [
    HomeScreen(),
    TripsScreen(),
    MeScreen()
  ];  

  List<String?> _pagename = [
"Home",  "Trip", "Me"
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
      getCurrentStatusOfDriver();
     // requestxcontroller.checkIfHasOngoingRequest();

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


void statusSetter(bool value){
  setState(() {
    status = value;
  });
}
void getCurrentStatusOfDriver()  async {
  availabledriverrefference.doc(authinstance.currentUser!.uid).get().then((value) {

    var data =  value.data() as Map<String, dynamic>;
  
    if(data['status']== 'online'){
     statusSetter(true);
    }else if(data['status']== 'offline'){
     statusSetter(false);
      
    }

  });
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

        if(driverxcontroller.isonlinelastime.value){
         // mapxcontroller.makeDriverOnline();
        }
        print("resumed_______________ called");
      }
     
      if(state == AppLifecycleState.paused){

          if(driverxcontroller.isOnline.value){
            driverxcontroller.isonlinelastime.value = true;
         //   mapxcontroller.makeDriverOffline();
               print("paused aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

          }else{
            driverxcontroller.isonlinelastime.value =  false;
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
        icons: const [Icons.dashboard, Icons.history, Icons.people_alt],

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
        textStyle:TextStyle(fontSize: 12, color: TEXT_WHITE, fontWeight: FontWeight.w300),
        
        tabIconColor: ICON_GREY,
        tabIconSize: 28.0,
        tabIconSelectedSize: 26.0,
        tabSelectedColor: Colors.transparent,
        tabIconSelectedColor: GREEN_LIGHT,
        tabBarColor: BACKGROUND_BLACK,
        onTabItemSelected: (int value) {
            pageindexcontroller.updateIndex(value);
             setState(() {
            _tabController!.index = pageindexcontroller.pageindex.value;
            
             });
        },
      ),

  //     floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: requestxcontroller.ongoingtrip.value.request_id == null?  GFFloatingWidget(
       
       child: GFIconBadge(
              
              child:  Container(
          child: FlutterSwitch(
          inactiveColor: BACKGROUND_BLACK,        
            width: 125.0,
           height: 55.0,
            valueFontSize: 16.0,
            toggleSize: 60.0,
            value: status,
            borderRadius: 30.0,
            padding: 0,
            activeToggleColor: ELSA_TEXT_WHITE,
            activeColor: GREEN_ONLINE,
            activeText: 'Online',
            inactiveText: 'Offline',
            activeTextFontWeight:FontWeight.normal,
            inactiveTextFontWeight:FontWeight.normal,
            showOnOff: true,
            toggleColor: ICON_GREY,
            onToggle: (val) {
              setState(() {
                status = val;
              });

              if(status){
                driverxcontroller.makeDriverOnline();
              }else{
                driverxcontroller.makeDriverOffline();
              }

            },
          ),
        ),
           counterChild:  GFBadge(
             color: Colors.transparent,
           text: '',
           shape: GFBadgeShape.circle,
           )
        ),
   
    verticalPosition: MediaQuery.of(context).size.height * 0.88,
    horizontalPosition: MediaQuery.of(context).size.width / 2.933333333 ,
  ) : null  ,

        body:Container(
          decoration: BoxDecoration(
                              gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                         BACKGROUND_TOP,
                          BACKGROUND_CEENTER,
                          BACKGROUND_BOTTOM
                        ],
                      ),
                    // color: BACKGROUND_BLACK_LIGHT_MORE_LIGHT,
                     borderRadius: BorderRadius.only(
                     // topRight: Radius.circular(40.0),
                      bottomRight: Radius.circular(40.0),
                      //topLeft: Radius.circular(40.0),
                      bottomLeft: Radius.circular(40.0)),
                
                  ),
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
            controller: _tabController,
            // ignore: prefer_const_literals_to_create_immutables
            children:_pages,
          ),
        ),
    );
  }
  
}