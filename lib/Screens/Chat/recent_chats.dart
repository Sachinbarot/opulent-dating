// ignore_for_file: prefer_is_empty

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Chat/Matches.dart';
import 'package:hookup4u/Screens/Chat/chatPage.dart';
import 'package:hookup4u/Screens/Tab.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/util/color.dart';
import 'package:intl/intl.dart';

class RecentChats extends StatefulWidget {
  final User currentUser;
  final List<User> matches;

  const RecentChats(this.currentUser, this.matches, {super.key});

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              color: backcolor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30.0),
              ),
              child: widget.matches.isEmpty
                  ? 
                  Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'asset/amico.png',
                            height: 135,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Find Your Match  Here',
                            style: TextStyle(
                                fontSize: 24.0,
                                fontFamily: AppStrings.fontname,
                                color: black,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'step 1: you swipe right \nstep 2: they swipe right, too \nstep 3: it’s match!',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: AppStrings.fontname,
                                color: black.withOpacity(0.70),
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Container(
                            height: 42,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: btncolor),
                            child: Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(builder: (context) {
                                      return const Tabbar(
                                        null,
                                        null,
                                      );
                                    }),
                                  );
                                },
                                child: Text(
                                  'start swiping ',
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: AppStrings.fontname,
                                      color: black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                
                
                  : ListView(
                      physics: const ScrollPhysics(),
                      children: widget.matches
                          .map((index) => GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => ChatPage(
                                      chatId: chatId(widget.currentUser, index),
                                      sender: widget.currentUser,
                                      second: index,
                                    ),
                                  ),
                                ),
                                child: StreamBuilder(
                                    stream: db
                                        .collection("chats")
                                        .doc(chatId(widget.currentUser, index))
                                        .collection('messages')
                                        .orderBy('time', descending: true)
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: CupertinoActivityIndicator(),
                                        );
                                      } else if (snapshot.data!.docs.length ==
                                          0) {
                                        return Container();
                                      }
                                      index.lastmsg =
                                          snapshot.data!.docs[0]['time'];
                                      return Column(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              top: 5.0,
                                              bottom: 5.0,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor: secondryColor,
                                                radius: 30.0,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        index.imageUrl![0] ??
                                                            '',
                                                    useOldImageOnUrlChange:
                                                        true,
                                                    placeholder: (context,
                                                            url) =>
                                                        const CupertinoActivityIndicator(
                                                      radius: 15,
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                index.name!,
                                                style: TextStyle(
                                                  color: black,
                                                  fontSize: 15.0,
                                                  fontFamily:
                                                      AppStrings.fontname,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              subtitle: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot
                                                                .data!
                                                                .docs[0][
                                                                    'image_url']
                                                                .toString()
                                                                .length >
                                                            0
                                                        ? "Photo"
                                                        : snapshot.data!.docs[0]
                                                            ['text'],
                                                    style: TextStyle(
                                                      color: chatcolor,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  //const Divider()
                                                ],
                                              ),
                                              trailing: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    snapshot.data!.docs[0]
                                                                ["time"] !=
                                                            null
                                                        ? DateFormat.MMMd(
                                                                'en_US')
                                                            .add_jm()
                                                            .format(snapshot
                                                                .data!
                                                                .docs[0]["time"]
                                                                .toDate())
                                                            .toString()
                                                        : "",
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: AppStrings
                                                            .fontname),
                                                  ),
                                                  snapshot.data!.docs[0][
                                                                  'sender_id'] !=
                                                              widget.currentUser
                                                                  .id &&
                                                          !snapshot.data!
                                                              .docs[0]['isRead']
                                                      ? Container(
                                                          width: 39.0,
                                                          height: 18.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: btncolor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0),
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                            'NEW',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        )
                                                      : const Text(""),
                                                  snapshot.data!.docs[0]
                                                              ['sender_id'] ==
                                                          widget.currentUser.id
                                                      ? !snapshot.data!.docs[0]
                                                              ['isRead']
                                                          ? const Icon(
                                                              Icons.done,
                                                              color:
                                                                  Colors.grey,
                                                              size: 15,
                                                            )
                                                          : Icon(
                                                              Icons.done_all,
                                                              color: btncolor,
                                                              size: 15,
                                                            )
                                                      : const Text(""),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 30),
                                            child: Divider(),
                                          )
                                        ],
                                      );
                                    }),
                              ))
                          .toList()),
            )));
  }
}
