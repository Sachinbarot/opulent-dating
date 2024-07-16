// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Tab.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/Screens/seach_location.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';

import 'UpdateLocation.dart';
//import 'package:geolocator/geolocator.dart';

class AllowLocation extends StatelessWidget {
  final Map<String, dynamic> userData;
  const AllowLocation(this.userData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backcolor,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
                  child: Center(child: Image.asset('asset/location.png')),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: RichText(
                      text: TextSpan(
                        text: "Enable location",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: black,
                            fontSize: 30,
                            fontFamily: AppStrings.fontname),
                        children: [
                          TextSpan(
                              text:
                                  "\nYou'll need to provide a location\nin order to search users around you."
                                      .tr()
                                      .toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: black.withOpacity(0.8),
                                  fontFamily: AppStrings.fontname,
                                  textBaseline: TextBaseline.alphabetic,
                                  fontSize: 15)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )),
                Padding(
                  padding: const EdgeInsets.all(50.0),
                  // child: FlatButton.icon(
                  //     onPressed: null,
                  //     icon: Icon(Icons.arrow_drop_down),
                  //     label: Text("Show more")),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 90.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: commanbtn(20.0, 'Continue'),
                  onTap: () async {
                    var currentLocation = await getLocationCoordinates();
                    if (currentLocation != null) {
                      userData.addAll(
                        {
                          'location': {
                            'latitude': currentLocation['latitude'],
                            'longitude': currentLocation['longitude'],
                            'address': currentLocation['PlaceName'],
                          },
                          'maximum_distance': 20,
                          'age_range': {
                            'min': "20",
                            'max': "50",
                          },
                        },
                      );
                      showWelcomDialog(context);
                      setUserData(userData);
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 5000),
                    child: SizedBox(
                      height: 42,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      SearchLocation(userData)));
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                              color: black.withOpacity(0.67),
                              fontFamily: AppStrings.fontname,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}

Future setUserData(Map<String, dynamic> userData) async {
  User? user = FirebaseAuth.instance.currentUser;
  //await FirebaseAuth.instance.currentUser().then((FirebaseUser user) async {
  await FirebaseFirestore.instance
      .collection("Users")
      .doc(user!.uid)
      .set(userData, SetOptions(merge: true));
}

Future showWelcomDialog(context) async {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => Tabbar(null, null)));
        });
        return Center(
            child: Container(
                width: 150.0,
                height: 100.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "asset/auth/verified.jpg",
                      height: 60,
                      color: primaryColor,
                      colorBlendMode: BlendMode.color,
                    ),
                    Text(
                      "You'r in",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.black,
                          fontSize: 20),
                    )
                  ],
                )));
      });
}
