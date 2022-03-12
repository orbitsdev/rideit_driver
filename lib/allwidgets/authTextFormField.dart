import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Authtextformfield extends StatelessWidget {
final String fieldname;
final TextEditingController controller;
final TextInputType keyboardType;
final TextInputAction textInputAction;
final bool obscureText;
Function? registerfunction;
Authtextformfield({Key? key, required this.fieldname, required this.controller, required this.keyboardType, required this.textInputAction, required this.obscureText , this.registerfunction}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return TextFormField(
                keyboardType: keyboardType,
                controller: controller,
                textInputAction: textInputAction,
                validator: (value) {

                  
                  //forname
                  if(fieldname == "Name"){
                     if (value!.isEmpty) {
                    return 'Please enter a name';
                  }

                  }

                  

                   if(fieldname == "Phone"){
                       if (value!.isEmpty) {
                    return 'Please enter a valid number';
                  }
                  
                  }

                   if(fieldname == "Password"){
                       if (value!.isEmpty) {
                    return 'Please enter a valid password';
                  }

                   }
                  

                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(
                   fieldname,
                    style: TextStyle(fontSize: 14),
                  ),
                  hintStyle: TextStyle(fontSize: 10),
                ),
                style: TextStyle(fontSize: 14),
              );
  }
}
