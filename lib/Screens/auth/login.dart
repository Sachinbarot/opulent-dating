// ignore_for_file: deprecated_member_use, constant_identifier_names, unused_field, prefer_is_empty, unused_element, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Tab.dart';
import 'package:hookup4u/Screens/Welcome.dart';
import 'package:hookup4u/Screens/auth/otp.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/util/color.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatelessWidget {
  static const your_client_id = '0000000000';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const your_redirect_url =
      'https://00000000.firebaseapp.com/__/auth/handler';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: backcolor,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: screenHeight * 0.15,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Center(
                child: Image.asset(
                  "asset/loginpageimg.png",
                  fit: BoxFit.cover,
                  height: screenHeight * 0.2,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.07,
            ),
            Center(
              child: Text(
                'Find the Matching',
                style: TextStyle(
                  color: black,
                  fontSize: screenWidth * 0.06,
                  fontFamily: AppStrings.fontname,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            Text(
              "By tapping 'Log in', you agree with our \n Terms.Learn how we process your data in \n our Privacy Policy and Cookies Policy.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: black.withOpacity(0.5),
                fontSize: screenWidth * 0.04,
                fontFamily: AppStrings.fontname,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                bool updateNumber = false;
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => OTP(updateNumber),
                  ),
                );
              },
              child: SizedBox(
                height: screenHeight * 0.09,
                width: screenWidth * 0.9,
                child: Center(
                  child: commanbtn(16.0, 'Log In With Phone Number'),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Trouble logging in?",
                    style: TextStyle(
                      color: tcolor,
                      fontSize: screenWidth * 0.025,
                      fontFamily: AppStrings.fontname,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: Text(
                    "Privacy Policy",
                    style: TextStyle(
                      color: bluecolor,
                      fontSize: screenWidth * 0.03,
                      fontFamily: AppStrings.fontname,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => _launchURL(
                      "https://www.opulentdating.com/OP%20Privacy%20Policy.pdf"),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: screenWidth * 0.02, right: screenWidth * 0.02),
                  height: screenHeight * 0.002,
                  width: screenWidth * 0.02,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenHeight * 0.002),
                    color: Colors.blue,
                  ),
                ),
                GestureDetector(
                  child: Text(
                    "Terms & Conditions",
                    style: TextStyle(
                      color: bluecolor,
                      fontSize: screenWidth * 0.03,
                      fontFamily: AppStrings.fontname,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => _launchURL(
                      "https://www.opulentdating.com/OP%20Terms%20&%20Condition.pdf"),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future navigationCheck(User currentUser, context) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .where('userId', isEqualTo: currentUser.uid)
        .get()
        .then((QuerySnapshot snapshot) async {
      if (snapshot.docs.length > 0) {
        if (snapshot.docs[0].data().toString().contains('location')) {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) =>  Tabbar(null, null)));
        } else {
          Navigator.push(context,
              CupertinoPageRoute(builder: (context) => const Welcome()));
        }
      } else {
        await _setDataUser(currentUser);
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => const Welcome()));
      }
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exit'),
          content: Text('Do you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () =>
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
    return true;
  }
}

Future _setDataUser(User user) async {
  await FirebaseFirestore.instance.collection("Users").doc(user.uid).set(
    {
      'userId': user.uid,
      'UserName': user.displayName ?? '',
      'Pictures': FieldValue.arrayUnion([
        user.photoURL != null
            ? '${user.photoURL!}?width=9999'
            : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxUC64VZctJ0un9UBnbUKtj-blhw02PeDEQIMOqovc215LWYKu&s'
      ]),
      'phoneNumber': user.phoneNumber,
      'timestamp': FieldValue.serverTimestamp()
    },
    //merge: true,
  );
}
