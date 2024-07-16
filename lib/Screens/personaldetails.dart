// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, avoid_print, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Profile/intrestedscreen.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/util/color.dart';

// ignore: must_be_immutable
class Personaldetails extends StatefulWidget {
  final Map<String, dynamic> userData;

  const Personaldetails(
    this.userData,
  );
  @override
  _PersonaldetailsState createState() => _PersonaldetailsState();
}

class _PersonaldetailsState extends State<Personaldetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> selectedItems = [
    'Yes',
    'English',
    'No item Found',
    'Not Avialable',
    'Items Not Avialable',
    '5 Star',
    'No',
    'No',
    'Educated',
    'Hindu',
    'Good',
    'Man',
  ];
  final List<String> items = ['veryfied', 'nonveryfied'];
  final List<String> itemslan = ['English', 'Hindi', 'Japan', 'Canada'];
  final List<String> sexualitems = ['soon', 'not', 'have', 'last'];
  final List<String> selectedHereItems = ['test', 'not', 'soon', 'tester'];
  final List<String> starItems = [
    '1 star',
    '2 star',
    '3 star',
    '4 star',
    '5 star'
  ];
  final List<String> ChildrenItems = [
    'Yes',
    'No',
  ];
  final List<String> petSelectedItems = [
    'Yes',
    'No',
  ];
  final List<String> smockSelectedItems = [
    'Yes',
    'No',
  ];
  final List<String> drinkSelectedItems = [
    'Yes',
    'No',
  ];
  final List<String> educationSelectedItems = [
    '10',
    '12',
    'Graduation',
    'Post Graduation'
  ];
  final List<String> religionSelectedItems = [
    'Hindu',
    'Monomania',
    'other',
  ];
  final List<String> relationSelectedItems = [
    'Yes',
    'No',
  ];
  final List<String> personalitySelectedItems = [
    'Good',
    'Bad',
  ];
  final List<String> interestedSelectedItems = [
    'Man',
    'Woman',
    'Others',
  ];
  final List<String> orientationlist = [
    'Straight',
    'Gay',
    'Asexual',
    'Lesbian',
    'Bisexual',
    'Demisexual',
  ];
  final LanguageBottomSheet _languageBottomSheet = LanguageBottomSheet();
  final BottomSheetSingleSelect bottomSheetSingleSelect =
      BottomSheetSingleSelect();

  // List<Color> containerColors =
  //     List.filled(13, const Color.fromARGB(255, 201, 194, 193));
  double _currentHeight = 150.0;
  double convertToInch(double cm) {
    return cm / 2.54; // 1 cm = 0.393701 inch
  }

  bool _isProcessing = false;
  @override
  void initState() {
    super.initState();
  }

  List<String> selectedLanguages = [];

  void _openLanguageBottomSheet(List<String> data, int index) {
    _languageBottomSheet.show(context, data, (selectedLanguage) {
      setState(() {
        selectedItems[index] = selectedLanguage;
      });
    });
  }

  void updateSelectedText(List<String> selectedLanguages, int index) {
    setState(() {
      selectedItems[index] = selectedLanguages.join(', ');
    });
  }

  @override
  Widget build(BuildContext context) {
    double inches = convertToInch(_currentHeight);
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
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  bottomSheetSingleSelect.show(
                    context,
                    sexualitems,
                    (selectedLanguages) {
                      updateSelectedText(selectedLanguages, 0);
                    },
                  );
                  //_openLanguageBottomSheet(sexualitems, 0);
                },
                child: man_Value('Sexuality', selectedItems[0]),
              ),
              const SizedBox(height: 25),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: textColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(27, 25, 86, 0.03),
                      offset: Offset(
                        5.0,
                        5.0,
                      ),
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        'Height: ${_currentHeight.toStringAsFixed(0)} cm ( ${inches.toStringAsFixed(2)} inc)',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: AppStrings.fontname,
                            fontWeight: FontWeight.w500,
                            color: btncolor),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Slider(
                      thumbColor: btncolor,
                      activeColor: btncolor,
                      value: _currentHeight,
                      min: 100.0,
                      max: 250.0,
                      divisions: 150,
                      onChanged: (double value) {
                        setState(() {
                          _currentHeight = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  bottomSheetSingleSelect.show(
                    context,
                    itemslan,
                    (selectedLanguages) {
                      updateSelectedText(selectedLanguages, 1);
                    },
                  );
                },
                child: man_Value('Languages', selectedItems[1]),
              ),
              const SizedBox(height: 25),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  bottomSheetSingleSelect.show(
                    context,
                    selectedHereItems,
                    (selectedLanguages) {
                      updateSelectedText(selectedLanguages, 2);
                    },
                  );
                },
                child: man_Value('Here For', selectedItems[2]),
              ),
              const SizedBox(height: 25),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  // _openLanguageBottomSheet(selectedLanguages, 3);

                  bottomSheetSingleSelect.show(
                    context,
                    starItems,
                    (selectedLanguages) {
                      updateSelectedText(selectedLanguages, 3);
                    },
                  );
                },
                child: man_Value('Star Sign', selectedItems[3]),
              ),
              const SizedBox(height: 25),
              Center(
                child: Text("LifeStyle",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: AppStrings.fontname,
                        color: black,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 25),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  // _openLanguageBottomSheet(ChildrenItems, 4);
                  bottomSheetSingleSelect.show(
                    context,
                    ChildrenItems,
                    (selectedLanguages) {
                      updateSelectedText(selectedLanguages, 4);
                    },
                  );
                },
                child: man_Value('Childrens', selectedItems[4]),
              ),
              const SizedBox(height: 25),
              InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    // _openLanguageBottomSheet(petSelectedItems, 5);
                    bottomSheetSingleSelect.show(
                      context,
                      petSelectedItems,
                      (selectedLanguages) {
                        updateSelectedText(selectedLanguages, 5);
                      },
                    );
                  },
                  child: man_Value('Pets', selectedItems[5])),
              const SizedBox(height: 25),
              InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    //_openLanguageBottomSheet(smockSelectedItems, 6);
                    bottomSheetSingleSelect.show(
                      context,
                      smockSelectedItems,
                      (selectedLanguages) {
                        updateSelectedText(selectedLanguages, 6);
                      },
                    );
                  },
                  child: man_Value('Smoking', selectedItems[6])),
              const SizedBox(height: 25),
              InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    //_openLanguageBottomSheet(drinkSelectedItems, 7);
                    bottomSheetSingleSelect.show(
                      context,
                      drinkSelectedItems,
                      (selectedLanguages) {
                        updateSelectedText(selectedLanguages, 7);
                      },
                    );
                  },
                  child: man_Value('Drinking', selectedItems[7])),
              const SizedBox(height: 25),
              InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    //_openLanguageBottomSheet(educationSelectedItems, 8);
                    bottomSheetSingleSelect.show(
                      context,
                      educationSelectedItems,
                      (selectedLanguages) {
                        updateSelectedText(selectedLanguages, 8);
                      },
                    );
                  },
                  child: man_Value('Education', selectedItems[8])),
              const SizedBox(height: 25),
              InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    //_openLanguageBottomSheet(religionSelectedItems, 9);
                    bottomSheetSingleSelect.show(
                      context,
                      religionSelectedItems,
                      (selectedLanguages) {
                        updateSelectedText(selectedLanguages, 9);
                      },
                    );
                  },
                  child: man_Value('Religion', selectedItems[9])),
              const SizedBox(height: 25),
              Center(
                child: Text("Personality",
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: AppStrings.fontname,
                        color: black,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(height: 25),
              InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    //_openLanguageBottomSheet(personalitySelectedItems, 10);
                    bottomSheetSingleSelect.show(
                      context,
                      personalitySelectedItems,
                      (selectedLanguages) {
                        updateSelectedText(selectedLanguages, 10);
                      },
                    );
                  },
                  child: man_Value('Personality', selectedItems[10])),
              const SizedBox(height: 25),
              InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    //_openLanguageBottomSheet(interestedSelectedItems, 11);
                    bottomSheetSingleSelect.show(
                      context,
                      interestedSelectedItems,
                      (selectedLanguages) {
                        updateSelectedText(selectedLanguages, 11);
                      },
                    );
                  },
                  child: man_Value('Interests', selectedItems[11])),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, top: 40),
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
                        'personal': {
                          'selectedTexts': selectedItems,
                          // 'height': _currentHeight
                        },
                        'yourheight': _currentHeight,
                      });

                      widget.userData.addAll({
                        'editInfo': {
                          'userGender': widget.userData['userGender'],
                          'showOnProfile': widget.userData['showOnProfile']
                        }
                      });
                      widget.userData.remove('showOnProfile');
                      //widget.userData.remove('userGender');
                      print(widget.userData);
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) =>
                                  MyInterests(userData: widget.userData)
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

Widget man_Value(text, text2) {
  return Container(
    height: 82,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: textColor,
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(27, 25, 86, 0.05),
          offset: Offset(
            5.0,
            5.0,
          ),
          blurRadius: 15.0,
          spreadRadius: 5.0,
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: 22,
                    color: btncolor,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppStrings.fontname),
              ),
              Text(
                text2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    color: black.withOpacity(0.5),
                    fontFamily: AppStrings.fontname,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child:
              Icon(Icons.arrow_forward_ios_outlined, size: 24, color: btncolor),
        ),
      ],
    ),
  );
}

class LanguageBottomSheet {
  show(BuildContext context, List<String> itemslan,
      Function(String) onSelectLanguage) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Please Select',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: black,
                    fontFamily: AppStrings.fontname),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: itemslan.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(itemslan[index]),
                      onTap: () {
                        onSelectLanguage(itemslan[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class BottomSheetSingleSelect {
  show(BuildContext context, List<String> itemslan,
      Function(List<String>) onSelectLanguage) {
    List<String> selectedLanguages = [];
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Please Select',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: itemslan.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 56,
                          decoration:
                              selectedLanguages.contains(itemslan[index])
                                  ? BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          Color(0x0061D5FF),
                                          Color(0xFF61D5FF),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20))
                                  : const BoxDecoration(),
                          child: ListTile(
                            title: Text(
                              itemslan[index],
                              style: TextStyle(
                                  fontFamily: AppStrings.fontname,
                                  fontWeight: FontWeight.w700,
                                  color: black,
                                  fontSize: 15),
                            ),
                            onTap: () {
                              setState(() {
                                if (selectedLanguages
                                    .contains(itemslan[index])) {
                                  selectedLanguages.remove(itemslan[index]);
                                } else {
                                  selectedLanguages.add(itemslan[index]);
                                }
                              });
                            },
                            trailing:
                                selectedLanguages.contains(itemslan[index])
                                    ? const Icon(Icons.check)
                                    : null,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 38,
                          width: 112,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontFamily: AppStrings.fontname,
                                fontWeight: FontWeight.w700,
                                color: black,
                                fontSize: 16),
                          )),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          onSelectLanguage(selectedLanguages);
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 38,
                          width: 112,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color(0xFF61D5FF),
                                  Color(0x0061D5FF),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: Text(
                            'Apply',
                            style: TextStyle(
                                fontFamily: AppStrings.fontname,
                                fontWeight: FontWeight.w700,
                                color: black,
                                fontSize: 16),
                          )),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
