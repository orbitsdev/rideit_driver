import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/widgets/horizontalspace.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class Listcontainer extends StatelessWidget {

  final String picklocation;
  final String droplocation;
  final String date;
  
  const Listcontainer({
    Key? key,
    required this.picklocation,
    required this.droplocation,
    required this.date,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context){
    return Container(

                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      decoration: BoxDecoration(
                          color: LIGHT_CONTAINER,
                borderRadius:
                    BorderRadius.all(Radius.circular(containerRadius)),
              ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FaIcon(FontAwesomeIcons.check, size: 14, color: ELSA_GREEN,),
                            Horizontalspace(8),
                            Text('Success', style: TextStyle(color: ELSA_GREEN, fontWeight: FontWeight.w100),),
                          ],
                        ),
                         Verticalspace(12),
                         Row(
                   children: [
              Container(
                  
                  child: Container(
                    width: 20,
                    child: FaIcon(
                     FontAwesomeIcons.mapMarkerAlt,
                      color: Colors.red[300],
                    ),
                  )),
                  Horizontalspace(12),
                   Expanded(
                     child: RichText(
                              text: TextSpan(
                                style: Get.theme.textTheme.bodyText1!.copyWith(
                      color: ELSA_TEXT_WHITE,
                      fontWeight: FontWeight.w100),
                                children: [
                                  TextSpan(
                                      text: 'From\n',
                                      style: TextStyle(color: Colors.red[300])),
                                  TextSpan(
                                      text:
                                          '${picklocation}'),
                                ],
                              ),
                            ),
                   ),
            
            ],
          ),  
          Verticalspace(16),
                  
                         Row(
                   children: [
              Container(
                  
                  child: Container(
                    width: 20,
                    child: FaIcon(

                     FontAwesomeIcons.mapPin,
                      color: Colors.blue[300],
                    ),
                  )),
                  Horizontalspace(12),
                   Expanded(
                     child: RichText(
                              text: TextSpan(
                                style: Get.theme.textTheme.bodyText1!.copyWith(
                      color: ELSA_TEXT_WHITE,
                      fontWeight: FontWeight.w100),
                                children: [
                                  TextSpan(
                                      text: 'To\n',
                                      style: TextStyle(color: Colors.blue[300])),
                                  TextSpan(
                                      text:
                                          '${droplocation}'),
                                ],
                              ),
                            ),
                   ),
            
            ],
          ),
          Verticalspace(16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container(
                        //   height: 40,
                        //   width: 40,
                        //   child: Lottie.asset('assets/images/97572-connecting.json'),
                        // ),
                        Horizontalspace(12),
                        Row(

                          children: [
                            FaIcon(FontAwesomeIcons.calendarAlt,size: 20, color: Colors.amber[400],),
                            Horizontalspace(4),
                            Text('${date}', style: TextStyle(fontWeight: FontWeight.w100),)
                          ],
                        )
                      ],
                    )
                       
                       ]),
                    
                    );
  }
}
