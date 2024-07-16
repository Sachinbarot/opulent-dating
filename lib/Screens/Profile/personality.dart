// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_print, sort_child_properties_last, use_key_in_widget_constructors

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/profilePicSet.dart';
import 'package:hookup4u/util/color.dart';

// ignore: must_be_immutable
class Personality extends StatefulWidget {
  final Map<String, dynamic> userData;

  const Personality(
    this.userData,
  );
  @override
  _PersonalityState createState() => _PersonalityState();
}

class _PersonalityState extends State<Personality> {
  String personaldetals = '';
  List<Color> containerColors =
      List.filled(4, const Color.fromARGB(255, 201, 194, 193));

  List<String> selectedTexts = [];

  void changeColor(int containerNumber, String text) {
    setState(() {
      if (containerNumber >= 0 && containerNumber <= 4) {
        containerColors[containerNumber - 1] =
            containerColors[containerNumber - 1] ==
                    Color.fromARGB(255, 201, 194, 193)
                ? primaryColor
                : Color.fromARGB(255, 201, 194, 193);
        if (containerColors[containerNumber - 1] == primaryColor) {
          selectedTexts.add(text);
          print(text);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 50),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: FloatingActionButton(
            elevation: 35,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: primaryColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white38,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Center(
                child: Text(
                  "Personality",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              SizedBox(height: 35),
              Text(
                "Personality",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeColor(1,
                          'GOOD'); // Call function to change color of container 1
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[0], // Use the updated color
                      ),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Icon(Icons.personal_injury, color: Colors.red),
                            SizedBox(width: 5),
                            Text(
                              'GOOD  ',
                              style: TextStyle(
                                color: containerColors[0] == primaryColor
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      changeColor(2, 'Average');
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[1], // Use the updated color
                      ),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Icon(Icons.personal_injury_outlined,
                                color: Colors.red),
                            SizedBox(width: 5),
                            Text(
                              'Average  ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[1] == primaryColor
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              Text(
                "Interests",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeColor(3,
                          'Man'); // Call function to change color of container 1
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[2], // Use the updated color
                      ),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.blue),
                            SizedBox(width: 5),
                            Text(
                              'Man  ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[2] == primaryColor
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      changeColor(4, 'Womans');
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[3], // Use the updated color
                      ),
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Icon(Icons.girl_sharp, color: Colors.red),
                            SizedBox(width: 5),
                            Text(
                              'Womans  ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[3] == primaryColor
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, top: 40),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  primaryColor.withOpacity(.5),
                                  primaryColor.withOpacity(.8),
                                  primaryColor,
                                  primaryColor
                                ])),
                        height: MediaQuery.of(context).size.height * .065,
                        width: MediaQuery.of(context).size.width * .75,
                        child: Center(
                            child: Text(
                          "CONTINUE".tr().toString(),
                          style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ))),
                    onTap: () {
                      widget.userData.addAll({
                        'personality': {
                          'selectedTexts': selectedTexts,
                        }
                      });
                      widget.userData.remove('showOnProfile');
                      widget.userData.remove('userGender');
                      print(widget.userData);
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  ProfilePicSet(widget.userData)
                              // ProfilePicSet(userData: widget.userData)
                              //AllowLocation(widget.userData),
                              ));
                    },
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

// Widget containervalue(onTap, isSelected, icon, iconColor, label) {
//   return GestureDetector(
//     onTap: onTap,
//     child: Container(
//       height: 35,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12.0),
//         color: isSelected ? Colors.black : Colors.grey,
//       ),
//       child: Container(
//         margin: EdgeInsets.all(5),
//         child: Row(
//           children: [
//             Icon(icon, color: iconColor),
//             SizedBox(width: 5),
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//                 color: isSelected ? Colors.black : Colors.grey,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
