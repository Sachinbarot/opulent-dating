// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/UserDOB.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/util/color.dart';

class AboutMe extends StatefulWidget {
  final Map<String, dynamic> userData;
 
  AboutMe(this.userData);

  @override
  _AboutMeState createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  bool _isProcessing = false;
  String aboutme = '';

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              child: Text(
                "About Me",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.w700),
              ),
              padding: EdgeInsets.only(left: 50, right: 30, top: 120),
            ),
            Container(
              height: 250,
              margin: EdgeInsets.only(left: 30, right: 30, top: 40),
              child: TextFormField(
                maxLines: 5,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "about",
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
                  helperText: "This is how it will appear in App.",
                  helperStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    aboutme = value;
                  });
                },
              ),
            ),
            aboutme.length > 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 120),
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
                            widget.userData.addAll({'AboutMe': aboutme});
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        UserDOB(widget.userData)));
                          }),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
