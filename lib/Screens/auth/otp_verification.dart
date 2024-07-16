// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api, unnecessary_null_comparison, unnecessary_new, prefer_final_fields, await_only_futures, no_leading_underscores_for_local_identifiers, prefer_is_empty, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Tab.dart';
import 'package:hookup4u/Screens/auth/otp.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'login.dart';
import 'package:easy_localization/easy_localization.dart';

class Verification extends StatefulWidget {
  final bool updateNumber;
  final String phoneNumber;
  final String smsVerificationCode;
  const Verification(
      this.phoneNumber, this.smsVerificationCode, this.updateNumber);

  @override
  _VerificationState createState() => _VerificationState();
}

var onTapRecognizer;

class _VerificationState extends State<Verification> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Login _login = new Login();
  Future updateNumber() async {
    User user = await FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection("Users").doc(user.uid).set(
        {'phoneNumber': user.phoneNumber}, SetOptions(merge: true)).then((_) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            Future.delayed(const Duration(seconds: 2), () async {
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Tabbar(null, null)));
            });
            return Center(
                child: Container(
                    width: 180.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: <Widget>[
                        Image.asset(
                          "asset/auth/verified.jpg",
                          height: 100,
                        ),
                        Text(
                          "Phone Number\nChanged\nSuccessfully".tr().toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontSize: 20),
                        )
                      ],
                    )));
          });
    });
  }

  String? code;
  @override
  void initState() {
    super.initState();
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backcolor,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 100),
                child: Text(
                  'Enter 6-Digist Code',
                  style: TextStyle(
                      color: black,
                      fontSize: 20,
                      fontFamily: AppStrings.fontname,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50),
              child: RichText(
                text: TextSpan(
                    text: "Enter the code sent to ",
                    children: [
                      TextSpan(
                          text: widget.phoneNumber,
                          style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppStrings.fontname,
                              fontSize: 16)),
                    ],
                    style: TextStyle(
                      color: black.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppStrings.fontname,
                    )),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PinCodeTextField(
                keyboardType: TextInputType.number,
                length: 6,
                cursorHeight: 10,
                obscureText: false,
                animationType: AnimationType.fade,
                textStyle: const TextStyle(fontSize: 16),
                boxShadows: const [BoxShadow(color: Colors.white)],
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(16),
                  errorBorderColor: Colors.red,
                  disabledColor: Colors.white,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white,
                  fieldHeight: 46,
                  fieldWidth: 46,
                  borderWidth: 1.4,
                ),
                animationDuration: const Duration(milliseconds: 300),
                onChanged: (value) {
                  code = value;
                },
                appContext: context,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "didn’t received the code?",
                  style: TextStyle(
                      color: black.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppStrings.fontname),
                  children: [
                    TextSpan(
                        text: " RESEND",
                        recognizer: onTapRecognizer,
                        style: TextStyle(
                            color: bluecolor,
                            fontWeight: FontWeight.w700,
                            fontFamily: AppStrings.fontname,
                            fontSize: 15))
                  ]),
            ),
            const SizedBox(
              height: 80,
            ),
            InkWell(
              child: commanbtn(20.0, 'Verify'),
              onTap: () async {
                showDialog(
                  builder: (context) {
                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.pop(context);
                    });
                    return const Center(
                        child: CupertinoActivityIndicator(
                      radius: 20,
                    ));
                  },
                  barrierDismissible: false,
                  context: context,
                );
                PhoneAuthCredential _phoneAuth = PhoneAuthProvider.credential(
                    verificationId: widget.smsVerificationCode, smsCode: code!);
                if (widget.updateNumber) {
                  User user = await FirebaseAuth.instance.currentUser!;
                  user
                      .updatePhoneNumber(_phoneAuth)
                      .then((_) => updateNumber())
                      .catchError((e) {
                    CustomSnackbar.snackbar("$e", context);
                  });
                } else {
                  FirebaseAuth.instance
                      .signInWithCredential(_phoneAuth)
                      .then((authResult) {
                    if (authResult != null) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            Future.delayed(const Duration(seconds: 2),
                                () async {
                              Navigator.pop(context);
                              await _login.navigationCheck(
                                  authResult.user!, context);
                            });
                            return Center(
                                child: Container(
                                    width: 180.0,
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Column(
                                      children: <Widget>[
                                        Image.asset(
                                          "asset/auth/verified.jpg",
                                          height: 100,
                                        ),
                                        Text(
                                          "Verified\n Successfully"
                                              .tr()
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              decoration: TextDecoration.none,
                                              color: Colors.black,
                                              fontSize: 20),
                                        )
                                      ],
                                    )));
                          });
                      FirebaseFirestore.instance
                          .collection('Users')
                          .where('userId', isEqualTo: authResult.user!.uid)
                          .get()
                          .then((QuerySnapshot snapshot) async {
                        if (snapshot.docs.length <= 0) {
                          await setDataUser(authResult.user!);
                        }
                      });
                    }
                  }).catchError((onError) {
                    CustomSnackbar.snackbar("$onError", context);
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
