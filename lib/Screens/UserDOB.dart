// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, file_names, sort_child_properties_last, prefer_is_empty, avoid_print, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Gender.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/util/color.dart';

class UserDOB extends StatefulWidget {
  final Map<String, dynamic> userData;
  const UserDOB(this.userData, {super.key});

  @override
  _UserDOBState createState() => _UserDOBState();
}

class _UserDOBState extends State<UserDOB> {
  DateTime? selecteddate;
  bool _isProcessing = false;
  TextEditingController dobctlr = TextEditingController();
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
            child: Padding(
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
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    child: Text(
                      "My birthday is",
                      style: TextStyle(
                          fontSize: 30,
                          color: black,
                          fontFamily: AppStrings.fontname,
                          fontWeight: FontWeight.w700),
                    ),
                    padding: EdgeInsets.only(
                      left: 30,
                      top: 120,
                    ),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    title:
                     CupertinoTextField(
                      readOnly: true,
                      keyboardType: TextInputType.phone,
                      prefix: IconButton(
                        icon: (Icon(
                          Icons.calendar_today,
                          color: btncolor,
                        )),
                        onPressed: () {},
                      ),
                      onTap: () => 
                      showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .25,
                                child: GestureDetector(
                                  child: CupertinoDatePicker(
                                    backgroundColor: Colors.white,
                                    initialDateTime: DateTime(2000, 10, 12),
                                    onDateTimeChanged: (DateTime newdate) {
                                      setState(() {
                                        dobctlr.text =
                                            '${newdate.day}/${newdate.month}/${newdate.year}';
                                        selecteddate = newdate;
                                      });
                                    },
                                    maximumYear: 2015,
                                    minimumYear: 1800,
                                    maximumDate: DateTime(2015, 31, 12),
                                    mode: CupertinoDatePickerMode.date,
                                  ),
                                  onTap: () {
                                    print(dobctlr.text);
                                    Navigator.pop(context);
                                  },
                                ));
                          }),
                     
                     
                      placeholder: "DD/MM/YYYY",
                      controller: dobctlr,
                    ),
                   
                   
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        " Your age will be public",
                        style: TextStyle(
                            fontFamily: AppStrings.fontname,
                            fontWeight: FontWeight.w500,
                            color: tcolor),
                      ),
                    ),
                  )),
              dobctlr.text.length > 0
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

                              widget.userData.addAll({
                                'user_DOB': "$selecteddate",
                                'age': ((DateTime.now()
                                            .difference(selecteddate!)
                                            .inDays) /
                                        365.2425)
                                    .truncate(),
                              });
                              print(widget.userData);
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          Gender(widget.userData)));
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
                                "",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: secondryColor,
                                    fontWeight: FontWeight.bold),
                              ))),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
