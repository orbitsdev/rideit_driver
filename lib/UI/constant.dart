
import 'package:flutter/material.dart';

const double screenPadding = 25;
//containers
const double containerPadding = 25;
const double containerRadius = 6;
const DIALOG_WHITE =  Color(0xFFfbfefb);


const COLOR_BLACK = Color.fromRGBO(48, 47, 48, 1.0);
const COLOR_GEY = Color.fromRGBO(141, 141, 141, 1.0);
const BACKGROUND_BLACK =Color(0xFF0D101A);



const TEXT_COLOR_WHITE = Color(0xFFfbfefb);
const colorwhite = Color(0xFFfbfefb);
const iconcolor = Color(0xFF2F2191);
const iconcolorsecondary = Color(0xFF594DAF);

//Color BACKGROUND_BLACK = Color(0xFF0D101A);
const BACKGROUND_BLACK_LIGHT = Color(0xFF161828);
const BACKGROUND_BLACK_LIGHT_MORE_LIGHT = Color(0xFF292C3B);
const BACKGROUND_BLACK_LIGHT_MORE_LIGHT_2 = Color(0xFF383C51);

const ICON_GREY = Color(0xFF696C76);

//
const GREEN_LIGHT =  Color(0xFFB9E33F); 
const GREEN_LIGHT_2 =  Color(0xFFB8E23E); 
const GREEN_LIGHT_3 =  Color(0xFF93B92B); 

const DARK_GREEN =  Color(0xFF239035); 
const YELLOW =  Color(0xFFF7FC29); 
const ORRANGE =  Color(0xFFFAA001); 

//text color
const TEXT_WHITE =  Color(0xFFFEFEFF); 
const TEXT_WHITE_2 =  Color.fromARGB(255, 225, 226, 226); 

//for small text
const TEXT_BLACK_DARK =  Color(0xFF484956); 


//__________________________________________
//|headline1 use in error dialog as title
//|headline2 use as body text
// headline3 use in button
//|_________________________________________
//

const TextTheme TEXT_THEME_DEFAULT_DARK  =  TextTheme(

  headline1: TextStyle(color:BACKGROUND_BLACK_LIGHT,fontWeight: FontWeight.w900,  fontSize: 26 , ),
  headline2: TextStyle(color:BACKGROUND_BLACK_LIGHT,  fontSize: 22 , ),
  headline3: TextStyle(color:BACKGROUND_BLACK_LIGHT,  fontSize: 20 , fontWeight: FontWeight.w700),
  //black
  headline4: TextStyle(color:BACKGROUND_BLACK_LIGHT,  fontSize: 26 , ),
  headline5: TextStyle(color:TEXT_COLOR_WHITE,  fontSize: 26 , ),
  headline6: TextStyle(color:BACKGROUND_BLACK_LIGHT,  fontSize: 12 , ),
  bodyText1: TextStyle(color:TEXT_WHITE_2, fontWeight: FontWeight.w300, fontSize: 16 ,  ),
  bodyText2: TextStyle(color:TEXT_WHITE_2, fontWeight: FontWeight.w600, fontSize: 14 , height: 1.5 ),
  subtitle1: TextStyle(color:BACKGROUND_BLACK, fontWeight: FontWeight.w300, fontSize: 16 , ),
  subtitle2: TextStyle(color:COLOR_GEY, fontWeight: FontWeight.w400, fontSize: 12 ),
);



const TextTheme TEXT_THEME_DEFAULT  =  TextTheme(
  headline1: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 26 ,),
  headline2: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 22 ,),
  headline3: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 20 ,),
  headline4: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 16 ,),
  headline5: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 14 ,),
  headline6: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 12 ,),
  bodyText1: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 14 , height: 1.5 ),
  bodyText2: TextStyle(color:TEXT_WHITE, fontWeight: FontWeight.w500, fontSize: 14 , height: 1.5 ),
  subtitle1: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w400, fontSize: 12 ),
  subtitle2: TextStyle(color:COLOR_GEY, fontWeight: FontWeight.w400, fontSize: 12 ),
);


const TextTheme TEXT_THEME_SMALL  =  TextTheme(
  headline1: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 22 ,),
  headline2: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 20 ,),
  headline3: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 18 ,),
  headline4: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 14 ,),
  headline5: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 12 ,),
  headline6: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: 10 ,),
  bodyText1: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w500, fontSize: 12 , height: 1.5 ),
  bodyText2: TextStyle(color:COLOR_GEY, fontWeight: FontWeight.w500, fontSize: 12 , height: 1.5 ),
  subtitle1: TextStyle(color:COLOR_BLACK, fontWeight: FontWeight.w400, fontSize: 10 ),
  subtitle2: TextStyle(color:COLOR_GEY, fontWeight: FontWeight.w400, fontSize: 10 ),
);

