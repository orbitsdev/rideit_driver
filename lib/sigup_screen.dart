import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/widgets/signup/sigupform_widget.dart';

enum pageState { signupState, otpState }

class SigupScreen extends StatelessWidget {
  static const screenName = '/signup';

  pageState currentPageState = pageState.signupState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: SigupformWidget()),
    );
  }
}
