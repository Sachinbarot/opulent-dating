// ignore_for_file: unnecessary_null_comparison, prefer_is_empty, prefer_typing_uninitialized_variables, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Chat/chatPage.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Matches extends StatefulWidget {
  final User currentUser;
  final List<User> matches;

  const Matches(this.currentUser, this.matches, {super.key});

  @override
  State<Matches> createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  late SharedPreferences _prefs;
  String _status = '';

  @override
  void initState() {
    _getStatusFromSharedPreferences();
    _listenToStatusChanges(); // Listen for real-time status changes

    super.initState();
  }

  Future<void> _getStatusFromSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _status = _prefs.getString('status') ?? '';
    });
    print(_status);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStatusStream() {
    if (widget.currentUser != null &&
        widget.matches != null &&
        widget.matches.isNotEmpty) {
      return FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.matches[0].id)
          .snapshots();
    }
    // Return an empty stream if user is null or matches is empty
    return const Stream.empty();
  }

  void _listenToStatusChanges() {
    getStatusStream().listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          _status = snapshot.data()?['status'] ?? '';
        });
      }
    });
  }

  Widget _getStatusIndicator() {
    return Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _status == 'Online' ? Colors.green : Colors.red,
            border: Border.all(color: Colors.white)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 90,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Now Active',
                  style: TextStyle(
                    color: black,
                    fontSize: 18.0,
                    fontFamily: AppStrings.fontname,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  onTap: () {},
                  child: Text(
                    "See All",
                    style: TextStyle(
                      color: white,
                      fontSize: 12.0,
                      fontFamily: AppStrings.fontname,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 110.0,
            child: widget.matches.length > 0
                ? ListView.builder(
                    padding: const EdgeInsets.only(left: 10.0),
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.matches.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => ChatPage(
                              sender: widget.currentUser,
                              chatId: chatId(
                                  widget.currentUser, widget.matches[index]),
                              second: widget.matches[index],
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: white, width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircleAvatar(
                                        backgroundColor: btncolor,
                                        radius: 35.0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            imageUrl: widget.matches[index]
                                                    .imageUrl![0] ??
                                                '',
                                            useOldImageOnUrlChange: true,
                                            placeholder: (context, url) =>
                                                const CupertinoActivityIndicator(
                                              radius: 15,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 5,
                                    bottom: 3,
                                    child:
                                        _getStatusIndicator(), // Display status indicator
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 6.0),
                              // Text(
                              //   widget.matches[index].name!,
                              //   style: TextStyle(
                              //     color: secondryColor,
                              //     fontSize: 16.0,
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                    "No match found".tr().toString(),
                    style: TextStyle(color: secondryColor, fontSize: 16),
                  )),
          ),
        ],
      ),
    );
  }
}

var groupChatId;
chatId(currentUser, sender) {
  if (currentUser.id.hashCode <= sender.id.hashCode) {
    return groupChatId = '${currentUser.id}-${sender.id}';
  } else {
    return groupChatId = '${sender.id}-${currentUser.id}';
  }
}
