// ignore_for_file: file_names, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, await_only_futures, prefer_is_empty, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/UserDOB.dart';
import 'package:hookup4u/Screens/UserName.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/util/color.dart';

class Welcome extends StatefulWidget {
  const Welcome();

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool _isProcessing = false;
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
      body: Scaffold(
        backgroundColor: backcolor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 70,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                          image: AssetImage(
                            'asset/backlogo.png',
                          ),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.center),
                    ),
                    height: MediaQuery.of(context).size.height * .85,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              "Opulent Dating",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 36,
                                color: btncolor,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppStrings.fontname,
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(4),
                            title: Text(
                              "Welcome to Opulent App",
                              style: TextStyle(
                                fontSize: 24,
                                color: black,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppStrings.fontname,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Please follow these House Rules.',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: black.withOpacity(0.8),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: AppStrings.fontname,
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(4),
                            title: Text(
                              "Be yourself.",
                              style: TextStyle(
                                fontSize: 17,
                                color: black,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppStrings.fontname,
                              ),
                            ),
                            subtitle: Text(
                              "Make sure your photos, age, and bio are true to who you are.",
                              style: TextStyle(
                                fontSize: 16,
                                color: black.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                                fontFamily: AppStrings.fontname,
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(4),
                            title: Text(
                              "Play it cool.",
                              style: TextStyle(
                                fontSize: 17,
                                color: black,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppStrings.fontname,
                              ),
                            ),
                            subtitle: Text(
                              "Respect other and treat them as you would like to be treated",
                              style: TextStyle(
                                fontSize: 16,
                                color: black.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                                fontFamily: AppStrings.fontname,
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(4),
                            title: Text(
                              "Stay safe.",
                              style: TextStyle(
                                fontSize: 17,
                                color: black,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppStrings.fontname,
                              ),
                            ),
                            subtitle: Text(
                              "Don't be too quick to give out personal information.",
                              style: TextStyle(
                                fontSize: 16,
                                color: black.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                                fontFamily: AppStrings.fontname,
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(4),
                            title: Text(
                              "Be proactive.",
                              style: TextStyle(
                                fontSize: 17,
                                color: black,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppStrings.fontname,
                              ),
                            ),
                            subtitle: Text(
                              "Always report bad behavior.",
                              style: TextStyle(
                                fontSize: 16,
                                color: black.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                                fontFamily: AppStrings.fontname,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          MyButton(
                              radius: 20.0,
                              textname: 'Got It',
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
                                final _user =
                                    await FirebaseAuth.instance.currentUser!;
                                if (_user.displayName != null) {
                                  if (_user.displayName!.length > 0) {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => UserDOB({
                                                  'UserName': _user.displayName
                                                })));
                                  } else {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) => UserName()));
                                  }
                                } else {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => UserName()));
                                }
                              }),
                          const SizedBox(
                            height: 32,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
