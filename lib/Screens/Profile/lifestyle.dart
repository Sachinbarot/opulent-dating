// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api, avoid_print, sort_child_properties_last

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Profile/personality.dart';
import 'package:hookup4u/util/color.dart';

// ignore: must_be_immutable
class LifeStyle extends StatefulWidget {
  final Map<String, dynamic> userData;

  var isSelected;

  LifeStyle(this.userData, {super.key});

  @override
  _LifeStyleState createState() => _LifeStyleState();
}

class _LifeStyleState extends State<LifeStyle> {
  String personaldetals = '';
  List<String>? selectedTexts = [];
  List<Color> containerColors =
      List.filled(14, const Color.fromARGB(255, 201, 194, 193));

  @override
  void initState() {
    super.initState();
  }

  void changeColor(int containerNumber, String text) {
    setState(() {
      if (containerNumber >= 0 && containerNumber <= 14) {
        containerColors[containerNumber - 1] =
            containerColors[containerNumber - 1] ==
                    const Color.fromARGB(255, 201, 194, 193)
                ? primaryColor
                : const Color.fromARGB(255, 201, 194, 193);
        if (containerColors[containerNumber - 1] == primaryColor) {
          selectedTexts!.add(text);
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
        duration: const Duration(milliseconds: 50),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: FloatingActionButton(
            elevation: 35,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Center(
                child: Text(
                  "Lifestyle",
                  style: TextStyle(fontSize: 30),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Children",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeColor(1,
                          'YES'); // Call function to change color of container 1
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[0], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.child_friendly, color: Colors.red),
                            const SizedBox(width: 5),
                            Text(
                              'YES  ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[0] == primaryColor
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      changeColor(2, 'NO');
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[1], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.child_care, color: Colors.red),
                            const SizedBox(width: 5),
                            Text(
                              'NO  ',
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
              const SizedBox(height: 35),
              const Text(
                "Pets",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeColor(3,
                          'YES'); // Call function to change color of container 1
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[2], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.pets, color: Colors.red),
                            const SizedBox(width: 5),
                            Text(
                              'YES ',
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
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      changeColor(4, 'NO');
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[3], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.pets_outlined, color: Colors.red),
                            const SizedBox(width: 5),
                            Text(
                              'NO ',
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
              const SizedBox(height: 35),
              const Text(
                "Smoking ",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeColor(5,
                          'YES'); // Call function to change color of container 1
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[4], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.smoking_rooms, color: Colors.white),
                            const SizedBox(width: 5),
                            Text(
                              'YES ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[4] == primaryColor
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      changeColor(6, 'NO');
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[5], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.smoke_free, color: Colors.white),
                            const SizedBox(width: 5),
                            Text(
                              'NO ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[5] == primaryColor
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
              const SizedBox(height: 35),
              const Text(
                "Drinking  ",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeColor(7,
                          'YES'); // Call function to change color of container 1
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[6], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.wine_bar, color: Colors.blue),
                            const SizedBox(width: 5),
                            Text(
                              'YES ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[6] == primaryColor
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      changeColor(8, 'NO');
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[7], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.no_drinks, color: Colors.blue),
                            const SizedBox(width: 5),
                            Text(
                              'NO ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[7] == primaryColor
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
              const SizedBox(height: 35),
              const Text(
                "Education",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeColor(9,
                          'YES'); // Call function to change color of container 1
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[8], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.book_online, color: Colors.white),
                            const SizedBox(width: 5),
                            Text(
                              'YES ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[8] == primaryColor
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      changeColor(10, 'No ');
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[9], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.book_sharp, color: Colors.white),
                            const SizedBox(width: 5),
                            Text(
                              'No ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[9] == primaryColor
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
              const SizedBox(height: 35),
              const Text(
                "Religion ",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeColor(11,
                          'Indian '); // Call function to change color of container 1
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[10], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.flag, color: Colors.red),
                            const SizedBox(width: 5),
                            Text(
                              'Indian ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[10] == primaryColor
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      changeColor(12, 'Others ');
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[11], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.flag_rounded, color: Colors.red),
                            const SizedBox(width: 5),
                            Text(
                              'Others ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[11] == primaryColor
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
              const SizedBox(height: 35),
              const Text(
                "Relationship ",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeColor(13, 'YES ');
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[12], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.girl_outlined, color: Colors.red),
                            const SizedBox(width: 5),
                            Text(
                              'YES ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[12] == primaryColor
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      changeColor(14, 'NO ');
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: containerColors[13], // Use the updated color
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.no_accounts, color: Colors.red),
                            const SizedBox(width: 5),
                            Text(
                              'NO ',
                              style: TextStyle(
                                fontSize: 14,
                                color: containerColors[13] == primaryColor
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
              const SizedBox(height: 35),
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
                        'lifeStyle': {
                          'selectedTexts': selectedTexts,
                        }
                      });
                      widget.userData.remove('showOnProfile');
                      widget.userData.remove('userGender');
                      print(widget.userData);
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Personality(widget.userData)
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
