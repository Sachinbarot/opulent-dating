// // ignore_for_file: library_private_types_in_public_api, prefer_collection_literals, avoid_print, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/Screens/profilePicSet.dart';

import 'package:hookup4u/util/color.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class MyInterests extends StatefulWidget {
  final Map<String, dynamic> userData;

  MyInterests({Key? key, required this.userData}) : super(key: key);


  @override
  _MyInterestsState createState() => _MyInterestsState();
}

class _MyInterestsState extends State<MyInterests> {
  bool _isProcessing = false;

  Set<String> selectedItems = Set<String>();
  Set<String> selectedImages = Set<String>();

  final List<Map<String, dynamic>> imageList = [
    {'name': 'Reading', 'imagePath': 'asset/book.png'},
    {'name': 'Running', 'imagePath': 'asset/Running.png'},
    {'name': 'Cycling', 'imagePath': 'asset/cycl.png'},
    {'name': 'Guitar', 'imagePath': 'asset/Guitar.png'},
    {'name': 'Piano', 'imagePath': 'asset/Piano.png'},
    {'name': 'Photography', 'imagePath': 'asset/Camera.png'},
    {'name': 'Music', 'imagePath': 'asset/Music.png'},
    {'name': 'Whiskey', 'imagePath': 'asset/drink.png'},
    {'name': 'Art', 'imagePath': 'asset/bresh.png'},
    {'name': 'Travel', 'imagePath': 'asset/tree.png'},
    {'name': 'Comedy', 'imagePath': 'asset/comedy.png'},
    {'name': 'Swimming', 'imagePath': 'asset/Swimming.png'},
    {'name': 'Coding', 'imagePath': 'asset/coding.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(children: [
        const SizedBox(
          height: 70,
        ),
        Text(
          "Select up to 5 interests?",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: black,
              fontFamily: AppStrings.fontname),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 15, bottom: 20),
          child: Text(
            'share your interests passions ,and hobbies.We ll connect you with people who share your enthusiasm.',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: black.withOpacity(0.8),
                fontFamily: AppStrings.fontname),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SizedBox(
            height: 50,
            child: TextFormField(
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: "Search Interest",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: btncolor.withOpacity(0.8),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: btncolor.withOpacity(0.8),
                    width: 1.5,
                  ),
                ),
                helperStyle: TextStyle(
                  color: black.withOpacity(0.5),
                  fontSize: 16,
                  fontFamily: AppStrings.fontname,
                  fontWeight: FontWeight.w500,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              ),
              onChanged: (value) {},
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (selectedItems.length < 5 ||
                      selectedItems.contains("Reading")) {
                    if (selectedItems.contains("Reading")) {
                      selectedItems.remove("Reading");
                    } else {
                      selectedItems.add("Reading");

                      //Interest interest = Interest(name: "Reading", iconUrl: "asset/book.png");
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colors.blue,
                        message: 'You can select up to 5 items',
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  color: selectedItems.contains("Reading")
                      ? intrestcolor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/book.png',
                        height: 22,
                        width: 22,
                      ),
                      Text(
                        " Reading",
                        style: TextStyle(
                          color: selectedItems.contains("Reading")
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (selectedItems.length < 5 ||
                      selectedItems.contains("Running")) {
                    if (selectedItems.contains("Running")) {
                      selectedItems.remove("Running");
                    } else {
                      selectedItems.add("Running");
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colors.blue,
                        message: 'You can select up to 5 items',
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  color: selectedItems.contains("Running")
                      ? intrestcolor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/Running.png', // Replace with dynamic image path
                        height: 22,
                        width: 22,
                      ),
                      Text(
                        " Running",
                        style: TextStyle(
                          color: selectedItems.contains("Running")
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (selectedItems.length < 5 ||
                      selectedItems.contains("Cycling")) {
                    if (selectedItems.contains("Cycling")) {
                      selectedItems.remove("Cycling");
                    } else {
                      selectedItems.add("Cycling");
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colors.blue,
                        message: 'You can select up to 5 items',
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  color: selectedItems.contains("Cycling")
                      ? intrestcolor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/cycl.png', // Replace with dynamic image path
                        height: 22,
                        width: 22,
                      ),
                      Text(
                        " Cycling",
                        style: TextStyle(
                          color: selectedItems.contains("Cycling")
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (selectedItems.length < 5 ||
                      selectedItems.contains("Guitar")) {
                    if (selectedItems.contains("Guitar")) {
                      selectedItems.remove("Guitar");
                    } else {
                      selectedItems.add("Guitar");
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colors.blue,
                        message: 'You can select up to 5 items',
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  color: selectedItems.contains("Guitar")
                      ? intrestcolor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/Guitar.png', // Replace with dynamic image path
                        height: 22,
                        width: 22,
                      ),
                      Text(
                        " Guitar",
                        style: TextStyle(
                          color: selectedItems.contains("Guitar")
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (selectedItems.length < 5 ||
                      selectedItems.contains("Piano")) {
                    if (selectedItems.contains("Piano")) {
                      selectedItems.remove("Piano");
                    } else {
                      selectedItems.add("Piano");
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colors.blue,
                        message: 'You can select up to 5 items',
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  color: selectedItems.contains("Piano")
                      ? intrestcolor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/Piano.png',
                        height: 22,
                        width: 22,
                      ),
                      Text(
                        " Piano",
                        style: TextStyle(
                          color: selectedItems.contains("Piano")
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (selectedItems.length < 5 ||
                      selectedItems.contains("Photography")) {
                    if (selectedItems.contains("Photography")) {
                      selectedItems.remove("Photography");
                    } else {
                      selectedItems.add("Photography");
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colors.blue,
                        message: 'You can select up to 5 items',
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  color: selectedItems.contains("Photography")
                      ? intrestcolor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/Camera.png', // Replace with dynamic image path
                        height: 22,
                        width: 22,
                      ),
                      Text(
                        " Photography",
                        style: TextStyle(
                          color: selectedItems.contains("Photography")
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (selectedItems.length < 5 ||
                      selectedItems.contains("Music")) {
                    if (selectedItems.contains("Music")) {
                      selectedItems.remove("Music");
                    } else {
                      selectedItems.add("Music");
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colors.blue,
                        message: 'You can select up to 5 items',
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  color: selectedItems.contains("Music")
                      ? intrestcolor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/Music.png', // Replace with dynamic image path
                        height: 22,
                        width: 22,
                      ),
                      Text(
                        " Music",
                        style: TextStyle(
                          color: selectedItems.contains("Music")
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (selectedItems.length < 5 ||
                      selectedItems.contains("Whiskey")) {
                    if (selectedItems.contains("Whiskey")) {
                      selectedItems.remove("Whiskey");
                    } else {
                      selectedItems.add("Whiskey");
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colors.blue,
                        message: 'You can select up to 5 items',
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  color: selectedItems.contains("Whiskey")
                      ? intrestcolor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/drink.png', // Replace with dynamic image path
                        height: 22,
                        width: 22,
                      ),
                      Text(
                        " Whiskey",
                        style: TextStyle(
                          color: selectedItems.contains("Whiskey")
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (selectedItems.length < 5 ||
                      selectedItems.contains("Art")) {
                    if (selectedItems.contains("Art")) {
                      selectedItems.remove("Art");
                    } else {
                      selectedItems.add("Art");
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colors.blue,
                        message: 'You can select up to 5 items',
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  color: selectedItems.contains("Art")
                      ? intrestcolor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/bresh.png', // Replace with dynamic image path
                        height: 22,
                        width: 22,
                      ),
                      Text(
                        " Art",
                        style: TextStyle(
                          color: selectedItems.contains("Art")
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (selectedItems.length < 5 ||
                      selectedItems.contains("Travel")) {
                    if (selectedItems.contains("Travel")) {
                      selectedItems.remove("Travel");
                    } else {
                      selectedItems.add("Travel");
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colors.blue,
                        message: 'You can select up to 5 items',
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  color: selectedItems.contains("Travel")
                      ? intrestcolor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/tree.png',
                        height: 22,
                        width: 22,
                      ),
                      Text(
                        " Travel",
                        style: TextStyle(
                          color: selectedItems.contains("Travel")
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (selectedItems.length < 5 ||
                      selectedItems.contains("Comedy")) {
                    if (selectedItems.contains("Comedy")) {
                      selectedItems.remove("Comedy");
                    } else {
                      selectedItems.add("Comedy");
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colors.blue,
                        message: 'You can select up to 5 items',
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  color: selectedItems.contains("Comedy")
                      ? intrestcolor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/comedy.png', // Replace with dynamic image path
                        height: 22,
                        width: 22,
                      ),
                      Text(
                        " Comedy",
                        style: TextStyle(
                          color: selectedItems.contains("Comedy")
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  if (selectedItems.length < 5 ||
                      selectedItems.contains("Swimming")) {
                    if (selectedItems.contains("Swimming")) {
                      selectedItems.remove("Swimming");
                    } else {
                      selectedItems.add("Swimming");
                    }
                  } else {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                        backgroundColor: Colors.blue,
                        message: 'You can select up to 5 items',
                      ),
                    );
                  }
                });
              },
              child: Container(
                height: 39,
                decoration: BoxDecoration(
                  color: selectedItems.contains("Swimming")
                      ? intrestcolor
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'asset/Swimming.png', // Replace with dynamic image path
                        height: 22,
                        width: 22,
                      ),
                      Text(
                        " Swimming",
                        style: TextStyle(
                          color: selectedItems.contains("Swimming")
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              if (selectedItems.length < 5 ||
                  selectedItems.contains("Coding")) {
                if (selectedItems.contains("Coding")) {
                  selectedItems.remove("Coding");
                } else {
                  selectedItems.add("Coding");
                }
              } else {
                showTopSnackBar(
                  Overlay.of(context),
                  const CustomSnackBar.success(
                    backgroundColor: Colors.blue,
                    message: 'You can select up to 5 items',
                  ),
                );
              }
            });
          },
          child: Container(
            height: 39,
            width: 130,
            decoration: BoxDecoration(
              color: selectedItems.contains("Coding")
                  ? intrestcolor
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'asset/coding.png',
                    height: 22,
                    width: 22,
                  ),
                  Text(
                    " Coding",
                    style: TextStyle(
                      color: selectedItems.contains("Coding")
                          ? Colors.white
                          : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: MyButton(
              radius: 20.0,
              textname: 'Continue',
              isProcessing: _isProcessing,
              onTap: () async {
                if (selectedItems.length < 3) {
                  showTopSnackBar(
                    Overlay.of(context),
                    const CustomSnackBar.success(
                      backgroundColor: Colors.blue,
                      message: '3 Interested Must Be Compulsory',
                    ),
                  );
                  return;
                }

                setState(() {
                  _isProcessing = !_isProcessing;
                });
                await Future.delayed(const Duration(seconds: 1));
                setState(() {
                  _isProcessing = !_isProcessing;
                });

                Map<String, String> selectedData = {};
                selectedItems.forEach((item) {
                  for (var i = 0; i < imageList.length; i++) {
                    if (imageList[i]['name'] == item) {
                      selectedData[item] = imageList[i]['imagePath'];
                      break;
                    }
                  }
                });

                // widget.userData.addAll({
                //   'MyInterests': {
                //     'data': selectedItems,
                //   }
                // });

                widget.userData.addAll({
                  'MyInterests': {
                    'data': selectedData,
                  }
                });

                //  print(selectedData);

                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ProfilePicSet(widget.userData),
                  ),
                );
              },
            ),
          ),
        )
      ]))),
    );
  }
}
