// ignore_for_file: deprecated_member_use, library_prefixes, library_private_types_in_public_api, prefer_typing_uninitialized_variables, prefer_final_fields, prefer_is_empty, avoid_print, sort_child_properties_last, await_only_futures, no_leading_underscores_for_local_identifiers, avoid_function_literals_in_foreach_calls
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/UpdateLocation.dart';
import 'package:hookup4u/Screens/auth/login.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/ads/ads.dart';
import 'package:hookup4u/models/user_model.dart' as userD;
import 'package:hookup4u/util/color.dart';
// import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'UpdateNumber.dart';
import 'package:easy_localization/easy_localization.dart';

class Settings extends StatefulWidget {
  final userD.User currentUser;
  final bool isPurchased;
  final Map items;
  const Settings(this.currentUser, this.isPurchased, this.items, {super.key});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, dynamic> changeValues = {};
  bool isCardEnabled = true;
  late RangeValues ageRange;
  var _showMe;
  late int distance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final BannerAd myBanner = BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );
  late AdWidget adWidget;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final AdSize adSize = const AdSize(height: 300, width: 50);
  @override
  void dispose() {
    myBanner.dispose();
    super.dispose();

    if (changeValues.length > 0) {
      updateData();
    }
  }

  final String clientId = '368995522410599';
  final String redirectUrl = 'https://api.instagram.com/';
  final String responseType = 'db61eb007d086635f15a744fe76fad82';

  Future<void> _launchInstagramAuth() async {
    String authUrl =
        'https://api.instagram.com/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUrl&response_type=$responseType';
    if (await canLaunch(authUrl)) {
      await launch(authUrl);
    } else {
      throw 'Could not launch $authUrl';
    }
  }

  final BannerAdListener listener = BannerAdListener(
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
    onAdOpened: (Ad ad) => print('Ad opened.'),
    onAdClosed: (Ad ad) => print('Ad closed.'),
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
  Future updateData() async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.currentUser.id)
        .set(changeValues, SetOptions(merge: true));
  }

  late int freeR;
  late int paidR;

  @override
  void initState() {
    adWidget = AdWidget(ad: myBanner);
    super.initState();
    myBanner.load();

    freeR = widget.items['free_radius'] != null
        ? int.parse(widget.items['free_radius'])
        : 400;
    paidR = widget.items['paid_radius'] != null
        ? int.parse(widget.items['paid_radius'])
        : 400;
    setState(() {
      if (!widget.isPurchased && widget.currentUser.maxDistance! > freeR) {
        widget.currentUser.maxDistance = freeR.round();
        changeValues.addAll({'maximum_distance': freeR.round()});
      } else if (widget.isPurchased &&
          widget.currentUser.maxDistance! >= paidR) {
        widget.currentUser.maxDistance = paidR.round();
        changeValues.addAll({'maximum_distance': paidR.round()});
      }
      _showMe = widget.currentUser.showGender;
      distance = widget.currentUser.maxDistance!.round();
      ageRange = RangeValues(double.parse(widget.currentUser.ageRange!['min']),
          (double.parse(widget.currentUser.ageRange!['max'])));
    });
    print(_showMe);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backcolor,
      appBar: commonAppBar(context, 'Settings'),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Image.asset(
                "asset/upgrade.png",
                fit: BoxFit.contain,
              ),
            ),

            // Container(
            //   alignment: Alignment.center,
            //   child: adWidget,
            //   width: myBanner.size.width.toDouble(),
            //   height: myBanner.size.height.toDouble(),
            // ),

            ListTile(
              title: Card(
                  elevation: 4,
                  color: white,
                  surfaceTintColor: white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Phone Number",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: AppStrings.fontname,
                                color: black.withOpacity(0.5)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                            ),
                            child: Text(
                              widget.currentUser.phoneNumber != null
                                  ? "${widget.currentUser.phoneNumber}"
                                  : "Verify Now",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppStrings.fontname,
                                  color: black),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: btncolor,
                            size: 15,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) =>
                                    UpdateNumber(widget.currentUser)));
                        //      _ads.disable(_ad);
                      },
                    ),
                  )),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "Verify a phone number to secure your account",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppStrings.fontname,
                      color: btncolor.withOpacity(0.8)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Discovery settings",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppStrings.fontname,
                    color: black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Card(
                elevation: 4,
                color: white,
                surfaceTintColor: white,
                child: ExpansionTile(
                  iconColor: btncolor,
                  collapsedIconColor: btncolor,
                  key: UniqueKey(),
                  leading: Text(
                    "Current location : ",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: AppStrings.fontname,
                        color: black.withOpacity(0.5),
                        fontWeight: FontWeight.w500),
                  ),
                  title: Text(
                    widget.currentUser.address!,
                    style: TextStyle(
                      color: btncolor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: btncolor,
                            size: 25,
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Text(
                              "Change location",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: btncolor,
                                fontSize: 16,
                                fontFamily: AppStrings.fontname,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () async {
                              var address = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UpdateLocation()));
                              print(address);
                              if (address != null) {
                                _updateAddress(address);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
              ),
              child: Text(
                "Change your location to see members in other city",
                style: TextStyle(
                    color: btncolor.withOpacity(0.8),
                    fontFamily: AppStrings.fontname,
                    fontWeight: FontWeight.w400,
                    fontSize: 13),
              ),
            ),
            const SizedBox(
              height: 31,
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              child: Center(
                child: Image.asset(
                  "asset/email.png",
                  height: 95,
                  width: double.infinity,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Card(
            //     color: backcolor,
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: <Widget>[
            //           Text(
            //             "Show me",
            //             style: TextStyle(
            //                 fontSize: 18,
            //                 color: black.withOpacity(0.5),
            //                 fontWeight: FontWeight.w500),
            //           ),
            //           ListTile(
            //             title: DropdownButton(
            //               iconEnabledColor: btncolor,
            //               iconDisabledColor: secondryColor,
            //               isExpanded: true,
            //               items: [
            //                 DropdownMenuItem(
            //                   child: Text("Man".tr().toString()),
            //                   value: "man",
            //                 ),
            //                 DropdownMenuItem(
            //                     child: Text("Woman".tr().toString()),
            //                     value: "woman"),
            //                 DropdownMenuItem(
            //                     child: Text("Everyone".tr().toString()),
            //                     value: "everyone"),
            //               ],
            //               onChanged: (val) {
            //                 changeValues.addAll({
            //                   'showGender': val,
            //                 });
            //                 setState(() {
            //                   _showMe = val;
            //                 });
            //               },
            //               value: _showMe,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Card(
            //     color: backcolor,
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: ListTile(
            //         title: Text(
            //           "Maximum distance".tr().toString(),
            //           style: TextStyle(
            //               fontSize: 18,
            //               color: black.withOpacity(0.5),
            //               fontWeight: FontWeight.w500),
            //         ),
            //         trailing: Text(
            //           "$distance Km.",
            //           style: TextStyle(
            //               fontSize: 16,
            //               fontFamily: AppStrings.fontname,
            //               fontWeight: FontWeight.w600,
            //               color: black),
            //         ),
            //         subtitle: Slider(
            //             value: distance.toDouble(),
            //             inactiveColor: secondryColor,
            //             min: 1.0,
            //             max: widget.isPurchased
            //                 ? paidR.toDouble()
            //                 : freeR.toDouble(),
            //             activeColor: btncolor,
            //             onChanged: (val) {
            //               changeValues
            //                   .addAll({'maximum_distance': val.round()});
            //               setState(() {
            //                 distance = val.round();
            //               });
            //             }),
            //       ),
            //     ),
            //   ),
            // ),

            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Card(
            //     color: backcolor,
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: ListTile(
            //         title: Text(
            //           "Age range".tr().toString(),
            //           style: TextStyle(
            //               fontSize: 18,
            //               fontFamily: AppStrings.fontname,
            //               color: black.withOpacity(0.5),
            //               fontWeight: FontWeight.w500),
            //         ),
            //         trailing: Text(
            //           "${ageRange.start.round()}-${ageRange.end.round()}",
            //           style: const TextStyle(fontSize: 16),
            //         ),
            //         subtitle: RangeSlider(
            //             inactiveColor: white,
            //             values: ageRange,
            //             min: 18.0,
            //             max: 100.0,
            //             divisions: 25,
            //             activeColor: btncolor,
            //             labels: RangeLabels('${ageRange.start.round()}',
            //                 '${ageRange.end.round()}'),
            //             onChanged: (val) {
            //               changeValues.addAll({
            //                 'age_range': {
            //                   'min': '${val.start.truncate()}',
            //                   'max': '${val.end.truncate()}'
            //                 }
            //               });
            //               setState(() {
            //                 ageRange = val;
            //               });
            //             }),
            //       ),
            //     ),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Card(
                elevation: 4,
                color: white,
                surfaceTintColor: white,
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (isCardEnabled) {
                      // Share.share('check out my website ',
                      //     subject: 'Look what I made!');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: Text(
                        "Invite Your Friends",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: AppStrings.fontname,
                          color: lightgrey.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Card(
                  elevation: 4,
                  color: white,
                  surfaceTintColor: white,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: Text(
                        "Connect with instagram",
                        style: TextStyle(
                            fontFamily: AppStrings.fontname,
                            color: lightgrey.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  _launchInstagramAuth();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Card(
                  elevation: 4,
                  color: white,
                  surfaceTintColor: white,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            fontFamily: AppStrings.fontname,
                            color: black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Logout',
                            style: TextStyle(
                                fontFamily: AppStrings.fontname,
                                color: black,
                                fontSize: 22,
                                fontWeight: FontWeight.w700)),
                        content: Text('Do you want to logout your account?',
                            style: TextStyle(
                                fontFamily: AppStrings.fontname,
                                color: black.withOpacity(0.67),
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('No',
                                style: TextStyle(
                                    fontFamily: AppStrings.fontname,
                                    color: black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400)),
                          ),
                          TextButton(
                            onPressed: () async {
                              await _auth.signOut().whenComplete(() {
                                print(
                                    '---------------------delete--------------');
                                try {
                                  _firebaseMessaging
                                      .deleteToken()
                                      .then((value) {
                                    print(
                                        '---------------------deletedfdf--------------');
                                  });
                                } catch (e) {
                                  print('-----------------$e');
                                }

                                Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Login()),
                                );
                              });
                              //           _ads.disable(_ad);
                            },
                            child: Text('Yes',
                                style: TextStyle(
                                    fontFamily: AppStrings.fontname,
                                    color: black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Card(
                  elevation: 4,
                  color: white,
                  surfaceTintColor: white,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Center(
                      child: Text(
                        "Delete Account",
                        style: TextStyle(
                            fontFamily: AppStrings.fontname,
                            color: black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Account',
                            style: TextStyle(
                                fontFamily: AppStrings.fontname,
                                color: black,
                                fontSize: 22,
                                fontWeight: FontWeight.w700)),
                        content: Text('Do You Want To Delete Your Account?',
                            style: TextStyle(
                                fontFamily: AppStrings.fontname,
                                color: black.withOpacity(0.67),
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('No',
                                style: TextStyle(
                                    fontFamily: AppStrings.fontname,
                                    color: black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400)),
                          ),
                          TextButton(
                            onPressed: () async {
                              final User user = await _auth.currentUser!;
                              //.then((FirebaseUser user) {
                              //return user;
                              //});
                              await _deleteUser(user).then((_) async {
                                await _auth.signOut().whenComplete(() {
                                  Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => Login()),
                                  );
                                });
                              });
                            },
                            child: Text('Yes',
                                style: TextStyle(
                                    fontFamily: AppStrings.fontname,
                                    color: black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SizedBox(
                      height: 100,
                      width: 200,
                      child: Image.asset(
                        "asset/darklogo.png",
                        fit: BoxFit.contain,
                      )),
                )),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  void _updateAddress(Map _address) {
    showCupertinoModalPopup(
        context: context,
        builder: (ctx) {
          return Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .4,
            child: Column(
              children: <Widget>[
                Material(
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'New address:'.tr().toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.cancel,
                        color: Colors.black26,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    subtitle: Card(
                      elevation: 4,
                      color: white,
                      surfaceTintColor: white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _address['PlaceName'] ?? '',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  //  color: Colors.white,
                  child: Text(
                    "Confirm".tr().toString(),
                    style: TextStyle(color: newtextcolor),
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    await FirebaseFirestore.instance
                        .collection("Users")
                        .doc('${widget.currentUser.id}')
                        .update({
                          'location': {
                            'latitude': _address['latitude'],
                            'longitude': _address['longitude'],
                            'address': _address['PlaceName']
                          },
                        })
                        .whenComplete(() => showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) {
                              Future.delayed(const Duration(seconds: 3), () {
                                setState(() {
                                  widget.currentUser.address =
                                      _address['PlaceName'];
                                });

                                Navigator.pop(context);
                              });
                              return Center(
                                  child: Container(
                                      width: 160.0,
                                      height: 120.0,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        children: <Widget>[
                                          Image.asset(
                                            "asset/auth/verified.jpg",
                                            height: 60,
                                            color: pink,
                                            colorBlendMode: BlendMode.color,
                                          ),
                                          Text(
                                            "location\nchanged".tr().toString(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                decoration: TextDecoration.none,
                                                color: Colors.black,
                                                fontSize: 20),
                                          )
                                        ],
                                      )));
                            }))
                        .catchError((e) {
                          print(e);
                        });

                    // .then((_) {
                    //   Navigator.pop(context);
                    // });
                  },
                )
              ],
            ),
          );
        });
  }

  Future _deleteUser(User user) async {
    // user.delete();
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection('CheckedUser')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection("CheckedUser")
            .doc(element.id)
            .delete()
            .then((value) => print("success"));
      });
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection('LikedBy')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection("LikedBy")
            .doc(element.id)
            .delete()
            .then((value) => print("success"));
      });
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection('Matches')
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection("Matches")
            .doc(element.id)
            .delete()
            .then((value) => print("success"));
      });
    });
    await FirebaseFirestore.instance.collection("Users").doc(user.uid).delete();
  }
}
