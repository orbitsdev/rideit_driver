import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/allwidgets/authTextFormField.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:email_validator/email_validator.dart';

enum PageState { siningUpPagegSate, otpPageState }

class SigupformWidget extends StatefulWidget {
  @override
  State<SigupformWidget> createState() => _SigupformWidgetState();
}

class _SigupformWidgetState extends State<SigupformWidget> {
  PageState currentPageState = PageState.siningUpPagegSate;

  var autxcontroller = Get.find<Authcontroller>();

  var name = TextEditingController();

  var email = TextEditingController();

  var phone = TextEditingController();

  var password = TextEditingController();

  var confirmpassword = TextEditingController();

  var smsCodeController = TextEditingController();

  GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();

  GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();


@override
  void initState() {
    super.initState();
     email.addListener(onListen);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    email.removeListener(onListen);
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmpassword.dispose();
  }

void onListen()=>  setState(() {});
  //twilio

  @override
  Widget build(BuildContext context) {
   
   
   
    void signUp() async {
      var isValidated = _signUpFormKey.currentState!.validate();
      if (isValidated) {
        _signUpFormKey.currentState!.save();
        autxcontroller.createUser(name.text, phone.text, email.text, password.text, context);
      }
    }

    void verifycode() async {
      var isValidated = _otpFormKey.currentState!.validate();
      if (isValidated) {
        _otpFormKey.currentState!.save();
          autxcontroller.verifyCode(smsCodeController.text, context);
        
      }
    }

    Widget signUpPage() {
      return Form(
        key: _signUpFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          child: Column(
            children: [
              Authtextformfield(fieldname: 'Name', controller: name, keyboardType: TextInputType.text, textInputAction: TextInputAction.next, obscureText: false),
              SizedBox(
                height: 12,
              ),
              Authtextformfield(fieldname: 'Email', controller: email, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, obscureText: false),
             
              SizedBox(
                height: 12,
              ),
              Authtextformfield(fieldname: 'Phone', controller: phone, keyboardType: TextInputType.phone, textInputAction: TextInputAction.next, obscureText: false),
             
              SizedBox(
                height: 12,
              ),
              
              Authtextformfield(fieldname: 'Paassword', controller: password, keyboardType: TextInputType.text, textInputAction: TextInputAction.next, obscureText: true),
              SizedBox(
                height: 12,
              ),
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: confirmpassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  signUp();
                },
                validator: (value) {
                  if (value != password.text) {
                    return 'Password did not match';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(
                    'Confirm Password',
                    style: TextStyle(fontSize: 14),
                  ),
                  hintStyle: TextStyle(fontSize: 10),
                ),
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 12,
              ),
              Obx((){
                   if (autxcontroller.isSignUpLoading.value == true) {
                  return Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ));
                }

                return Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          signUp();
                        },
                        child: Text('SignUp')),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already Have an account?'),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Text(
                            'Signin',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                
              );
              }),
              
            ],
          ),
        ),
      );
    }

    Widget otpState() {
      return Form(
        key: _otpFormKey,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              TextFormField(
                autofocus: false,
                keyboardType: TextInputType.text,
                controller: smsCodeController,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  verifycode();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a code';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(
                    'Enter Sms Code',
                    style: TextStyle(fontSize: 14),
                  ),
                  hintStyle: TextStyle(fontSize: 10),
                ),
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(
                height: 12,
              ),

              Obx(() {
                if (autxcontroller.isVerifying.value == true) {
                  return Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ));
                }

                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 40,
                      child: TextButton(
                          onPressed: () {
                            verifycode();
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor),
                          child: Text(
                            'Verify',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                
              );


              }),
              
            ],
          ),
        ),
      );
    }
 return Obx(() {
      if (autxcontroller.isCodeSent.value) {
        return otpState();
      }
      return signUpPage();
    });
  }
}
