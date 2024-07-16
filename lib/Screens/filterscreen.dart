import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/util/color.dart';

class FilterScreen extends StatefulWidget {
  final User currentUser;
  final Map items;
  const FilterScreen(this.currentUser, this.items, {super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  Map<String, dynamic> changeValues = {};
  late int freeR;
  late int paidR;

  Future updateData() async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.currentUser.id)
        .set(changeValues, SetOptions(merge: true));
  }

  @override
  void dispose() {
    super.dispose();

    if (changeValues.length > 0) {
      updateData();
    }
  }

  //RangeValues _ageRange = const RangeValues(18, 60);

  String _selectedLanguage = 'English';
  late RangeValues _ageRange;
  var _showMe;
  late int distance;

  bool isPuchased = false;
  @override
  void initState() {
    freeR = widget.items['free_radius'] != null
        ? int.parse(widget.items['free_radius'])
        : 400;
    paidR = widget.items['paid_radius'] != null
        ? int.parse(widget.items['paid_radius'])
        : 400;
    setState(() {
      if (widget.currentUser.maxDistance! > freeR) {
        widget.currentUser.maxDistance = freeR.round();
        changeValues.addAll({'maximum_distance': freeR.round()});
      } else if (widget.currentUser.maxDistance! >= paidR) {
        widget.currentUser.maxDistance = paidR.round();
        changeValues.addAll({'maximum_distance': paidR.round()});
      }
      _showMe = widget.currentUser.showGender;
      distance = widget.currentUser.maxDistance!.round();
      _ageRange = RangeValues(double.parse(widget.currentUser.ageRange!['min']),
          (double.parse(widget.currentUser.ageRange!['max'])));
    });
    print(_showMe);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backcolor,
      appBar: AppBar(
        backgroundColor: backcolor,
        leading: Container(
          padding: const EdgeInsets.all(16),
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "asset/cross.png",
              height: 24,
              width: 24,
            ),
          ),
        ),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Text(
              'Filter & Show',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: black,
                  fontFamily: AppStrings.fontname),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Maximum Distance',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: AppStrings.fontname),
                ),
                Text(
                  widget.currentUser.maxDistance != null
                      ? '$distance KM'
                      : "0 KM",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.7),
                      fontFamily: AppStrings.fontname),
                ),
              ],
            ),
            Slider(
                value: distance.toDouble(),
                inactiveColor: secondryColor,
                min: 1.0,
                max: freeR.toDouble(),
                activeColor: btncolor,
                onChanged: (val) {
                  changeValues.addAll({'maximum_distance': val.round()});
                  setState(() {
                    distance = val.round();
                  });
                }),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Age Range',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontFamily: AppStrings.fontname),
                ),
                Text(
                  "${_ageRange.start.round()}-${_ageRange.end.round()}",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.7),
                      fontFamily: AppStrings.fontname),
                ),
              ],
            ),
            RangeSlider(
                inactiveColor: black,
                values: _ageRange,
                min: 18.0,
                max: 100.0,
                divisions: 82,
                activeColor: btncolor,
                labels: RangeLabels(
                    '${_ageRange.start.round()}', '${_ageRange.end.round()}'),
                onChanged: (val) {
                  changeValues.addAll({
                    'age_range': {
                      'min': '${val.start.truncate()}',
                      'max': '${val.end.truncate()}'
                    }
                  });
                  setState(() {
                    _ageRange = val;
                  });
                }),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Show me",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontFamily: AppStrings.fontname),
                  ),
                  Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text(
                          'Man',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: AppStrings.fontname),
                        ),
                        value: 'man',
                        groupValue: _showMe,
                        onChanged: (value) {
                          setState(() {
                            _showMe = value;
                            changeValues.addAll({
                              'showGender': value,
                            });
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text(
                          'Woman',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: AppStrings.fontname),
                        ),
                        value: 'woman',
                        groupValue: _showMe,
                        onChanged: (value) {
                          setState(() {
                            _showMe = value;
                            changeValues.addAll({
                              'showGender': value,
                            });
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text(
                          'Everyone',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontFamily: AppStrings.fontname),
                        ),
                        value: 'everyone',
                        groupValue: _showMe,
                        onChanged: (value) {
                          setState(() {
                            _showMe = value;
                            changeValues.addAll({
                              'showGender': value,
                            });
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Select Language'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: const Text('English'),
                            onTap: () {
                              setState(() {
                                _selectedLanguage = 'English';
                              });
                              Navigator.pop(context); // Close the dialog
                            },
                          ),
                          ListTile(
                            title: const Text('Spanish'),
                            onTap: () {
                              setState(() {
                                _selectedLanguage = 'Spanish';
                              });
                              Navigator.pop(context); // Close the dialog
                            },
                          ),
                          ListTile(
                            title: const Text('French'),
                            onTap: () {
                              setState(() {
                                _selectedLanguage = 'French';
                              });
                              Navigator.pop(context); // Close the dialog
                            },
                          ),
                          ListTile(
                            title: const Text('German'),
                            onTap: () {
                              setState(() {
                                _selectedLanguage = 'German';
                              });
                              Navigator.pop(context); // Close the dialog
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), color: white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _selectedLanguage,
                        style: TextStyle(
                            fontSize: 18.0,
                            color: black.withOpacity(0.6),
                            fontFamily: AppStrings.fontname,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.arrow_forward_ios),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60.0),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 54,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34), color: pink),
                child: Center(
                    child: Text(
                  'Apply',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: white,
                      fontFamily: AppStrings.fontname),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
