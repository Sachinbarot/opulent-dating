// ignore_for_file: library_private_types_in_public_api, file_names, prefer_typing_uninitialized_variables, sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/SexualOrientation.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';

class Gender extends StatefulWidget {
  final Map<String, dynamic> userData;
  const Gender(this.userData, {super.key});

  @override
  _GenderState createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  bool man = false;
  bool woman = false;
  bool other = false;
  bool select = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isProcessing = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            child: const Padding(
                padding: EdgeInsets.only(left: 7),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 22,
                )),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Stack(
        children: <Widget>[
          Padding(
            child: Column(
              children: [
                Text(
                  "What kind of friends?".tr().toString(),
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: black,
                      fontFamily: AppStrings.fontname),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15, bottom: 20),
                  child: Text(
                    'choose the kind of friends you want to make on  opulent .you can change this later.',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: black.withOpacity(0.8),
                        fontFamily: AppStrings.fontname),
                  ),
                ),
              ],
            ),
            padding: const EdgeInsets.only(left: 20, top: 120, right: 20),
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 70,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .15,
                    width: MediaQuery.of(context).size.width * .85,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: man ? btncolor : white),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.male,
                            size: 51,
                            color: man ? Colors.white : secondryColor,
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: Text("Male",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: man ? Colors.white : secondryColor,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      woman = false;
                      man = true;
                      other = false;
                    });
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      height: MediaQuery.of(context).size.height * .15,
                      width: MediaQuery.of(context).size.width * .85,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: woman ? btncolor : white),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.female,
                              size: 51,
                              color: woman ? Colors.white : secondryColor,
                            ),
                          ),
                          Expanded(
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: Text("Female",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color:
                                          woman ? Colors.white : secondryColor,
                                      fontWeight: FontWeight.bold)),
                            )),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        woman = true;
                        man = false;
                        other = false;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .15,
                    width: MediaQuery.of(context).size.width * .85,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: other ? btncolor : white),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.transgender,
                            size: 51,
                            color: other ? Colors.white : secondryColor,
                          ),
                        ),
                        Expanded(
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.only(right: 50),
                            child: Text("Any Gender",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: other ? Colors.white : secondryColor,
                                    fontWeight: FontWeight.bold)),
                          )),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      woman = false;
                      man = false;
                      other = true;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0, left: 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: Checkbox(
                  activeColor: btncolor,
                  value: select,
                  onChanged: (newValue) {
                    setState(() {
                      select = newValue!;
                    });
                  },
                ),
                title: Text(
                  "Show my gender on my profile",
                  style: TextStyle(
                      fontFamily: AppStrings.fontname,
                      color: black.withOpacity(0.6),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          man || woman || other
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: MyButton(
                        radius: 20.0,
                        textname: 'Continue',
                        isProcessing: _isProcessing,
                        onTap: () async {
                          setState(() {
                            _isProcessing = !_isProcessing;
                          });
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {
                            _isProcessing = !_isProcessing;
                          });
                          var userGender;
                          if (man) {
                            userGender = {
                              'userGender': "man",
                              'showOnProfile': select
                            };
                          } else if (woman) {
                            userGender = {
                              'userGender': "woman",
                              'showOnProfile': select
                            };
                          } else {
                            userGender = {
                              'userGender': "other",
                              'showOnProfile': select
                            };
                          }
                          widget.userData.addAll(userGender);
                          // print(userData['userGender']['showOnProfile']);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      SexualOrientation(widget.userData)));
                        }),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          height: MediaQuery.of(context).size.height * .065,
                          width: MediaQuery.of(context).size.width * .75,
                          child: Center(
                              child: Text(
                            "CONTINUE",
                            style: TextStyle(
                                fontSize: 15,
                                color: secondryColor,
                                fontWeight: FontWeight.bold),
                          ))),
                      onTap: () {
                        CustomSnackbar.snackbar("Please select one", context);
                      },
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
