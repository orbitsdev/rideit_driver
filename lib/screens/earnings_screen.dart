import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class EarningsScreen extends StatelessWidget {


static const screenName ="/earnings";
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: GFFloatingWidget(
    child: GFIconBadge(
              child: GFAvatar(
              size: GFSize.LARGE,
              backgroundImage:AssetImage('your asset image'),
              ),
           counterChild:  GFBadge(
           text: '12',
           shape: GFBadgeShape.circle,
           )
        ),
    body:Text('body or any kind of widget here..'),
    verticalPosition: MediaQuery.of(context).size.height* 0.2,
    horizontalPosition: MediaQuery.of(context).size.width* 0.8,
  ),
    );
  }
}