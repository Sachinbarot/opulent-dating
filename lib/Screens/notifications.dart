// // ignore_for_file: library_private_types_in_public_api, curly_braces_in_flow_control_structures, prefer_is_empty, use_build_context_synchronously, avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Information.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/util/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'Tab.dart';

class Notifications extends StatefulWidget {
  final User currentUser;
  const Notifications(this.currentUser, {super.key});

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final db = FirebaseFirestore.instance;
  late CollectionReference matchReference;
  CollectionReference? likedBy;

  @override
  void initState() {
    matchReference =
        db.collection("Users").doc(widget.currentUser.id).collection('Matches');
    likedBy =
        db.collection("Users").doc(widget.currentUser.id).collection('LikedBy');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backcolor,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                  stream:
                      likedBy!.orderBy('name', descending: true).snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text(
                          "",
                          style: TextStyle(
                            color: btncolor,
                            fontSize: 24,
                            fontFamily: AppStrings.fontname,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          "",
                          style: TextStyle(
                            color: btncolor,
                            fontSize: 24,
                            fontFamily: AppStrings.fontname,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs
                          .map((doc) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: !doc.get('isLiked')
                                        ? btncolor.withOpacity(.15)
                                        : secondryColor.withOpacity(.15),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(5),
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: secondryColor,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: CachedNetworkImage(
                                          imageUrl: doc.get('imageUrl') ?? "",
                                          fit: BoxFit.cover,
                                          useOldImageOnUrlChange: true,
                                          placeholder: (context, url) =>
                                              const CupertinoActivityIndicator(
                                            radius: 20,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: const Text("Your profile liked By")
                                        .tr(args: [
                                      "${doc.get('name') ?? '__'}"
                                    ]),
                                    subtitle: Text("${doc.get('name')}"),
                                    trailing: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          !doc.get('isLiked')
                                              ? Container(
                                                  width: 40.0,
                                                  height: 20.0,
                                                  decoration: BoxDecoration(
                                                    color: btncolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'NEW',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              : const Text(""),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      print(doc.get("LikedBy"));
                                      showDialog(
                                        context: context,
                                        builder: (context) => const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                      DocumentSnapshot userdoc = await db
                                          .collection("Users")
                                          .doc(doc.get("LikedBy"))
                                          .get();
                                      if (userdoc.exists) {
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: matchReference
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 350),
                        child: Center(
                          child: Text(
                            "No  Notification",
                            style: TextStyle(
                              color: btncolor,
                              fontSize: 24,
                              fontFamily: AppStrings.fontname,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 350),
                        child: Center(
                          child: Text(
                            "No  Notification",
                            style: TextStyle(
                              color: btncolor,
                              fontSize: 24,
                              fontFamily: AppStrings.fontname,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs
                          .map((doc) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: !doc.get('isRead')
                                        ? btncolor.withOpacity(.15)
                                        : secondryColor.withOpacity(.15),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(5),
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: secondryColor,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: CachedNetworkImage(
                                          imageUrl: doc.get('pictureUrl') ?? "",
                                          fit: BoxFit.cover,
                                          useOldImageOnUrlChange: true,
                                          placeholder: (context, url) =>
                                              const CupertinoActivityIndicator(
                                            radius: 20,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                            Icons.error,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: const Text("you are matched with")
                                        .tr(args: [
                                      "${doc.get('userName') ?? '__'}"
                                    ]),
                                    subtitle: Text(
                                        "${(doc.get('timestamp').toDate())}"),
                                    trailing: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          !doc.get('isRead')
                                              ? Container(
                                                  width: 40.0,
                                                  height: 20.0,
                                                  decoration: BoxDecoration(
                                                    color: btncolor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    'NEW',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                )
                                              : const Text(""),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      print(doc.get("Matches"));
                                      showDialog(
                                        context: context,
                                        builder: (context) => const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                      DocumentSnapshot userdoc = await db
                                          .collection("Users")
                                          .doc(doc.get("Matches"))
                                          .get();
                                      if (userdoc.exists) {
                                        Navigator.pop(context);
                                        User tempuser =
                                            User.fromDocument(userdoc);
                                        tempuser.distanceBW = calculateDistance(
                                          widget.currentUser
                                              .coordinates!['latitude'],
                                          widget.currentUser
                                              .coordinates!['longitude'],
                                          tempuser.coordinates!['latitude'],
                                          tempuser.coordinates!['longitude'],
                                        ).round();

                                        await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            if (!doc.get("isRead")) {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      "/Users/${widget.currentUser.id}/Matches")
                                                  .doc('${doc.get("Matches")}')
                                                  .update({'isRead': true});
                                            }
                                            return Info(tempuser,
                                                widget.currentUser, null);
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Scaffold(
    //     backgroundColor: backcolor,
    //     body: Container(
    //       decoration: const BoxDecoration(
    //         borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(50),
    //           topRight: Radius.circular(50),
    //         ),
    //       ),
    //       child: ClipRRect(
    //         borderRadius: const BorderRadius.only(
    //           topLeft: Radius.circular(50),
    //           topRight: Radius.circular(50),
    //         ),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: <Widget>[
    //             const SizedBox(height: 20),
    //             StreamBuilder<QuerySnapshot>(
    //                 stream:
    //                     likedBy!.orderBy('name', descending: true).snapshots(),
    //                 builder: (BuildContext context,
    //                     AsyncSnapshot<QuerySnapshot> snapshot) {
    //                   if (!snapshot.hasData) {
    //                     return Center(
    //                         child: Text(
    //                       "No Notification",
    //                       style: TextStyle(
    //                           color: btncolor,
    //                           fontSize: 24,
    //                           fontFamily: AppStrings.fontname,
    //                           fontWeight: FontWeight.w600),
    //                     ));
    //                   } else if (snapshot.data!.docs.length == 0) {
    //                     return Center(
    //                         child: Text(
    //                       "No Notification",
    //                       style: TextStyle(
    //                           color: btncolor,
    //                           fontSize: 24,
    //                           fontFamily: AppStrings.fontname,
    //                           fontWeight: FontWeight.w600),
    //                     ));
    //                   }
    //                   return Expanded(
    //                     child: ListView(
    //                       children: snapshot.data!.docs
    //                           .map((doc) => Padding(
    //                                 padding: const EdgeInsets.all(8.0),
    //                                 child: Container(
    //                                     decoration: BoxDecoration(
    //                                         borderRadius:
    //                                             BorderRadius.circular(20),
    //                                         color: !doc.get('isLiked')
    //                                             ? btncolor.withOpacity(.15)
    //                                             : secondryColor
    //                                                 .withOpacity(.15)),
    //                                     child: ListTile(
    //                                       contentPadding:
    //                                           const EdgeInsets.all(5),
    //                                       leading: CircleAvatar(
    //                                         radius: 25,
    //                                         backgroundColor: secondryColor,
    //                                         child: ClipRRect(
    //                                           borderRadius:
    //                                               BorderRadius.circular(
    //                                             25,
    //                                           ),
    //                                           child: CachedNetworkImage(
    //                                             imageUrl:
    //                                                 doc.get('imageUrl') ?? "",
    //                                             fit: BoxFit.cover,
    //                                             useOldImageOnUrlChange: true,
    //                                             placeholder: (context, url) =>
    //                                                 const CupertinoActivityIndicator(
    //                                               radius: 20,
    //                                             ),
    //                                             errorWidget:
    //                                                 (context, url, error) =>
    //                                                     const Icon(
    //                                               Icons.error,
    //                                               color: Colors.black,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ),
    //                                       title: const Text(
    //                                               "Your profile liked By")
    //                                           .tr(args: [
    //                                         "${doc.get('name') ?? '__'}"
    //                                       ]),
    //                                       subtitle:
    //                                           Text("${(doc.get('name'))}"),
    //                                       trailing: Padding(
    //                                         padding: const EdgeInsets.only(
    //                                             right: 10),
    //                                         child: Column(
    //                                           mainAxisAlignment:
    //                                               MainAxisAlignment.spaceAround,
    //                                           children: <Widget>[
    //                                             !doc.get('isLiked')
    //                                                 ? Container(
    //                                                     width: 40.0,
    //                                                     height: 20.0,
    //                                                     decoration:
    //                                                         BoxDecoration(
    //                                                       color: btncolor,
    //                                                       borderRadius:
    //                                                           BorderRadius
    //                                                               .circular(
    //                                                                   30.0),
    //                                                     ),
    //                                                     alignment:
    //                                                         Alignment.center,
    //                                                     child: const Text(
    //                                                       'NEW',
    //                                                       style: TextStyle(
    //                                                         color: Colors.white,
    //                                                         fontSize: 12.0,
    //                                                         fontWeight:
    //                                                             FontWeight.bold,
    //                                                       ),
    //                                                     ),
    //                                                   )
    //                                                 : const Text(""),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       onTap: () async {
    //                                         print(doc.get("LikedBy"));
    //                                         showDialog(
    //                                             context: context,
    //                                             builder: (context) {
    //                                               return const Center(
    //                                                   child:
    //                                                       CircularProgressIndicator(
    //                                                 strokeWidth: 2,
    //                                                 valueColor:
    //                                                     AlwaysStoppedAnimation<
    //                                                             Color>(
    //                                                         Colors.white),
    //                                               ));
    //                                             });
    //                                         DocumentSnapshot userdoc = await db
    //                                             .collection("Users")
    //                                             .doc(doc.get("LikedBy"))
    //                                             .get();
    //                                         if (userdoc.exists) {
    //                                           Navigator.pop(context);
    //                                         }
    //                                       },
    //                                     )
    //                                     // : Container()
    //                                     ),
    //                               ))
    //                           .toList(),
    //                     ),
    //                   );
    //                 }),
    //             StreamBuilder<QuerySnapshot>(
    //                 stream: matchReference
    //                     .orderBy('timestamp', descending: true)
    //                     .snapshots(),
    //                 builder: (BuildContext context,
    //                     AsyncSnapshot<QuerySnapshot> snapshot) {
    //                   if (!snapshot.hasData) {
    //                     return Center(
    //                         child: Text(
    //                       "No Notification",
    //                       style: TextStyle(
    //                           color: btncolor,
    //                           fontSize: 24,
    //                           fontFamily: AppStrings.fontname,
    //                           fontWeight: FontWeight.w600),
    //                     ));
    //                   } else if (snapshot.data!.docs.length == 0) {
    //                     return Center(
    //                         child: Text(
    //                       "No Notification",
    //                       style: TextStyle(
    //                           color: btncolor,
    //                           fontSize: 24,
    //                           fontFamily: AppStrings.fontname,
    //                           fontWeight: FontWeight.w600),
    //                     ));
    //                   }
    //                   return Expanded(
    //                     child: ListView(
    //                       children: snapshot.data!.docs
    //                           .map((doc) => Padding(
    //                                 padding: const EdgeInsets.all(8.0),
    //                                 child: Container(
    //                                     decoration: BoxDecoration(
    //                                         borderRadius:
    //                                             BorderRadius.circular(20),
    //                                         color: !doc.get('isRead')
    //                                             ? btncolor.withOpacity(.15)
    //                                             : secondryColor
    //                                                 .withOpacity(.15)),
    //                                     child: ListTile(
    //                                       contentPadding:
    //                                           const EdgeInsets.all(5),
    //                                       leading: CircleAvatar(
    //                                         radius: 25,
    //                                         backgroundColor: secondryColor,
    //                                         child: ClipRRect(
    //                                           borderRadius:
    //                                               BorderRadius.circular(
    //                                             25,
    //                                           ),
    //                                           child: CachedNetworkImage(
    //                                             imageUrl:
    //                                                 doc.get('pictureUrl') ?? "",
    //                                             fit: BoxFit.cover,
    //                                             useOldImageOnUrlChange: true,
    //                                             placeholder: (context, url) =>
    //                                                 const CupertinoActivityIndicator(
    //                                               radius: 20,
    //                                             ),
    //                                             errorWidget:
    //                                                 (context, url, error) =>
    //                                                     const Icon(
    //                                               Icons.error,
    //                                               color: Colors.black,
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ),

    //                                       title:
    //                                           const Text("you are matched with")
    //                                               .tr(args: [
    //                                         "${doc.get('userName') ?? '__'}"
    //                                       ]),

    //                                       subtitle: Text(
    //                                           "${(doc.get('timestamp').toDate())}"),
    //                                       //  Text(
    //                                       //     "Now you can start chat with ${notification[index].sender.name}"),
    //                                       // "if you want to match your profile with ${notifications[index].sender.name} just like ${notifications[index].sender.name}'s profile"),
    //                                       trailing: Padding(
    //                                         padding: const EdgeInsets.only(
    //                                             right: 10),
    //                                         child: Column(
    //                                           mainAxisAlignment:
    //                                               MainAxisAlignment.spaceAround,
    //                                           children: <Widget>[
    //                                             !doc.get('isRead')
    //                                                 ? Container(
    //                                                     width: 40.0,
    //                                                     height: 20.0,
    //                                                     decoration:
    //                                                         BoxDecoration(
    //                                                       color: btncolor,
    //                                                       borderRadius:
    //                                                           BorderRadius
    //                                                               .circular(
    //                                                                   30.0),
    //                                                     ),
    //                                                     alignment:
    //                                                         Alignment.center,
    //                                                     child: const Text(
    //                                                       'NEW',
    //                                                       style: TextStyle(
    //                                                         color: Colors.white,
    //                                                         fontSize: 12.0,
    //                                                         fontWeight:
    //                                                             FontWeight.bold,
    //                                                       ),
    //                                                     ),
    //                                                   )
    //                                                 : const Text(""),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                       onTap: () async {
    //                                         print(doc.get("Matches"));
    //                                         showDialog(
    //                                             context: context,
    //                                             builder: (context) {
    //                                               return const Center(
    //                                                   child:
    //                                                       CircularProgressIndicator(
    //                                                 strokeWidth: 2,
    //                                                 valueColor:
    //                                                     AlwaysStoppedAnimation<
    //                                                             Color>(
    //                                                         Colors.white),
    //                                               ));
    //                                             });
    //                                         DocumentSnapshot userdoc = await db
    //                                             .collection("Users")
    //                                             .doc(doc.get("Matches"))
    //                                             .get();
    //                                         if (userdoc.exists) {
    //                                           Navigator.pop(context);
    //                                           User tempuser =
    //                                               User.fromDocument(userdoc);
    //                                           tempuser.distanceBW =
    //                                               calculateDistance(
    //                                                       widget.currentUser
    //                                                               .coordinates![
    //                                                           'latitude'],
    //                                                       widget.currentUser
    //                                                               .coordinates![
    //                                                           'longitude'],
    //                                                       tempuser.coordinates![
    //                                                           'latitude'],
    //                                                       tempuser.coordinates![
    //                                                           'longitude'])
    //                                                   .round();

    //                                           await showDialog(
    //                                               barrierDismissible: false,
    //                                               context: context,
    //                                               builder: (context) {
    //                                                 if (!doc.get("isRead")) {
    //                                                   FirebaseFirestore.instance
    //                                                       .collection(
    //                                                           "/Users/${widget.currentUser.id}/Matches")
    //                                                       .doc(
    //                                                           '${doc.get("Matches")}')
    //                                                       .update(
    //                                                           {'isRead': true});
    //                                                 }
    //                                                 return Info(
    //                                                     tempuser,
    //                                                     widget.currentUser,
    //                                                     null);
    //                                               });
    //                                         }
    //                                       },
    //                                     )
    //                                     //  : Container()
    //                                     ),
    //                               ))
    //                           .toList(),
    //                     ),
    //                   );
    //                 })
    //           ],
    //         ),
    //       ),
    //     ));
  }
}
