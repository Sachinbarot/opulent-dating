// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, avoid_print, no_leading_underscores_for_local_identifiers, await_only_futures, prefer_is_empty, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Tab.dart';
import 'package:hookup4u/Screens/auth/otp_verification.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/snackbar.dart';
import 'login.dart';
import 'package:easy_localization/easy_localization.dart';

class OTP extends StatefulWidget {
  final bool updateNumber;
  const OTP(this.updateNumber);

  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool cont = false;
  late String _smsVerificationCode;
  String countryCode = '+91';
  TextEditingController phoneNumController = TextEditingController();
  Login _login = Login();
  bool _isProcessing = false;
  @override
  void dispose() {
    super.dispose();
    cont = false;
  }

  Future _verifyPhoneNumber(String phoneNumber) async {
    phoneNumber = countryCode + phoneNumber.toString();
    print(phoneNumber);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 20),
        verificationCompleted: (authCredential) =>
            _verificationComplete(authCredential, context),
        verificationFailed: (authException) =>
            _verificationFailed(authException, context),
        codeAutoRetrievalTimeout: (verificationId) =>
            _codeAutoRetrievalTimeout(verificationId),
        codeSent: (verificationId, [int? code]) =>
            _smsCodeSent(verificationId, [code!]));
  }

  Future updatePhoneNumber() async {
    print("here");
    User user = await FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection("Users").doc(user.uid).set(
      {'phoneNumber': user.phoneNumber},
    ).then((_) {
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
                          "asset/auth/mobile.jpg",
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

  _verificationComplete(
      PhoneAuthCredential authCredential, BuildContext context) async {
    if (widget.updateNumber) {
      User user = await FirebaseAuth.instance.currentUser!;
      user
          .updatePhoneNumber(authCredential)
          .then((_) => updatePhoneNumber())
          .catchError((e) {
        CustomSnackbar.snackbar("$e", context);
      });
    } else {
      FirebaseAuth.instance
          .signInWithCredential(authCredential)
          .then((authResult) async {
        print(authResult.user!.uid);
        //snackbar("Success!!! UUID is: " + authResult.user.uid);
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) {
              Future.delayed(const Duration(seconds: 2), () async {
                Navigator.pop(context);
                await _login.navigationCheck(authResult.user!, context);
              });
              return Center(
                  child: Container(
                      width: 150.0,
                      height: 160.0,
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
                            "Verified\n Successfully".tr().toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                decoration: TextDecoration.none,
                                color: Colors.black,
                                fontSize: 20),
                          )
                        ],
                      )));
            });
        await FirebaseFirestore.instance
            .collection('Users')
            .where('userId', isEqualTo: authResult.user!.uid)
            .get()
            .then((QuerySnapshot snapshot) async {
          if (snapshot.docs.length <= 0) {
            await setDataUser(authResult.user!);
          }
        });
      });
    }
  }

  _smsCodeSent(String verificationId, List<int> code) async {
    // set the verification code so that we can use it to log the user in
    _smsVerificationCode = verificationId;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          Future.delayed(const Duration(seconds: 0), () {
            Navigator.pop(context);
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => Verification(
                        countryCode + phoneNumController.text,
                        _smsVerificationCode,
                        widget.updateNumber)));
          });
          return Center(
              child: Container(
                  width: 100.0,
                  height: 120.0,
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
                        "OTP\nSent".tr().toString(),
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

  _verificationFailed(
      FirebaseAuthException authException, BuildContext context) {
    CustomSnackbar.snackbar(
        "Exception!! message:${authException.message}", context);
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    _smsVerificationCode = verificationId;
    print("timeout $_smsVerificationCode");
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "asset/mobile.png",
                height: 300,
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                "Verify Your Number",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    color: black,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppStrings.fontname),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                "Please enter Your mobile Number to\n receive a verification code. Message and data\n rates may apply",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    color: black.withOpacity(0.5),
                    fontFamily: AppStrings.fontname,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: black, width: 1.5),
                  ),
                  child: ListTile(
                    leading: CountryCodePicker(
                      onChanged: (value) {
                        countryCode = value.dialCode!;
                      },
                      initialSelection: 'IN',
                      favorite: [countryCode, 'IN'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                    title: SizedBox(
                      height: MediaQuery.of(context).size.height * .050,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontSize: 20),
                        cursorColor: teccolor,
                        controller: phoneNumController,
                        onChanged: (value) {
                          setState(() {
                            cont = true;
                            phoneNumController.text = value;
                          });
                        },
                        maxLength: 10,
                        decoration: InputDecoration(
                          hintText: "Enter your number",
                          prefix: Padding(
                            padding: const EdgeInsets.only(top: 15, right: 10),
                            child: Text(
                              '|',
                              style: TextStyle(color: btncolor),
                            ),
                          ),
                          hintStyle: TextStyle(fontSize: 18, color: black),
                          focusColor: teccolor,
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          counterText: "",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              cont
                  ? Center(
                      child: MyButton(
                        radius: 20.0,
                        textname: 'Continue',
                        onTap: () async {
                          setState(() {
                            _isProcessing = !_isProcessing;
                          });
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {
                            _isProcessing = !_isProcessing;
                          });

                          showDialog(
                            builder: (context) {
                              Future.delayed(const Duration(seconds: 2), () {
                                //Navigator.pop(context);
                              });
                              return const Center(
                                  child: CupertinoActivityIndicator(
                                radius: 20,
                              ));
                            },
                            barrierDismissible: false,
                            context: context,
                          );
                          await _verifyPhoneNumber(phoneNumController.text);
                        },
                        isProcessing: _isProcessing,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

Future setDataUser(User user) async {
  await FirebaseFirestore.instance.collection("Users").doc(user.uid).set({
    'userId': user.uid,
    'phoneNumber': user.phoneNumber,
    'timestamp': FieldValue.serverTimestamp(),
    // 'Pictures': FieldValue.arrayUnion([
    //   "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSxUC64VZctJ0un9UBnbUKtj-blhw02PeDEQIMOqovc215LWYKu&s"
    // ])

    // 'name': user.displayName,
    // 'pictureUrl': user.photoUrl,
  }, SetOptions(merge: true));
}
