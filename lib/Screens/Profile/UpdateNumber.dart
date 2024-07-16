// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/auth/otp.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/util/color.dart';

class UpdateNumber extends StatelessWidget {
  final User currentUser;
  const UpdateNumber(this.currentUser, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: btncolor,
      appBar: AppBar(
        title: Text(
          "Phone Number Settings",
          style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: AppStrings.fontname,
              fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: btncolor,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: backcolor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Phone number",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppStrings.fontname)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  color: white,
                  surfaceTintColor: white,
                  child: ListTile(
                    title: Text(
                        currentUser.phoneNumber != null
                            ? "${currentUser.phoneNumber}"
                            : "Verify Phone number",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          fontFamily: AppStrings.fontname,
                        )),
                    trailing: Icon(
                      currentUser.phoneNumber != null ? Icons.done : null,
                      color: btncolor,
                    ),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text("We Can Send Otp Code To Your Number !",
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: AppStrings.fontname,
                      fontWeight: FontWeight.w300,
                      color: pink)),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: InkWell(
                  child: Card(
                    color: btncolor,
                    surfaceTintColor: btncolor,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text("Update my phone number",
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: AppStrings.fontname,
                              fontWeight: FontWeight.w500,
                              color: white)),
                    ),
                  ),
                  onTap: () => Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => OTP(true))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
