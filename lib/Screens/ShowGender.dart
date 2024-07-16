// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/Screens/personaldetails.dart';
import 'package:hookup4u/util/color.dart';


class ShowGender extends StatefulWidget {
  final Map<String, dynamic> userData;
  const ShowGender(this.userData, {Key? key}) : super(key: key);

  @override
  _ShowGenderState createState() => _ShowGenderState();
}

class _ShowGenderState extends State<ShowGender> {
  bool man = false;
  bool woman = false;
  bool everyone = false;
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
              border: Border.all(color: black.withOpacity(0.5)),
            ),
            child: const Padding(
              padding: EdgeInsets.only(left: 7),
              child: Icon(
                Icons.arrow_back_ios,
                size: 22,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              Center(
                child: Text(
                  "Show me",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: black,
                    fontSize: 30,
                    fontFamily: AppStrings.fontname,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              buildGenderOption("Male", man, () {
                setState(() {
                  woman = false;
                  man = true;
                  everyone = false;
                });
              }),
              const SizedBox(height: 30),
              buildGenderOption("Female", woman, () {
                setState(() {
                  woman = true;
                  man = false;
                  everyone = false;
                });
              }),
              const SizedBox(height: 30),
              buildGenderOption("Everyone", everyone, () {
                setState(() {
                  woman = false;
                  man = false;
                  everyone = true;
                });
              }),
              const SizedBox(height: 40),
              man || woman || everyone
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
                            String selectedGender = '';
                            if (man) {
                              selectedGender = 'man';
                            } else if (woman) {
                              selectedGender = 'woman';
                            } else {
                              selectedGender = 'everyone';
                            }
                            widget.userData
                                .addAll({'showGender': selectedGender});
                            print(widget.userData);
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    Personaldetails(widget.userData),
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGenderOption(String title, bool isSelected, Function() onTap) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(27, 25, 86, 0.05),
              offset: Offset(5.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? intrestcolor : white,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              color: isSelected ? white : secondryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
