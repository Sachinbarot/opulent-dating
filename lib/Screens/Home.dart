// ignore_for_file: unused_field, prefer_final_fields, library_private_types_in_public_api, avoid_print, unnecessary_this, prefer_is_empty, use_build_context_synchronously, curly_braces_in_flow_control_structures, avoid_types_as_parameter_names, file_names

import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hookup4u/Screens/Calling/utils/settings.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Chat/Matches.dart';
import 'package:hookup4u/Screens/Chat/chatPage.dart';
import 'package:hookup4u/Screens/Information.dart';
import 'package:hookup4u/Screens/Payment/subscriptions.dart';
import 'package:hookup4u/Screens/Tab.dart';
import 'package:hookup4u/Screens/filterscreen.dart';
import 'package:hookup4u/ads/ads.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/swipe_stack.dart';
import 'package:hookup4u/util/color.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

List<IconData> iconIndexdata = [
  Icons.person,
  Icons.tab,
  Icons.abc,
  Icons.access_alarm,
  Icons.home,
  Icons.kayaking,
  Icons.star,
  Icons.h_mobiledata_outlined,
];
List userRemoved = [];
int countswipe = 1;

class CardPictures extends StatefulWidget {
  final List<User> users;

  final User currentUser;
  final int swipedcount;
  final Map items;

  const CardPictures(this.currentUser, this.users, this.swipedcount, this.items,
      {super.key});

  @override
  _CardPicturesState createState() => _CardPicturesState();
}

class _CardPicturesState extends State<CardPictures>
    with AutomaticKeepAliveClientMixin<CardPictures> {
  bool onEnd = false;
  List<User>? matches;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  late AdWidget adWidget;
  final AdSize adSize = const AdSize(height: 300, width: 50);
  bool _isBannerAdReady = true;
  GlobalKey<SwipeStackState> swipeKey = GlobalKey<SwipeStackState>();
  @override
  bool get wantKeepAlive => true;
  ScrollController _scrollController = ScrollController();
  CollectionReference docRef = FirebaseFirestore.instance.collection('Users');

  Future<void> sendNotification(pushtokan) async {
    try {
      if (widget.users.isNotEmpty) {
        var headers = {
          'Authorization': 'key=$SERVER_KEY',
          'Content-Type': 'application/json'
        };
        var data = json.encode({
          "to": pushtokan,
          "notification": {"body": "Like by ${widget.currentUser.name}"},
          "priority": "high"
        });
        var dio = Dio();
        var response = await dio.post(
          'https://fcm.googleapis.com/fcm/send',
          options: Options(
            headers: headers,
          ),
          data: data,
        );

        if (response.statusCode == 200) {
          print(json.encode(response.data));
        } else {
          print(response.statusMessage);
        }
      }
    } catch (e) {
      print('Error sending notification: $e');
    }
  }

  @override
  void initState() {
    print("here home 8");
    print(
        "Users => ${FirebaseFirestore.instance.collection("Users").snapshots().first.then((value) {
      print("Something => ${value.docs[0]['UserName']}");
    })}");
    print(matches);
    FirebaseMessaging.instance.getToken().then((token) {
      print('token)))))))))$token');
      docRef.doc(widget.currentUser.id.toString()).update({
        'pushToken': token,
      });
    });
    //fetchMoreUsers();
    adds();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });
    super.initState();
  }

  List<String?>? interests;
  List<Widget> interestRows = [];
  Future<void> adds() async {
    await InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  List<IconData> iconIndexdata = [
    Icons.person,
    Icons.ac_unit,
    Icons.abc,
    Icons.access_alarm,
    Icons.home,
    Icons.kayaking,
    Icons.h_mobiledata,
  ];
  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  final BannerAdListener listener = BannerAdListener(
    onAdLoaded: (Ad ad) {
      print('Ad loaded.');
    },
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
    onAdOpened: (Ad ad) => print('Ad opened.'),
    onAdClosed: (Ad ad) => print('Ad closed.'),
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
  List<String>? personalList;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print(
        '//////////////////////////////-${widget.users}-///////////////////////////////////');

    int freeSwipe = widget.items['free_swipes'] != null
        ? int.parse(widget.items['free_swipes'])
        : 10;
    bool exceedSwipes = widget.swipedcount >= freeSwipe;
    return Scaffold(
      backgroundColor: backcolor,
      appBar: AppBar(
        backgroundColor: backcolor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Text(
                    'Opulent',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: pink,
                        fontFamily: AppStrings.fontname),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              FilterScreen(widget.currentUser, widget.items)));
                },
                child: Image.asset(
                  'asset/filter.png',
                  height: 24,
                  width: 24,
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: backcolor),
          child: LayoutBuilder(builder:
              (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
                child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  child: AbsorbPointer(
                    absorbing: exceedSwipes,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: backcolor,
                          ),
                          height: MediaQuery.of(context).size.height * .9,
                          width: MediaQuery.of(context).size.width * 1,
                          child: widget.users.length == 0
                              ? Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          backgroundColor: btncolor,
                                          radius: 40,
                                        ),
                                      ),
                                      Text(
                                        "There's No One New Around You.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: black,
                                            fontFamily: AppStrings.fontname,
                                            fontWeight: FontWeight.w700,
                                            decoration: TextDecoration.none,
                                            fontSize: 18),
                                      )
                                    ],
                                  ),
                                )
                              : SwipeStack(
                                  key: swipeKey,
                                  children: widget.users.map((index) {
                                    return SwiperItem(builder:
                                        (SwiperPosition position,
                                            double progress) {
                                      return Material(
                                          elevation: 5,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(30)),
                                              color: backcolor,
                                            ),
                                            child: Stack(
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(30)),
                                                  child: Swiper(
                                                    customLayoutOption:
                                                        CustomLayoutOption(
                                                      stateCount: 0,
                                                      startIndex: 0,
                                                    ),
                                                    key: UniqueKey(),
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index2) {
                                                      return SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              1,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: index.personal!
                                                                  .isNotEmpty
                                                              ? ListView
                                                                  .builder(
                                                                      scrollDirection:
                                                                          Axis
                                                                              .vertical,
                                                                      itemCount:
                                                                          1,
                                                                      itemBuilder:
                                                                          (BuildContext context,
                                                                              int imageIndex) {
                                                                        return Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(
                                                                              height: MediaQuery.of(context).size.height * 0.8,
                                                                              child: Stack(
                                                                                children: [
                                                                                  Positioned.fill(
                                                                                    child: CachedNetworkImage(
                                                                                      imageUrl: index.imageUrl![index2] ?? "",
                                                                                      fit: BoxFit.cover,
                                                                                      useOldImageOnUrlChange: true,
                                                                                      placeholder: (context, url) => const CupertinoActivityIndicator(
                                                                                        radius: 30,
                                                                                      ),
                                                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                                    ),
                                                                                  ),
                                                                                  Positioned(
                                                                                    bottom: MediaQuery.of(context).size.height * 0.03,
                                                                                    left: MediaQuery.of(context).size.width * 0.03,
                                                                                    right: MediaQuery.of(context).size.width * 0.03,
                                                                                    child: GestureDetector(
                                                                                      onTap: () {
                                                                                        // _loadInterstitialAd();
                                                                                        // _interstitialAd?.show();
                                                                                        // showDialog(
                                                                                        //   barrierDismissible: false,
                                                                                        //   context: context,
                                                                                        //   builder: (context) {
                                                                                        //     return Info(index, widget.currentUser, swipeKey);
                                                                                        //   },
                                                                                        // );
                                                                                      },
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.min,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                onTap: () async {
                                                                                                  await sendNotification(widget.users[index2].pushToken);
                                                                                                },
                                                                                                child: CircleAvatar(
                                                                                                  radius: MediaQuery.of(context).size.width * 0.08,
                                                                                                  backgroundColor: pink,
                                                                                                  child: Image.asset(
                                                                                                    'asset/heart.png',
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              const Spacer(),
                                                                                              InkWell(
                                                                                                splashColor: Colors.transparent,
                                                                                                highlightColor: Colors.transparent,
                                                                                                onTap: () {
                                                                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Subscription(null, null, widget.items)));
                                                                                                },
                                                                                                child: CircleAvatar(
                                                                                                  radius: MediaQuery.of(context).size.width * 0.08,
                                                                                                  backgroundColor: btncolor,
                                                                                                  child: Image.asset(
                                                                                                    'asset/star.png',
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          InkWell(
                                                                                            splashColor: Colors.transparent,
                                                                                            highlightColor: Colors.transparent,
                                                                                            onTap: () {
                                                                                              _loadInterstitialAd();
                                                                                              _interstitialAd?.show();
                                                                                              showDialog(
                                                                                                barrierDismissible: false,
                                                                                                context: context,
                                                                                                builder: (context) {
                                                                                                  return Info(index, widget.currentUser, swipeKey);
                                                                                                },
                                                                                              );
                                                                                            },
                                                                                            child: Text(
                                                                                              "${index.name!}, ${index.editInfo != null && index.editInfo!['showMyAge'] != null ? !index.editInfo!['showMyAge'] ? index.age : "" : index.age}",
                                                                                              style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600, fontFamily: AppStrings.fontname),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),

                                                                            // const SizedBox(height: 25),
                                                                            // const Padding(
                                                                            //   padding: EdgeInsets.only(left: 10),
                                                                            //   child: Text(
                                                                            //     "Interest",
                                                                            //     style: TextStyle(fontSize: 18, fontFamily: AppStrings.fontname, fontWeight: FontWeight.w600),
                                                                            //   ),
                                                                            // ),
                                                                            // const SizedBox(height: 15),
                                                                            // Container(
                                                                            //   margin: const EdgeInsets.only(left: 5, right: 5),
                                                                            //   child: Column(
                                                                            //     children: [
                                                                            //       GridView.builder(
                                                                            //         shrinkWrap: true,
                                                                            //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2.0),
                                                                            //         itemCount: index.personal!.length,
                                                                            //         itemBuilder: (context, index1) {
                                                                            //           int uniqueIconIndex = (index1 * 10) % iconIndexdata.length;
                                                                            //           return buildRowContainers([
                                                                            //             index.personal![index1]
                                                                            //           ], uniqueIconIndex);
                                                                            //         },
                                                                            //       ),
                                                                            //     ],
                                                                            //   ),
                                                                            // ),
                                                                            // const SizedBox(height: 125),

                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                '${index.name!}(${index.age})',
                                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.7), fontFamily: 'fontname'),
                                                                              ),
                                                                            ),

                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  const Icon(Icons.female),
                                                                                  Text(
                                                                                    index.userGender.toString(),
                                                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: black.withOpacity(0.9), fontFamily: AppStrings.fontname),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Image.asset(
                                                                                    'asset/height.png',
                                                                                    height: 20,
                                                                                    width: 20,
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    '${index.yourheight} (CM)',
                                                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: black.withOpacity(0.9), fontFamily: AppStrings.fontname),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Image.asset(
                                                                                    'asset/university.png',
                                                                                    height: 20,
                                                                                    width: 20,
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Text(
                                                                                    'University of arts AND Design',
                                                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: black.withOpacity(0.9), fontFamily: AppStrings.fontname),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Image.asset(
                                                                                    'asset/hom.png',
                                                                                    height: 20,
                                                                                    width: 20,
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      maxLines: 1,
                                                                                      'Live in ${index.address}',
                                                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.9), fontFamily: AppStrings.fontname),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Image.asset(
                                                                                    'asset/maps.png',
                                                                                    height: 20,
                                                                                    width: 20,
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 5,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Text(
                                                                                      index.distanceBW.toString(),
                                                                                      maxLines: 1,
                                                                                      overflow: TextOverflow.ellipsis,
                                                                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.9), fontFamily: AppStrings.fontname),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),

                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                'About Me',
                                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: black, fontFamily: AppStrings.fontname),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                widget.users[0].AboutMe.toString(),
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: black.withOpacity(0.5), fontFamily: AppStrings.fontname),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                'Interest',
                                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: black, fontFamily: AppStrings.fontname),
                                                                              ),
                                                                            ),

                                                                            Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                left: 5,
                                                                              ),
                                                                              child: SizedBox(
                                                                                height: 145,
                                                                                child: ListView(
                                                                                  children: List.generate(
                                                                                    (widget.users[0].MyInterests!.length / 3).ceil(),
                                                                                    (rowIndex) {
                                                                                      int startIndex = rowIndex * 3;
                                                                                      int endIndex = startIndex + 3;
                                                                                      if (endIndex > widget.users[0].MyInterests!.length) {
                                                                                        endIndex = widget.users[0].MyInterests!.length;
                                                                                      }
                                                                                      return Row(
                                                                                        children: List.generate(
                                                                                          endIndex - startIndex,
                                                                                          (index) {
                                                                                            String name = widget.users[0].MyInterests!.keys.elementAt(startIndex + index);
                                                                                            String? imagePath = widget.users[0].MyInterests![name];
                                                                                            return _buildInterestContainer(name, imagePath!);
                                                                                          },
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),

                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                'Language I Know ',
                                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: black, fontFamily: AppStrings.fontname),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 39,
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(),
                                                                                      borderRadius: BorderRadius.circular(30),
                                                                                      color: white,
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Center(
                                                                                        child: Row(
                                                                                          children: [
                                                                                            const Icon(
                                                                                              Icons.translate,
                                                                                              size: 15,
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              width: 3,
                                                                                            ),
                                                                                            Text(
                                                                                              index.personal![1],
                                                                                              style: TextStyle(fontFamily: AppStrings.fontname, fontSize: 16, fontWeight: FontWeight.w500, color: black),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),

                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                'Religion',
                                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: black, fontFamily: AppStrings.fontname),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 39,
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(),
                                                                                      borderRadius: BorderRadius.circular(30),
                                                                                      color: white,
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Center(
                                                                                        child: Row(
                                                                                          children: [
                                                                                            const Icon(
                                                                                              Icons.translate,
                                                                                              size: 15,
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              width: 3,
                                                                                            ),
                                                                                            Text(
                                                                                              index.personal![9],
                                                                                              style: TextStyle(fontFamily: AppStrings.fontname, fontSize: 16, fontWeight: FontWeight.w500, color: black),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 32,
                                                                            ),

                                                                            widget.users.length != 0
                                                                                ? Center(
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () {
                                                                                        if (userRemoved.length > 0) {
                                                                                          swipeKey.currentState!.rewind();
                                                                                        }
                                                                                      },
                                                                                      child: Container(
                                                                                        height: 82,
                                                                                        width: 82,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: pink),
                                                                                        child: Center(
                                                                                          child: Icon(
                                                                                            userRemoved.length > 0 ? Icons.replay : Icons.not_interested,
                                                                                            color: userRemoved.length > 0 ? Colors.amber : secondryColor,
                                                                                            size: 20,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : Center(
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () {},
                                                                                      child: Container(
                                                                                        height: 82,
                                                                                        width: 82,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: pink),
                                                                                        child: const Center(
                                                                                          child: Icon(
                                                                                            Icons.refresh,
                                                                                            color: Colors.green,
                                                                                            size: 20,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Center(
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () {
                                                                                        if (widget.users.length > 0) {
                                                                                          print("object");
                                                                                          swipeKey.currentState!.swipeLeft();
                                                                                        }
                                                                                      },
                                                                                      child: Container(
                                                                                        height: 61,
                                                                                        width: 61,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: btncolor),
                                                                                        child: const Center(
                                                                                            child: Icon(
                                                                                          Icons.close,
                                                                                          size: 30,
                                                                                        )),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Center(
                                                                                    child: InkWell(
                                                                                      splashColor: Colors.transparent,
                                                                                      highlightColor: Colors.transparent,
                                                                                      onTap: () {
                                                                                        if (widget.users.length > 0) {
                                                                                          swipeKey.currentState!.swipeRight();
                                                                                        }
                                                                                      },
                                                                                      child: Container(
                                                                                        height: 61,
                                                                                        width: 61,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: btncolor),
                                                                                        child: const Center(
                                                                                            child: Icon(
                                                                                          Icons.check,
                                                                                          size: 30,
                                                                                        )),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 20,
                                                                            ),

                                                                            Center(
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  swipeKey.currentState!.swipeLeft();
                                                                                  showTopSnackBar(
                                                                                    Overlay.of(context),
                                                                                    const CustomSnackBar.success(
                                                                                      backgroundColor: Colors.red,
                                                                                      message: 'User Reported',
                                                                                    ),
                                                                                  );
                                                                                },
                                                                                child: Text(
                                                                                  'Hide And Report ',
                                                                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: black, fontFamily: AppStrings.fontname),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 100,
                                                                            )
                                                                          ],
                                                                        );
                                                                      })
                                                              : Container()
                                                          // child: Image.network(
                                                          //   index.imageUrl[index2],
                                                          //   fit: BoxFit.cover,
                                                          // ),
                                                          );
                                                    },
                                                    itemCount:
                                                        index.imageUrl!.length,
                                                    pagination: SwiperPagination(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        builder: DotSwiperPaginationBuilder(
                                                            activeSize: 13,
                                                            color:
                                                                secondryColor,
                                                            activeColor:
                                                                primaryColor)),
                                                    control: SwiperControl(
                                                      color: primaryColor,
                                                      disableColor:
                                                          secondryColor,
                                                    ),
                                                    loop: false,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      48.0),
                                                  child: position.toString() ==
                                                          "SwiperPosition.Left"
                                                      ? Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child:
                                                              Transform.rotate(
                                                            angle: pi / 8,
                                                            child: Container(
                                                              height: 40,
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .red)),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                    "NOPE",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            32)),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : position.toString() ==
                                                              "SwiperPosition.Right"
                                                          ? Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Transform
                                                                  .rotate(
                                                                angle: -pi / 8,
                                                                child:
                                                                    Container(
                                                                  height: 40,
                                                                  width: 100,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .rectangle,
                                                                      border: Border.all(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              Colors.lightBlueAccent)),
                                                                  child:
                                                                      const Center(
                                                                    child: Text(
                                                                        "LIKE",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.lightBlueAccent,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 32)),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Container(),
                                                ),

                                                // Padding(
                                                //   padding:
                                                //       const EdgeInsets.only(
                                                //           bottom: 10),
                                                //   child: Align(
                                                //       alignment: Alignment
                                                //           .bottomLeft,
                                                //       child: ListTile(
                                                //           onTap: () {
                                                //             _loadInterstitialAd();
                                                //             _interstitialAd
                                                //                 ?.show();

                                                //             showDialog(
                                                //                 barrierDismissible:
                                                //                     false,
                                                //                 context:
                                                //                     context,
                                                //                 builder:
                                                //                     (context) {
                                                //                   return Info(
                                                //                       index,
                                                //                       widget
                                                //                           .currentUser,
                                                //                       swipeKey);
                                                //                 });
                                                //           },
                                                //           title: Text(
                                                //             "${index.name}, ${index.editInfo!['showMyAge'] != null ? !index.editInfo!['showMyAge'] ? index.age : "" : index.age}",
                                                //             style: TextStyle(
                                                //                 color: Colors
                                                //                     .white,
                                                //                 fontSize:
                                                //                     25,
                                                //                 fontWeight:
                                                //                     FontWeight
                                                //                         .bold),
                                                //           ),
                                                //           subtitle: Text(
                                                //             "${index.address}",
                                                //             style:
                                                //                 TextStyle(
                                                //               color: Colors
                                                //                   .white,
                                                //               fontSize: 20,
                                                //             ),
                                                //           ))),
                                                // ),
                                              ],
                                            ),
                                          ));
                                    });
                                  }).toList(growable: true),
                                  threshold: 30,
                                  maxAngle: 100,
                                  //animationDuration: Duration(milliseconds: 400),
                                  visibleCount: 5,
                                  historyCount: 1,
                                  stackFrom: StackFrom.Right,
                                  translationInterval: 0,
                                  scaleInterval: 0.08,
                                  onSwipe: (int index,
                                      SwiperPosition position) async {
                                    _adsCheck(countswipe);
                                    print(position);
                                    print(widget.users[index].name);
                                    // await sendNotification(
                                    //     widget.users[index].pushToken);
                                    CollectionReference docRef =
                                        FirebaseFirestore.instance
                                            .collection("Users");
                                    if (position == SwiperPosition.Left) {
                                      await docRef
                                          .doc(widget.currentUser.id)
                                          .collection("CheckedUser")
                                          .doc(widget.users[index].id)
                                          .set({
                                        'DislikedUser': widget.users[index].id,
                                        'timestamp': DateTime.now(),
                                      }, SetOptions(merge: true));

                                      if (index < widget.users.length) {
                                        userRemoved.clear();
                                        setState(() {
                                          userRemoved.add(widget.users[index]);
                                          widget.users.removeAt(index);
                                        });
                                      }
                                    } else if (position ==
                                        SwiperPosition.Right) {
                                      await sendNotification(
                                          widget.users[index].pushToken);
                                      if (likedByList
                                          .contains(widget.users[index].id)) {
                                        // showDialog(
                                        //   context: context,
                                        //   builder: (ctx) {
                                        //     return AlertDialog(
                                        //       content: SizedBox(
                                        //         width: MediaQuery.of(context)
                                        //                 .size
                                        //                 .width *
                                        //             0.8,
                                        //         height: MediaQuery.of(context)
                                        //                 .size
                                        //                 .height *
                                        //             0.6,
                                        //         child: Column(
                                        //           mainAxisAlignment:
                                        //               MainAxisAlignment
                                        //                   .spaceEvenly,
                                        //           children: [
                                        //             Row(
                                        //               mainAxisAlignment:
                                        //                   MainAxisAlignment
                                        //                       .center,
                                        //               crossAxisAlignment:
                                        //                   CrossAxisAlignment
                                        //                       .center,
                                        //               children: [
                                        //                 Image.network(
                                        //                   widget.currentUser
                                        //                       .imageUrl![0],
                                        //                   height: 100,
                                        //                   width: 100,
                                        //                   fit: BoxFit.cover,
                                        //                 ),
                                        //                 const SizedBox(
                                        //                   width: 10,
                                        //                 ),
                                        //                 Image.network(
                                        //                   widget.users[0]
                                        //                       .imageUrl![0],
                                        //                   height: 100,
                                        //                   width: 100,
                                        //                   fit: BoxFit.cover,
                                        //                 ),
                                        //               ],
                                        //             ),
                                        //             const Text(
                                        //               'Match',
                                        //               style: TextStyle(
                                        //                   fontSize: 24,
                                        //                   fontFamily: AppStrings
                                        //                       .fontname,
                                        //                   fontWeight:
                                        //                       FontWeight.bold,
                                        //                   color: Colors.pink),
                                        //             ),
                                        //             const Text(
                                        //               'You have 24 hours to\n take a first step with new partner',
                                        //               textAlign:
                                        //                   TextAlign.center,
                                        //               style: TextStyle(
                                        //                   fontSize: 10,
                                        //                   fontFamily: AppStrings
                                        //                       .fontname,
                                        //                   fontWeight:
                                        //                       FontWeight.w400,
                                        //                   color: Colors.grey),
                                        //             ),
                                        //             GestureDetector(
                                        //               onTap: () {},
                                        //               child: Container(
                                        //                 width: double.infinity,
                                        //                 margin: const EdgeInsets
                                        //                     .symmetric(
                                        //                     horizontal: 30),
                                        //                 padding:
                                        //                     const EdgeInsets
                                        //                         .symmetric(
                                        //                         vertical: 12),
                                        //                 decoration:
                                        //                     BoxDecoration(
                                        //                   borderRadius:
                                        //                       BorderRadius
                                        //                           .circular(20),
                                        //                   color: Colors.pink,
                                        //                 ),
                                        //                 child: Center(
                                        //                   child: InkWell(
                                        //                     splashColor: Colors
                                        //                         .transparent,
                                        //                     highlightColor:
                                        //                         Colors
                                        //                             .transparent,
                                        //                     onTap: () {
                                        //                       Navigator.pop(
                                        //                           context);
                                        //                       // Navigator.push(
                                        //                       //     context,
                                        //                       //     MaterialPageRoute(
                                        //                       //         builder: (context) => Tabbar(
                                        //                       //             null,
                                        //                       //             null)));
                                        //                     },
                                        //                     child: InkWell(
                                        //                       splashColor: Colors
                                        //                           .transparent,
                                        //                       highlightColor:
                                        //                           Colors
                                        //                               .transparent,
                                        //                       onTap: () {
                                        //                         Navigator.push(
                                        //                           context,
                                        //                           CupertinoPageRoute(
                                        //                             builder: (_) => ChatPage(
                                        //                                 chatId: chatId(
                                        //                                   widget
                                        //                                       .currentUser,
                                        //                                   widget
                                        //                                       .users[index],
                                        //                                 ),
                                        //                                 sender: widget.currentUser,
                                        //                                 second: widget.users[index]),
                                        //                           ),
                                        //                         );
                                        //                       },
                                        //                       child: const Text(
                                        //                         'Chat Now',
                                        //                         style: TextStyle(
                                        //                             fontSize:
                                        //                                 16,
                                        //                             fontFamily:
                                        //                                 AppStrings
                                        //                                     .fontname,
                                        //                             fontWeight:
                                        //                                 FontWeight
                                        //                                     .bold,
                                        //                             color: Colors
                                        //                                 .white),
                                        //                       ),
                                        //                     ),
                                        //                   ),
                                        //                 ),
                                        //               ),
                                        //             ),
                                        //             InkWell(
                                        //               splashColor:
                                        //                   Colors.transparent,
                                        //               highlightColor:
                                        //                   Colors.transparent,
                                        //               onTap: () {
                                        //                 Navigator.pop(context);
                                        //               },
                                        //               child: const Text(
                                        //                 'Keep swiping',
                                        //                 style: TextStyle(
                                        //                     fontSize: 12,
                                        //                     fontFamily:
                                        //                         AppStrings
                                        //                             .fontname,
                                        //                     fontWeight:
                                        //                         FontWeight.w400,
                                        //                     color:
                                        //                         Colors.black),
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //       ),
                                        //     );
                                        //   },
                                        // );

                                        showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              content: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.6,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        ClipOval(
                                                          child: CircleAvatar(
                                                            radius: 50,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            // backgroundImage: NetworkImage('URL_of_your_background_image'), // background image
                                                            child: ClipOval(
                                                              child:
                                                                  Image.network(
                                                                widget
                                                                    .currentUser
                                                                    .imageUrl![0],
                                                                height: 100,
                                                                width: 100,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        ClipOval(
                                                          child: CircleAvatar(
                                                            radius: 50,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            // backgroundImage: NetworkImage('URL_of_your_background_image'), // background image
                                                            child: ClipOval(
                                                              child:
                                                                  Image.network(
                                                                widget.users[0]
                                                                    .imageUrl![0],
                                                                height: 100,
                                                                width: 100,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Text(
                                                      'Match',
                                                      style: TextStyle(
                                                          fontSize: 24,
                                                          fontFamily: AppStrings
                                                              .fontname,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.pink),
                                                    ),
                                                    const Text(
                                                      'You have 24 hours to\n take a first step with new partner',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontFamily: AppStrings
                                                              .fontname,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.grey),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        width: double.infinity,
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 30),
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 12),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.pink,
                                                        ),
                                                        child: Center(
                                                          child: InkWell(
                                                            splashColor: Colors
                                                                .transparent,
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                              // Navigator.push(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder: (context) => Tabbar(
                                                              //             null,
                                                              //             null)));
                                                            },
                                                            child: InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  CupertinoPageRoute(
                                                                    builder: (_) => ChatPage(
                                                                        chatId: chatId(
                                                                          widget
                                                                              .currentUser,
                                                                          widget
                                                                              .users[index],
                                                                        ),
                                                                        sender: widget.currentUser,
                                                                        second: widget.users[index]),
                                                                  ),
                                                                );
                                                              },
                                                              child: const Text(
                                                                'Chat Now',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontFamily:
                                                                        AppStrings
                                                                            .fontname,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        'Keep swiping',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                AppStrings
                                                                    .fontname,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );

                                        await docRef
                                            .doc(widget.currentUser.id)
                                            .collection("Matches")
                                            .doc(widget.users[index].id)
                                            .set({
                                          'Matches': widget.users[index].id,
                                          'isRead': false,
                                          'userName': widget.users[index].name,
                                          'pictureUrl':
                                              widget.users[index].imageUrl![0],
                                          'timestamp':
                                              FieldValue.serverTimestamp()
                                        }, SetOptions(merge: true));
                                        await docRef
                                            .doc(widget.users[index].id)
                                            .collection("Matches")
                                            .doc(widget.currentUser.id)
                                            .set({
                                          'Matches': widget.currentUser.id,
                                          'userName': widget.currentUser.name,
                                          'pictureUrl':
                                              widget.currentUser.imageUrl![0],
                                          'isRead': false,
                                          'timestamp':
                                              FieldValue.serverTimestamp()
                                        }, SetOptions(merge: true));
                                      }

                                      await docRef
                                          .doc(widget.currentUser.id)
                                          .collection("CheckedUser")
                                          .doc(widget.users[index].id)
                                          .set({
                                        'LikedUser': widget.users[index].id,
                                        'timestamp':
                                            FieldValue.serverTimestamp(),
                                      }, SetOptions(merge: true));
                                      await docRef
                                          .doc(widget.users[index].id)
                                          .collection("LikedBy")
                                          .doc(widget.currentUser.id)
                                          .set({
                                        'LikedBy': widget.currentUser.id,
                                        'timestamp':
                                            FieldValue.serverTimestamp()
                                      }, SetOptions(merge: true));
                                      if (index < widget.users.length) {
                                        userRemoved.clear();
                                        setState(() {
                                          userRemoved.add(widget.users[index]);
                                          widget.users.removeAt(index);
                                        });
                                      }
                                    } else
                                      debugPrint("onSwipe $index $position");
                                  },
                                  onRewind:
                                      (int index, SwiperPosition position) {
                                    swipeKey.currentContext!
                                        .dependOnInheritedWidgetOfExactType();
                                    widget.users.insert(index, userRemoved[0]);
                                    setState(() {
                                      userRemoved.clear();
                                    });
                                    debugPrint("onRewind $index $position");
                                    print(widget.users[index].id);
                                  },
                                ),
                        ),
                        // exceedSwipes
                        //     ? Align(
                        //         alignment: Alignment.center,
                        //         child: InkWell(
                        //             splashColor: Colors.transparent,
                        //             highlightColor: Colors.transparent,
                        //             child: Container(
                        //               color: Colors.white.withOpacity(.3),
                        //               child: Dialog(
                        //                 insetAnimationCurve: Curves.bounceInOut,
                        //                 insetAnimationDuration:
                        //                     const Duration(seconds: 2),
                        //                 shape: RoundedRectangleBorder(
                        //                     borderRadius:
                        //                         BorderRadius.circular(20)),
                        //                 backgroundColor: Colors.white,
                        //                 child: SizedBox(
                        //                   height: MediaQuery.of(context)
                        //                           .size
                        //                           .height *
                        //                       .55,
                        //                   child: Column(
                        //                     mainAxisAlignment:
                        //                         MainAxisAlignment.spaceEvenly,
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.center,
                        //                     children: [
                        //                       Icon(
                        //                         Icons.error_outline,
                        //                         size: 50,
                        //                         color: primaryColor,
                        //                       ),
                        //                       const Text(
                        //                         "you have already used the maximum number of free available swipes for 24 hrs.",
                        //                         textAlign: TextAlign.center,
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.bold,
                        //                             color: Colors.grey,
                        //                             fontSize: 20),
                        //                       ),
                        //                       Padding(
                        //                         padding:
                        //                             const EdgeInsets.all(8.0),
                        //                         child: Icon(
                        //                           Icons.lock_outline,
                        //                           size: 120,
                        //                           color: primaryColor,
                        //                         ),
                        //                       ),
                        //                       Text(
                        //                         "For swipe more users just subscribe our premium plans.",
                        //                         textAlign: TextAlign.center,
                        //                         style: TextStyle(
                        //                             color: primaryColor,
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 20),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //             onTap: () => Navigator.push(
                        //                 context,
                        //                 MaterialPageRoute(
                        //                     builder: (context) => Subscription(
                        //                         null, null, widget.items)))),
                        //       )
                        //     : Container()
                      ],
                    ),
                  ),
                ),
              ),
            ));
          })),
    );
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              //  _moveToHome();
            },
          );
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  void _adsCheck(count) {
    print(count);
    if (count % 3 == 0) {
      _loadInterstitialAd();
      _interstitialAd?.show();
      countswipe++;
    } else {
      countswipe++;
    }
  }
}

Widget _buildInterestContainer(String name, String img) {
  return Container(
    height: 39,
    width: 95,
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          img,
          height: 22,
          width: 22,
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
