// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, prefer_const_constructors, sort_child_properties_last, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/snackbar.dart';
import 'AllowLocation.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchLocation extends StatefulWidget {
  final Map<String, dynamic> userData;
  const SearchLocation(this.userData, {super.key});

  @override
  _SearchLocationState createState() => _SearchLocationState();
}

//Add here your mapbox token under ""
//String mapboxApi = "<----- Add here your mapbox token-->";
String mapboxApi =
    "pk.eyJ1Ijoic2NvdGhpcyIsImEiOiJjaWp1Y2ltYmUwMDBicmJrdDQ4ZDBkaGN4In0.sbihZCZJ56-fsFNKHXF8YQ";

class _SearchLocationState extends State<SearchLocation> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late MapBoxPlace _mapBoxPlace;
  TextEditingController _city = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backcolor,
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
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
            child: Padding(
                padding: EdgeInsets.only(left: 7),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 22,
                )),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Padding(
                  child: Text(
                    "Select\nyour city".tr().toString(),
                    style: TextStyle(fontSize: 40),
                  ),
                  padding: EdgeInsets.only(left: 50, top: 120),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        autofocus: false,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "Enter your city name",
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor)),
                          helperText: "This is how it will appear in App.",
                          helperStyle:
                              TextStyle(color: secondryColor, fontSize: 15),
                        ),
                        controller: _city,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapBoxAutoCompleteWidget(
                                language: 'en',
                                closeOnSelect: true,
                                apiKey: mapboxApi,
                                limit: 10,
                                hint: 'Enter your city name',
                                onSelect: (place) {
                                  setState(() {
                                    _mapBoxPlace = place;
                                    _city.text = _mapBoxPlace.placeName!;
                                  });
                                },
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
                _city.text.length > 0
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: InkWell(
                            child: commanbtn(20.0, 'Continue'),
                            onTap: () async {
                              widget.userData.addAll(
                                {
                                  'location': {
                                    'latitude':
                                        _mapBoxPlace.geometry!.coordinates![1],
                                    'longitude':
                                        _mapBoxPlace.geometry!.coordinates![0],
                                    'address': "${_mapBoxPlace.placeName}"
                                  },
                                  'maximum_distance': 20,
                                  'age_range': {
                                    'min': "20",
                                    'max': "50",
                                  },
                                },
                              );

                              showWelcomDialog(context);
                              setUserData(widget.userData);
                            },
                          ),
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
                                height:
                                    MediaQuery.of(context).size.height * .065,
                                width: MediaQuery.of(context).size.width * .75,
                                child: Center(
                                    child: Text(
                                  "CONTINUE".tr().toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: secondryColor,
                                      fontWeight: FontWeight.bold),
                                ))),
                            onTap: () {
                              CustomSnackbar.snackbar(
                                  "Select a location !".tr().toString(),
                                  context);
                            },
                          ),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
