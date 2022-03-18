import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tricycleappdriver/UI/constant.dart';
import 'package:tricycleappdriver/controller/authcontroller.dart';
import 'package:tricycleappdriver/controller/drivercontroller.dart';
import 'package:tricycleappdriver/widgets/verticalspace.dart';

class EditprofileScreen extends StatefulWidget {
  const EditprofileScreen({Key? key}) : super(key: key);
  static const screenName = '/editprofile';

  @override
  _EditprofileScreenState createState() => _EditprofileScreenState();
}

class _EditprofileScreenState extends State<EditprofileScreen> {
  var authxcontroller = Get.find<Authcontroller>();
  late TextEditingController name;
  late TextEditingController phone;
  var driverxcontroller = Get.find<Drivercontroller>();
  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    phone.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

      name = TextEditingController(text: authxcontroller.useracountdetails.value.name);
      phone = TextEditingController(text: authxcontroller.useracountdetails.value.phone);

    name.addListener(onListen);
    phone.addListener(onListen);




  }

  void onListen() => setState(() {});

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  void updateProfile() {
    var isvalidated = _formkey.currentState!.validate();
    if (isvalidated) {
      _formkey.currentState!.save();
      driverxcontroller.updateProfileDetails(name.text, phone.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: FaIcon(FontAwesomeIcons.times)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                   
                  cursorColor: GREEN_LIGHT_3,
                  autofocus: false,
                  keyboardType: TextInputType.text,
                  controller: name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: BACKGROUND_BLACK_LIGHT,
                    prefixIcon: Icon(
                      Icons.account_circle_outlined,
                      color: GREEN_LIGHT,
                    ),
                    suffixIcon: name.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              name.clear();
                            },
                            icon: Icon(
                              Icons.close,
                              color: GREEN_LIGHT,
                            )),
                    label: Text(
                      'Name',
                      style: TextStyle(fontSize: 20),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: GREEN_LIGHT)),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: GREEN_LIGHT,
                  ),
                ),
                Verticalspace(8),
                TextFormField(
                  
                  cursorColor: GREEN_LIGHT_3,
                  autofocus: false,
                  keyboardType: TextInputType.phone,
                  controller: phone,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter a number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: BACKGROUND_BLACK_LIGHT,
                    prefixIcon: Icon(
                      Icons.phone_android_outlined,
                      color: GREEN_LIGHT,
                    ),
                    suffixIcon: phone.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              phone.clear();
                            },
                            icon: Icon(
                              Icons.close,
                              color: GREEN_LIGHT,
                            )),
                    label: Text(
                      'Phone',
                      style: TextStyle(fontSize: 20),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: GREEN_LIGHT)),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: GREEN_LIGHT,
                  ),
                ),
                Verticalspace(24),
                Obx(() {
                  if (driverxcontroller.isupdatingloading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
                    );
                  }

                  return Container(
                    width: double.infinity,
                    height: 50,
                    decoration: const ShapeDecoration(
                      shape: StadiumBorder(),
                      gradient: LinearGradient(
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                        colors: [
                          ELSA_BLUE_1_,
                          ELSA_BLUE_1_,
                        ],
                      ),
                    ),
                    child: MaterialButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: const StadiumBorder(),
                      child: Text('Update',
                          style: Get.textTheme.bodyText1!
                              .copyWith(fontWeight: FontWeight.w400)),
                      onPressed: () async {
                        updateProfile();
                      },
                    ),
                  );
                }),
              ],
            )),
      ),
    );
  }
}
