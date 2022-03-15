import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/requestcontroller.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({Key? key}) : super(key: key);
  static const screenName = '/tripscreen';

  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> with SingleTickerProviderStateMixin {
  
  late TabController tabController;
  var requestxcontroller =  Get.find<Requestcontroller>();
  bool hasongointrip = false;
  bool loadingrequest = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    this.tabController.addListener(() => setState(() {}));
   
  

  }


bool isdepencycalled = false;
@override
  void didChangeDependencies() {
     getOngoinTripDataIfHasRequqest(context);
    super.didChangeDependencies();
  }

  void getOngoinTripDataIfHasRequqest(BuildContext context) async{
  
    if(requestxcontroller.requestdetails.value.request_id !=  null){
        tripSetter(true);
        loaderSetter(false);

    }else{ 
        //check database ia has trip
        bool response = await requestxcontroller.checkIfHasOngoingRequest();
        if(response){ 
          var ready = await requestxcontroller.getRequestData(context);
          if(ready){

            tripSetter(true);
            loaderSetter(false);
          }else{

            //error uccor when fetch data
              tripSetter(false);
              loaderSetter(false);
          }
        }else{
          //false then display emty
          tripSetter(false);
          loaderSetter(false);

        }

    }
  
  }

  void tripSetter(bool value){
    setState(() {
      hasongointrip = value;
    });
  }
  

  void loaderSetter(bool value){
    setState(() {
      loadingrequest = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Container(
          padding: EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                BACKGROUND_TOP,
                BACKGROUND_CEENTER,
              ],
            ),
            // color: BACKGROUND_BLACK_LIGHT_MORE_LIGHT,
          ),
          height: 80,
          child: TabBar(
              controller: tabController,
              labelColor: TEXT_COLOR_WHITE,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ELSA_BLUE_2_,
                    ELSA_BLUE_1_, 
                    ],
                ),
              ),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Ongoing".toUpperCase()),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Records".toUpperCase()),
                  ),
                ),
              ]),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(16),
            child: TabBarView(

              controller: tabController,
              children: [
                loadingrequest ? Center(child: CircularProgressIndicator(),) 
                : !hasongointrip ? Center(child: Text('No Data'),) :  
                Obx((){
                  return Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                       decoration: BoxDecoration(
                   color: LIGHT_CONTAINER,
                    borderRadius: BorderRadius.all(Radius.circular(containerRadius)),
                    ),
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       Text('${requestxcontroller.requestdetails.value.pickaddress_name}'),
                       Text('${requestxcontroller.requestdetails.value.dropddress_name}'),
                       Text('${requestxcontroller.requestdetails.value.passenger_name}'),
                       Text('${requestxcontroller.requestdetails.value.passenger_phone}'),
                                ],
                    ) ,
                    ),
                 ],
               );
                }),
                Icon(Icons.directions_car, size: 350),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
