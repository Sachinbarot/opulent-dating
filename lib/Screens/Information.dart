// ignore_for_file: file_names, unnecessary_null_comparison, avoid_print, prefer_const_constructors, use_key_in_widget_constructors

import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:hookup4u/Screens/Calling/utils/settings.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Chat/Matches.dart';
import 'package:hookup4u/Screens/Profile/EditProfile.dart';
import 'package:hookup4u/Screens/reportUser.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/swipe_stack.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Chat/chatPage.dart';

class Info extends StatefulWidget {
  final User currentUser;
  final User user;
  final GlobalKey<SwipeStackState>? swipeKey;

  const Info(
    this.user,
    this.currentUser,
    this.swipeKey,
  );

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  bool isLiked = false;
  bool isLikedLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadLikedValue();
    _incrementVisitCount();
  }

  Future<void> _saveLikedValue(bool value, String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLiked_$userId', value);

    if (value) {
      List<String>? likedProfiles = prefs.getStringList('likedProfiles') ?? [];
      likedProfiles.add(userId);
      await prefs.setStringList('likedProfiles', likedProfiles);
    } else {
      List<String>? likedProfiles = prefs.getStringList('likedProfiles') ?? [];
      likedProfiles.remove(userId);
      await prefs.setStringList('likedProfiles', likedProfiles);
    }

    try {
      if (value) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(widget.currentUser.id)
            .collection('LikedBy')
            .doc(userId)
            .set({
          'name': widget.user.name,
          'imageUrl': widget.user.imageUrl![0],
          'isLiked': value,
          //'pushToken': widget.user.pushToken
        });

        await sendNotification();
      }
    } catch (e) {
      print("Error updating Firebase: $e");
    }
  }

  Future<void> sendNotification() async {
    try {
      if (widget.user.pushToken != null) {
        var headers = {
          'Authorization': 'key=$SERVER_KEY',
          'Content-Type': 'application/json'
        };
        var data = json.encode({
          "to": widget.user.pushToken,
          "notification": {
            "body": "You've been liked by ${widget.currentUser.name}"
          },
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

  Future<void> _loadLikedValue() async {
    if (!isLikedLoaded) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        isLiked = prefs.getBool('isLiked_${widget.user.id}') ?? false;
        isLikedLoaded = true;
      });
    }
  }

  Future<void> _incrementVisitCount() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userVisitRef = firestore
        .collection("Users")
        .doc(widget.user.id)
        .collection('ProfileVisits')
        .doc(widget.currentUser.name.toString());
    print(widget.currentUser.name.toString());

    DocumentSnapshot visitSnapshot = await userVisitRef.get();

    if (visitSnapshot.exists) {
      Map<String, dynamic> data = visitSnapshot.data() as Map<String, dynamic>;
      int currentCount = data['visitCount'] ?? 0;

      await userVisitRef.update({'visitCount': currentCount + 1});
    } else {
      await userVisitRef.set({'visitCount': 1});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = widget.user.id == widget.currentUser.id;
    bool isMatched = widget.swipeKey == null;

    return Scaffold(
      backgroundColor: backcolor,
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: Swiper(
                      key: UniqueKey(),
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index2) {
                        return widget.user.imageUrl!.length != null
                            ? Hero(
                                tag: "abc",
                                child: CachedNetworkImage(
                                  imageUrl: widget.user.imageUrl![index2] ?? '',
                                  fit: BoxFit.cover,
                                  useOldImageOnUrlChange: true,
                                  placeholder: (context, url) =>
                                      const CupertinoActivityIndicator(
                                    radius: 20,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              )
                            : Container();
                      },
                      itemCount: widget.user.imageUrl!.length,
                      pagination: SwiperPagination(
                          alignment: Alignment.bottomCenter,
                          builder: DotSwiperPaginationBuilder(
                              activeSize: 13,
                              color: secondryColor,
                              activeColor: primaryColor)),
                      control: SwiperControl(
                        color: primaryColor,
                        disableColor: secondryColor,
                      ),
                      loop: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          subtitle: Text(
                            "${widget.user.address}",
                            style: TextStyle(
                                fontFamily: AppStrings.fontname,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: black.withOpacity(0.5)),
                          ),
                          title: Text(
                            "${widget.user.name}, ${widget.user.editInfo!['showMyAge'] != null ? !widget.user.editInfo!['showMyAge'] ? widget.user.age : "" : widget.user.age}",
                            style: TextStyle(
                                color: black,
                                fontSize: 25,
                                fontFamily: AppStrings.fontname,
                                fontWeight: FontWeight.w600),
                          ),
                          trailing: FloatingActionButton(
                              backgroundColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_downward,
                                color: btncolor,
                              )),
                        ),
                        widget.user.editInfo!['job_title'] != null
                            ? ListTile(
                                dense: true,
                                leading: Icon(Icons.work, color: primaryColor),
                                title: Text(
                                  "${widget.user.editInfo!['job_title']}${widget.user.editInfo!['company'] != null ? ' at ${widget.user.editInfo!['company']}' : ''}",
                                  style: TextStyle(
                                      color: black.withOpacity(0.5),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : Container(),
                        widget.user.editInfo!['university'] != null
                            ? ListTile(
                                dense: true,
                                leading: Icon(Icons.stars, color: primaryColor),
                                title: Text(
                                  "${widget.user.editInfo!['university']}",
                                  style: TextStyle(
                                      color: secondryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            : Container(),
                        widget.user.editInfo!['living_in'] != null
                            ? ListTile(
                                dense: true,
                                leading: Icon(Icons.home, color: primaryColor),
                                title: Text(
                                  "Living in ",
                                  style: TextStyle(
                                      color: secondryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ).tr(args: [
                                  "${widget.user.editInfo!['living_in']}"
                                ]),
                              )
                            : Container(),
                        !isMe
                            ? ListTile(
                                dense: true,
                                leading: Icon(
                                  Icons.location_on,
                                  color: primaryColor,
                                ),
                                title: Text(
                                  widget.user.editInfo!['DistanceVisible'] !=
                                          null
                                      ? widget.user.editInfo!['DistanceVisible']
                                          ? 'Less than ${widget.user.distanceBW} KM away'
                                          : 'Distance not visible'
                                      : 'Less than ${widget.user.distanceBW} KM away',
                                  style: TextStyle(
                                      color: newtextcolor,
                                      fontSize: 16,
                                      fontFamily: AppStrings.fontname,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : Container(),
                        const Divider(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 18,
                      ),
                      child: FloatingActionButton(
                        heroTag: UniqueKey(),
                        backgroundColor: Colors.white,
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.grey,
                          size: 30,
                        ),
                        onPressed: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                          if (widget.currentUser.id.toString() != null) {
                            _saveLikedValue(isLiked, widget.user.id.toString());

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(isLiked ? 'Liked!' : 'Unliked!'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  widget.user.editInfo!['about'] != null
                      ? Text(
                          "${widget.user.editInfo!['about']}",
                          style: TextStyle(
                              color: secondryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  widget.user.editInfo!['about'] != null
                      ? const Divider()
                      : Container(),
                  !isMe
                      ? InkWell(
                          onTap: () => showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) => ReportUser(
                                    currentUser: widget.currentUser,
                                    seconduser: widget.user,
                                  )),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  "REPORT ${widget.user.name}".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: AppStrings.fontname,
                                      fontWeight: FontWeight.w600,
                                      color: newtextcolor),
                                ),
                              )),
                        )
                      : Container(),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            !isMatched
                ? Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton(
                              heroTag: UniqueKey(),
                              backgroundColor: Colors.white,
                              child: const Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                widget.swipeKey!.currentState!.swipeLeft();
                              }),
                          FloatingActionButton(
                              heroTag: UniqueKey(),
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.lightBlueAccent,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                widget.swipeKey!.currentState!.swipeRight();
                              }),
                        ],
                      ),
                    ),
                  )
                : isMe
                    ? Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  color: primaryColor,
                                ),
                                onPressed: () => Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            EditProfile(widget.user))))),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.message,
                                  color: primaryColor,
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => ChatPage(
                                              sender: widget.currentUser,
                                              second: widget.user,
                                              chatId: chatId(widget.user,
                                                  widget.currentUser),
                                            )))
                                            )),
                      )
          ],
        ),
      ),
    );
  }
}
