import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/model/rating.dart';
import 'dart:math';

import 'package:tricycleappdriver/widgets/verticalspace.dart';
class RatingBuilder extends StatelessWidget {
  final Rating rating;
   RatingBuilder({
    Key? key,
    required this.rating,
  }) : super(key: key);

  List<Color> listofcolors = [
    ELSA_ORANGE,
    ELSA_BLUE_2_,
    ELSA_GREEN,
    ELSA_PINK,
    ELSA_BLUE,
    DARK_GREEN,
    ELSA_YELLOW_TEXT,
    ELSA_PINK_TEXT,
    ELSA_BLUE_1_,
    iconcolorsecondary,
  ];

 Random random = Random();
  @override
  Widget build(BuildContext context){
    return Container(
  
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(containerRadius)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipOval(
                child: Container(
                  
                  color: ELSA_TEXT_WHITE,

                  child: ClipOval(
                    child: Container(
                      height: 50,
                      width: 50,
                      color: listofcolors[random.nextInt(listofcolors.length)],
                      padding: EdgeInsets.all(2),
                      child: Center(
                        child:  rating.passenger_image_url == null ? Text('U') : 
                        ClipOval(
                          child: Image.network(
                                    '${rating.passenger_image_url}',
                                    height: 130,
                                    width: 130,
                                    loadingBuilder: (context, child, progress) =>
                                        progress == null
                                            ? child
                                            : Container(
                                                height: 50,
                                                width: 50,
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: ELSA_BLUE_1_,
                                                  ),
                                                ),
                                              ),
                                    fit: BoxFit.cover,
                                  ),
                        ),
                        
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${rating.passenger_name}'.toUpperCase(),
                     
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RatingBar(
                          initialRating: rating.rate!.toDouble(),
                          minRating: 3,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 3,
                          itemSize: 20,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          ratingWidget: RatingWidget(
                          full: FaIcon(FontAwesomeIcons.solidStar, color: Colors.amber),
                          half: FaIcon(FontAwesomeIcons.solidStarHalf,  color: Colors.amber),
                          empty:  FaIcon(FontAwesomeIcons.solidStar,  color: BACKGROUND_TOP),
                        ),
                                onRatingUpdate: (rating) {},
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${rating.rate}',
                          style: Get.textTheme.bodyText1,
                        ),
                      ],
                    ),
                    Verticalspace(6),
                    Text('${rating.rate_description} ' ,style: Get.textTheme.bodyText1!.copyWith(
                      fontSize: 14,
                    ),),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Container(

            padding: EdgeInsets.symmetric(horizontal: 8, ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Verticalspace(6),
            if(rating.comment != null)
            
            Text('${rating.comment}')
              ],
            ),
          )
        
        ],
      ),
    );;
  }
}
