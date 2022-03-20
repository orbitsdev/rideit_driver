import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/widgets/horizontalspace.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class ListOfRequest extends StatefulWidget {
  static const screenName = '/lisofscreen';
  @override
  _ListOfRequestState createState() => _ListOfRequestState();
}

class _ListOfRequestState extends State<ListOfRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.times)),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: LIGHT_CONTAINER,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipOval(
                            child: Container(
                              height: 50,
                              width: 50,
                              child: Image.asset('assets/images/images.jpg'),
                            ),
                          ),
                          Horizontalspace(8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kristine Teruel',
                                    style: Get.textTheme.bodyText1!
                                        .copyWith(fontWeight: FontWeight.w600)),
                                Verticalspace(5),
                                Row(children: [
                                  Container(
                                    height: 34,
                                    width: 34,
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.mapMarkerAlt,
                                        color: ELSA_PINK,
                                      ),
                                    ),
                                  ),
                                  Horizontalspace(4),
                                  Expanded(
                                    child: Text(
                                      'Kalawas 2 Isulan SUltan Kudarat THe deprament of education',
                                      style: Get.textTheme.bodyText1!.copyWith(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ])
                              ],
                            ),
                          ),
                        ],
                      ),
                      Verticalspace(12),
                      Container(
                        decoration: BoxDecoration(
                            color: BOTTOMNAVIGATOR_COLOR,
                            borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.all(12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 34,
                                    width: 34,
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.mapPin,
                                        color: ELSA_GREEN,
                                      ),
                                    ),
                                  ),
                                  Horizontalspace(12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Drop Location',
                                          style: Get.textTheme.bodyText1!
                                              .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w100),
                                        ),
                                        Verticalspace(8),
                                        Text(
                                          'Kalawas 2 Isulan SUltan Kudarat THe deprament of education',
                                          style: Get.textTheme.bodyText1!
                                              .copyWith(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      Verticalspace(12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: DARK_GREEN,
                                ),
                                onPressed: () {},
                                child: Text('Accept')),
                          ),
                          Horizontalspace(24),
                          Expanded(
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.redAccent,
                                ),
                                onPressed: () {},
                                child: Text('View Location')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Verticalspace(12),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  child: AnimationLimiter(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                color: LIGHT_CONTAINER,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                            child: Row(
                              children: [
                                // ClipOval(
                                //   child: Container(
                                //     height: 50,
                                //     width: 50,
                                //     child:
                                //         Image.asset('assets/images/images.jpg'),
                                //   ),
                                // ),
                                Horizontalspace(12),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Kristine Teruel',
                                            style: Get.textTheme.bodyText1!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                        Verticalspace(4),
                                        Row(
                                          children: [
                                            ClipOval(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  //
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      ELSA_PURPLE_2_,
                                                      ELSA_PURPLE_1_,
                                                    ],
                                                  ),
                                                ),
                                                width: 30,
                                                height: 30,
                                                child: Center(
                                                    child: Text(
                                                  'FR',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )),
                                              ),
                                            ),
                                            Horizontalspace(5),
                                            // Container(
                                            //   width: 30,
                                            //    padding: EdgeInsets.all(5),
                                            //   child: Center(child: FaIcon(FontAwesomeIcons.mapMarkerAlt, color: ELSA_PINK,)),
                                            // ),
                                            Flexible(
                                              child: Text(
                                                'Kalawas 2 Isulan SUltan Kudarat THe deprament of education',
                                                style: Get.textTheme.bodyText1!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w100,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Verticalspace(6),
                                        Row(
                                          children: [
                                            ClipOval(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  //
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomLeft,
                                                    colors: [
                                                      ELSA_BLUE_2_,
                                                        ELSA_BLUE_1_,
                                                    ],
                                                  ),
                                                ),
                                                width: 30,
                                                height: 30,
                                                child: Center(
                                                    child: Text(
                                                  'TO',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300),
                                                )),
                                              ),
                                            ),
                                            Horizontalspace(5),
                                            // Container(
                                            //   width: 30,
                                            //    padding: EdgeInsets.all(5),
                                            //   child: Center(child: FaIcon(FontAwesomeIcons.mapMarkerAlt, color: ELSA_PINK,)),
                                            // ),
                                            Flexible(
                                              child: Text(
                                                'Kalawas 2 Isulan SUltan Kudarat THe deprament of education',
                                                style: Get.textTheme.bodyText1!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w100,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Column(children: [
                                     IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.checkCircle, size: 34, color: ELSA_GREEN,)),
                                    Text('Accept', style: TextStyle(fontSize: 12, color: Colors.grey[400], fontWeight: FontWeight.w100))
                                    ] ),
                                    Column(children: [
                                     IconButton(onPressed: (){}, icon: FaIcon(FontAwesomeIcons.mapMarkedAlt, size: 34, color: ELSA_BLUE,)),
                                    Text('View', style: TextStyle(fontSize: 12, color: Colors.grey[400], fontWeight: FontWeight.w100))
                                    ] ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
