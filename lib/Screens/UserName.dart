//import 'package:firebase_admob/firebase_admob.dart';
// ignore_for_file: library_private_types_in_public_api, file_names, prefer_const_constructors, sort_child_properties_last, prefer_is_empty, unnecessary_string_interpolations, avoid_print, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/aboutme.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

class UserName extends StatefulWidget {
  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  Map<String, dynamic> userData = {};
  bool _isProcessing = false;
  String username = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backcolor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: black.withOpacity(0.5))),
            child: Padding(
                padding: EdgeInsets.only(left: 7),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 22,
                )),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    child: Text(
                      "What's your name ?",
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: AppStrings.fontname,
                          color: black,
                          fontWeight: FontWeight.w700),
                    ),
                    padding: EdgeInsets.only(left: 50, right: 30, top: 120),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: SizedBox(
                  height: 80,
                  child:
                  
                   TextFormField(
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Enter your first name".tr().toString(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: btncolor.withOpacity(0.8), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: btncolor.withOpacity(0.8), width: 1.5),
                      ),
                      helperText:
                          "This is how it will appear in App.".tr().toString(),
                      helperStyle: TextStyle(
                        color: black.withOpacity(0.5),
                        fontSize: 16,
                        fontFamily: AppStrings.fontname,
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                  ),
                ),
              ),
              username.length > 0
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: MyButton(
                            radius: 20.0,
                            textname: 'Got It',
                            isProcessing: _isProcessing,
                            onTap: () async {
                              setState(() {
                                _isProcessing = !_isProcessing;
                              });
                              await Future.delayed(const Duration(seconds: 1));
                              setState(() {
                                _isProcessing = !_isProcessing;
                              });

                              userData.addAll({'UserName': username});

                              // userData.addAll({
                              //   'editInfo': {
                              //     'UserName': "$username",
                              //   }
                              // });
                              print(userData);
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => AboutMe(userData)));
                            }),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
