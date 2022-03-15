import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/widgets/signup/homewidgets/customsbox.dart';
import 'package:tricycleappdriver/widgets/signup/homewidgets/totalearningline.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class HomeScreen extends StatefulWidget {
  static const screenName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var driverxcontroller = Get.find<Drivercontroller>();

  @override
  void initState() {
    super.initState();
    driverxcontroller.listenToAllTrip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: 170),
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
                    borderRadius: BorderRadius.only(
                        // topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                        //topLeft: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0)),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total Earnings',
                        style: Get.textTheme.bodyText1,
                      ),
                      Verticalspace(8),
                      Container(
                        child: RichText(
                          text: TextSpan(
                            style: Get.textTheme.headline5!.copyWith(
                                fontWeight: FontWeight.w600, fontSize: 34),
                                children: [
                                  TextSpan(text: '₱ ', style: TextStyle(color: Colors.amber[400])),
                                  TextSpan(text: '${driverxcontroller.totalearning}.00'),
                                 
                                ],
                          ),
                        ),
                        // Text('₱ ${driverxcontroller.totalearning}.00',style: Get.textTheme.headline5!.copyWith(
                        //   fontWeight: FontWeight.w700,
                        //   fontSize: 34
                        // ), )
                      ),
                      Verticalspace(12),
                      Totalearningline(),
                      Verticalspace(12),
                    ],
                  ),
                ),
                Verticalspace(12),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'Dashboard',
                      style: Get.textTheme.headline5!.copyWith(
                        fontSize: 20,
                      ),
                    )),
                Verticalspace(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Customsbox(
                            title: 'Success',
                            subtitle:
                                '${driverxcontroller.totalsuccestrip.value}',
                            icon: Icons.check,
                            colors: [ELSA_GREEN, ELSA_BLUE])),
                    Expanded(
                        child: Customsbox(
                            title: 'Canceled',
                            subtitle: '${driverxcontroller.canceledtrip.value}',
                            icon: Icons.cancel_schedule_send_sharp,
                            colors: [ELSA_ORANGE, ELSA_PINK])),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
