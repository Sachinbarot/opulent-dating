// ignore_for_file: library_private_types_in_public_api, avoid_print, use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hookup4u/Screens/Chat/Matches.dart';
import 'package:hookup4u/Screens/Chat/chatPage.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/util/color.dart';

class LikedUserProfileScreen extends StatefulWidget {
  final User currentUser;
  final List<User> matches;

  const LikedUserProfileScreen(
    this.currentUser,
    this.matches,
  );

  @override
  _LikedUserProfileScreenState createState() => _LikedUserProfileScreenState();
}

class _LikedUserProfileScreenState extends State<LikedUserProfileScreen> {
  Stream<QuerySnapshot>? likedUsersStream;
  //final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    likedUsersStream = FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.currentUser.id.toString())
        .collection('LikedBy')
        .snapshots();

    //WidgetsBinding.instance.addObserver(this);
    //setstatus("Online");
  }

  // void setstatus(String status) async {
  //   await _firebaseFirestore
  //       .collection("Users")
  //       .doc(widget.currentUser.id)
  //       .update({
  //     "status": status,
  //   });
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     setstatus("Online");
  //   } else {
  //     setstatus("Offline");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backcolor,
      body: StreamBuilder<QuerySnapshot>(
        stream: likedUsersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          List<User> likedUsers = [];

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            likedUsers = snapshot.data!.docs
                .map((doc) {
                  if (doc.exists) {
                    final userData = doc.data() as Map<String, dynamic>?;

                    if (userData != null &&
                        userData.containsKey('name') &&
                        userData.containsKey('imageUrl')) {
                      return User(
                        id: doc.id,
                        name: userData['name'],
                        imageUrl: [userData['imageUrl']],
                      );
                    } else {
                      // Print debug information if the fields are missing
                      print("Missing fields in document: ${doc.id}");
                      return null;
                    }
                  } else {
                    // Print debug information if the document doesn't exist
                    print("Document doesn't exist: ${doc.id}");
                    return null;
                  }
                })
                .whereType<User>()
                .toList(); // Filter out null values
          }

          //return likedUsers.isNotEmpty
          return widget.matches.isNotEmpty || widget.currentUser.id != null
              ? ListView.builder(
                  itemCount: likedUsers.length,
                  itemBuilder: (context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => ChatPage(
                              chatId: chatId(
                                widget.currentUser,
                                widget.matches[index],
                              ),
                              sender: widget.currentUser,
                              second: widget.matches[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 80,
                        margin: const EdgeInsets.only(
                            top: 15.0, bottom: 15.0, right: 20.0, left: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                          color: secondryColor.withOpacity(.1),
                        ),
                        child: Center(
                          child: ListTile(
                            title: Text(
                              likedUsers[index].name.toString(),
                              style: const TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 15.0,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: secondryColor,
                              radius: 30.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: CachedNetworkImage(
                                  imageUrl: likedUsers[index].imageUrl![0],
                                  fit: BoxFit.cover,
                                  useOldImageOnUrlChange: true,
                                  placeholder: (context, url) =>
                                      const CupertinoActivityIndicator(
                                    radius: 20,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('No liked users yet.',
                      style: TextStyle(fontSize: 18.0)));
        },
      ),
    );
  }
}
