// ignore_for_file: library_private_types_in_public_api, file_names, avoid_print, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_constructors, prefer_is_empty, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/ShowGender.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/snackbar.dart';
import 'package:easy_localization/easy_localization.dart';

class SexualOrientation extends StatefulWidget {
  final Map<String, dynamic> userData;
  const SexualOrientation(this.userData, {super.key});

  @override
  _SexualOrientationState createState() => _SexualOrientationState();
}

class _SexualOrientationState extends State<SexualOrientation> {
  bool _isProcessing = false;
  List<Map<String, dynamic>> orientationlist = [
    {'name': 'Straight'.tr().toString(), 'ontap': false},
    {'name': 'Gay'.tr().toString(), 'ontap': false},
    {'name': 'Asexual'.tr().toString(), 'ontap': false},
    {'name': 'Lesbian'.tr().toString(), 'ontap': false},
    {'name': 'Bisexual'.tr().toString(), 'ontap': false},
    {'name': 'Demisexual'.tr().toString(), 'ontap': false},
  ];
  List selected = [];
  bool select = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void _toggleSelection(int index) {
    if (selected.length < 3) {
      orientationlist[index]["ontap"] = !orientationlist[index]["ontap"];
      if (orientationlist[index]["ontap"]) {
        selected.add(orientationlist[index]["name"]);
        print(orientationlist[index]["name"]);
        print(selected);
      } else {
        selected.remove(orientationlist[index]["name"]);
        print(selected);
      }
    } else {
      if (orientationlist[index]["ontap"]) {
        orientationlist[index]["ontap"] = !orientationlist[index]["ontap"];
        selected.remove(orientationlist[index]["name"]);
      } else {
        CustomSnackbar.snackbar("select upto 3".tr().toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  child: Center(
                    child: Text(
                      "My sexual \norientation is".tr().toString(),
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: black,
                          fontFamily: AppStrings.fontname),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 50, top: 100),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      for (var i = 0; i < orientationlist.length; i += 3)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // First item in the row
                                Expanded(
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        _toggleSelection(i);
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: orientationlist[i]["ontap"]
                                            ? intrestcolor
                                            : Colors.white,
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .055,
                                      child: Center(
                                        child: Text(
                                          "${orientationlist[i]["name"]}",
                                          style: TextStyle(
                                            fontSize: 19,
                                            color: orientationlist[i]["ontap"]
                                                ? Colors.white
                                                : secondryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Second item in the row
                                if (i + 1 < orientationlist.length)
                                  Expanded(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          _toggleSelection(i + 1);
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: orientationlist[i + 1]["ontap"]
                                              ? intrestcolor
                                              : Colors.white,
                                        ),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .055,
                                        child: Center(
                                          child: Text(
                                            "${orientationlist[i + 1]["name"]}",
                                            style: TextStyle(
                                              fontSize: 19,
                                              color: orientationlist[i + 1]
                                                      ["ontap"]
                                                  ? Colors.white
                                                  : secondryColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            // Single item below the row
                            if (i + 2 < orientationlist.length)
                              InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  setState(() {
                                    _toggleSelection(i + 2);
                                  });
                                },
                                child: Container(
                                  width: 160,
                                  margin: EdgeInsets.only(top: 18, bottom: 18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: orientationlist[i + 2]["ontap"]
                                        ? intrestcolor
                                        : Colors.white,
                                  ),
                                  height:
                                      MediaQuery.of(context).size.height * .055,
                                  child: Center(
                                    child: Text(
                                      "${orientationlist[i + 2]["name"]}",
                                      style: TextStyle(
                                        fontSize: 19,
                                        color: orientationlist[i + 2]["ontap"]
                                            ? Colors.white
                                            : secondryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      leading: Checkbox(
                        activeColor: intrestcolor,
                        value: select,
                        onChanged: (newValue) {
                          setState(() {
                            select = newValue!;
                          });
                        },
                      ),
                      title: Text(
                        "Show my orientation on my profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: black.withOpacity(0.5),
                            fontFamily: AppStrings.fontname),
                      ),
                    ),
                    selected.length > 0
                        ? Padding(
                            padding: const EdgeInsets.only(top: 50),
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
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  setState(() {
                                    _isProcessing = !_isProcessing;
                                  });
                                  widget.userData.addAll({
                                    "sexualOrientation": {
                                      'orientation': selected,
                                      'showOnProfile': select
                                    },
                                  });
                                  print(widget.userData);
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              ShowGender(widget.userData)));
                                },
                              ),
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
                                    height: MediaQuery.of(context).size.height *
                                        .065,
                                    width:
                                        MediaQuery.of(context).size.width * .75,
                                    child: Center(
                                        child: Text(
                                      "CONTINUE".tr().toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: secondryColor,
                                          fontWeight: FontWeight.bold),
                                    ))),
                                onTap: () {
                                  CustomSnackbar.snackbar(
                                      "Please select one".tr().toString(),
                                      context);
                                },
                              ),
                            ),
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
