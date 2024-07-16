// ignore_for_file: library_private_types_in_public_api, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Chat/recent_chats.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/util/color.dart';
import 'Matches.dart';

class HomeScreen extends StatefulWidget {
  final User currentUser;
  final List<User> matches;
  final List<User> newmatches;
  const HomeScreen(this.currentUser, this.matches, this.newmatches,
      {super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (widget.matches.length > 0 && widget.matches[0].lastmsg != null) {
        widget.matches.sort((a, b) {
          if (a.lastmsg != null && b.lastmsg != null) {
            var adate = a.lastmsg; //before -> var adate = a.expiry;
            var bdate = b.lastmsg; //before -> var bdate = b.expiry;
            return bdate!.compareTo(
                adate!); //to get the order other way just switch `adate & bdate`
          }
          return 1;
        });
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: btncolor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // InkWell(
            //   onTap: () {
            //     //Navigator.pop(context);
            //   },
            //   child: Container(
            //     height: 40,
            //     width: 40,
            //     decoration: BoxDecoration(
            //       color: pink,
            //       borderRadius: BorderRadius.circular(100),
            //       border: Border.all(color: black.withOpacity(0.5)),
            //     ),
            //     child: const Padding(
            //       padding: EdgeInsets.only(left: 7),
            //       child: Icon(
            //         Icons.arrow_back_ios,
            //         size: 22,
            //       ),
            //     ),
            //   ),
            // ),

            const SizedBox(width: 10), // Adjust the width as needed for spacing
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(right: 65),
                  child: widget.matches.length > 0
                      ? Text(
                          "Chats",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppStrings.fontname,
                            fontSize: 22,
                            color: black,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Container()),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          color: btncolor,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                widget.matches.length > 0
                    ? Matches(widget.currentUser, widget.newmatches)
                    : Container(),
                RecentChats(widget.currentUser, widget.matches),
                //const Divider(),
                // TabBar(
                //   controller: _tabController,
                //   labelColor: btncolor,
                //   indicatorColor: btncolor,
                //   tabs: const [
                //     Tab(text: 'Recent messages'),
                //     Tab(text: 'Favorites'),
                //   ],
                // ),
                // Expanded(
                //   child: TabBarView(
                //     controller: _tabController,
                //     clipBehavior: Clip.antiAlias,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.all(20),
                //         child: Column(
                //           children: [
                //             RecentChats(widget.currentUser, widget.matches),
                //           ],
                //         ),
                //       ),
                //       Center(
                //         child: LikedUserProfileScreen(
                //             widget.currentUser, widget.matches),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
