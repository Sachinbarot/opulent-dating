// // ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, prefer_const_constructors, prefer_is_empty

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
// import 'package:hookup4u/Screens/Calling/utils/strings.dart';
// //import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:hookup4u/Screens/Information.dart';
// import 'package:hookup4u/Screens/Payment/paymentDetails.dart';
// import 'package:hookup4u/Screens/Profile/EditProfile.dart';
// import 'package:hookup4u/Screens/Profile/settings.dart';
// import 'package:hookup4u/models/user_model.dart';
// import 'package:hookup4u/util/color.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import '../Payment/subscriptions.dart';
// import 'package:easy_localization/easy_localization.dart';

// final List adds = [
//   {
//     'icon': Icons.whatshot,
//     'color': Colors.indigo,
//     'title': "Get matches faster",
//     'subtitle': "Boost your profile once a month",
//   },
//   {
//     'icon': Icons.favorite,
//     'color': Colors.lightBlueAccent,
//     'title': "more likes",
//     'subtitle': "Get free rewindes",
//   },
//   {
//     'icon': Icons.star_half,
//     'color': Colors.amber,
//     'title': "Increase your chances",
//     'subtitle': "Get unlimited free likes",
//   },
//   {
//     'icon': Icons.location_on,
//     'color': Colors.purple,
//     'title': "Swipe around the world",
//     'subtitle': "Passport to anywhere with Opulent Dating",
//   },
//   {
//     'icon': Icons.vpn_key,
//     'color': Colors.orange,
//     'title': "Control your profile",
//     'subtitle': "highly secured",
//   }
// ];

// class Profile extends StatefulWidget {
//   final User currentUser;
//   final bool isPuchased;
//   final Map items;
//   final List<PurchaseDetails> purchases;
//   const Profile(this.currentUser, this.isPuchased, this.purchases, this.items,
//       {super.key});

//   @override
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   final EditProfileState _editProfileState = EditProfileState();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backcolor,
//       body: SingleChildScrollView(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 height: 310,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('asset/shape.png'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 70,
//                     ),
//                     Center(
//                       child: Hero(
//                         tag: "abc",
//                         child: Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(color: pink, width: 2.0),
//                             ),
//                             child: CircleAvatar(
//                               radius: 50,
//                               backgroundColor: secondryColor,
//                               child: Stack(
//                                 children: <Widget>[
//                                   InkWell(
//                                     onTap: () => showDialog(
//                                       barrierDismissible: false,
//                                       context: context,
//                                       builder: (context) {
//                                         return Info(widget.currentUser,
//                                             widget.currentUser, null);
//                                       },
//                                     ),
//                                     child: Center(
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(80),
//                                         child: CachedNetworkImage(
//                                           height: 100,
//                                           width: 100,
//                                           fit: BoxFit.fill,
//                                           imageUrl: widget.currentUser.imageUrl!
//                                                       .length >
//                                                   0
//                                               ? widget.currentUser
//                                                       .imageUrl![0] ??
//                                                   ''
//                                               : '',
//                                           useOldImageOnUrlChange: true,
//                                           placeholder: (context, url) =>
//                                               CupertinoActivityIndicator(
//                                             radius: 15,
//                                           ),
//                                           errorWidget: (context, url, error) =>
//                                               Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: <Widget>[
//                                               Icon(
//                                                 Icons.error,
//                                                 color: Colors.black,
//                                                 size: 30,
//                                               ),
//                                               Text(
//                                                 "Enable to load"
//                                                     .tr()
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Align(
//                                     alignment: Alignment.bottomRight,
//                                     child: InkWell(
//                                       onTap: () {
//                                         _editProfileState.source(
//                                             context, widget.currentUser, true);
//                                       },
//                                       child: Container(
//                                         height: 30,
//                                         width: 30,
//                                         decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(100),
//                                             color: white),
//                                         child: Center(
//                                           child: Icon(
//                                             Icons.add,
//                                             size: 25,
//                                             color: black,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     Text(
//                       widget.currentUser.name != null &&
//                               widget.currentUser.age != null
//                           ? "${widget.currentUser.name}, ${widget.currentUser.age}"
//                           : "",
//                       style: TextStyle(
//                           color: black,
//                           fontFamily: AppStrings.fontname,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 28),
//                     ),
//                     Text(
//                       widget.currentUser.editInfo!['job_title'] != null
//                           ? "${widget.currentUser.editInfo!['job_title']}  ${widget.currentUser.editInfo!['company'] != null ? "at ${widget.currentUser.editInfo!['company']}" : ""}"
//                           : "",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           color: black.withOpacity(0.7),
//                           fontFamily: AppStrings.fontname,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 20),
//                     ),
//                     Text(
//                       widget.currentUser.editInfo!['university'] != null
//                           ? "${widget.currentUser.editInfo!['university']}"
//                           : "",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           color: black.withOpacity(0.7),
//                           fontFamily: AppStrings.fontname,
//                           fontWeight: FontWeight.w400,
//                           fontSize: 20),
//                     ),
//                     // SizedBox(
//                     //   height: MediaQuery.of(context).size.height * .13,
//                     //   child: CustomPaint(
//                     //     painter: CurvePainter(),
//                     //     size: Size.infinite,
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 40,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       height: 100,
//                       margin: EdgeInsets.only(left: 20, right: 20),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: pink,
//                       ),
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             width: 10,
//                           ),
//                           CircularPercentIndicator(
//                             radius: 25.0,
//                             lineWidth: 1.0,
//                             percent: 0.2,
//                             center: Text(
//                               "20 %",
//                               style: TextStyle(
//                                 fontFamily: AppStrings.fontname,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 14,
//                                 color: white,
//                               ),
//                             ),
//                             progressColor: white,
//                             backgroundColor: Colors.grey,
//                           ),
//                           SizedBox(
//                             width: 10,
//                           ),
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SizedBox(
//                                   height: 25,
//                                 ),
//                                 Text(
//                                   "Complete Your Profile ",
//                                   style: TextStyle(
//                                     fontFamily: AppStrings.fontname,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 14,
//                                     color: white,
//                                   ),
//                                 ),
//                                 Text(
//                                   "Complete your profile to experience \n best dating and best matches!",
//                                   style: TextStyle(
//                                     fontFamily: AppStrings.fontname,
//                                     fontWeight: FontWeight.w300,
//                                     fontSize: 12,
//                                     color: white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 18,
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         CupertinoPageRoute(
//                           builder: (context) => EditProfile(widget.currentUser),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white,
//                       ),
//                       margin: EdgeInsets.only(left: 20, right: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           SizedBox(width: 10),
//                           Image.asset(
//                             'asset/addnew.png',
//                             height: 32,
//                           ),
//                           SizedBox(width: 10),
//                           Text(
//                             "Edit My Details",
//                             style: TextStyle(
//                               color: black.withOpacity(0.7),
//                               fontFamily: AppStrings.fontname,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                             ),
//                           ),
//                           Spacer(),
//                           Icon(
//                             Icons.arrow_forward_ios,
//                             size: 18,
//                           ),
//                           SizedBox(
//                             width: 20,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 19,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       _editProfileState.source(
//                           context, widget.currentUser, false);
//                     },
//                     child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white,
//                       ),
//                       margin: EdgeInsets.only(left: 20, right: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           SizedBox(width: 10),
//                           Image.asset(
//                             'asset/addphots.png',
//                             height: 32,
//                           ),
//                           SizedBox(width: 10),
//                           Text(
//                             "Add Photos",
//                             style: TextStyle(
//                               color: black.withOpacity(0.7),
//                               fontFamily: AppStrings.fontname,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                             ),
//                           ),
//                           Spacer(),
//                           Icon(
//                             Icons.arrow_forward_ios,
//                             size: 18,
//                           ),
//                           SizedBox(
//                             width: 20,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 19,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         CupertinoPageRoute(
//                           maintainState: true,
//                           builder: (context) => Settings(widget.currentUser,
//                               widget.isPuchased, widget.items),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       height: 50,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white,
//                       ),
//                       margin: EdgeInsets.only(left: 20, right: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           SizedBox(width: 10),
//                           Image.asset(
//                             'asset/setting.png',
//                             height: 32,
//                           ),
//                           SizedBox(width: 10),
//                           Text(
//                             "Setting",
//                             style: TextStyle(
//                               color: black.withOpacity(0.7),
//                               fontFamily: AppStrings.fontname,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                             ),
//                           ),
//                           Spacer(),
//                           Icon(
//                             Icons.arrow_forward_ios,
//                             size: 18,
//                           ),
//                           SizedBox(
//                             width: 20,
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   SizedBox(
//                     height: 100,
//                     width: MediaQuery.of(context).size.width * .85,
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Swiper(
//                         key: UniqueKey(),
//                         curve: Curves.linear,
//                         autoplay: true,
//                         physics: ScrollPhysics(),
//                         itemBuilder: (BuildContext context, int index2) {
//                           return Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Icon(
//                                     adds[index2]["icon"],
//                                     color: adds[index2]["color"],
//                                   ),
//                                   SizedBox(
//                                     width: 5,
//                                   ),
//                                   Text(
//                                     adds[index2]["title"],
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                       fontFamily: AppStrings.fontname,
//                                       fontSize: 20,
//                                       color: black,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Text(
//                                 adds[index2]["subtitle"],
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontFamily: AppStrings.fontname,
//                                   fontSize: 14,
//                                   color: black.withOpacity(0.5),
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           );
//                         },
//                         itemCount: adds.length,
//                         pagination: SwiperPagination(
//                           alignment: Alignment.bottomCenter,
//                           builder: DotSwiperPaginationBuilder(
//                             activeSize: 10,
//                             color: secondryColor,
//                             activeColor: btncolor,
//                           ),
//                         ),
//                         control: SwiperControl(
//                           size: 20,
//                           color: btncolor,
//                           disableColor: secondryColor,
//                         ),
//                         loop: false,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: InkWell(
//                   child: Container(
//                       decoration: BoxDecoration(
//                           shape: BoxShape.rectangle,
//                           borderRadius: BorderRadius.circular(10),
//                           color: btncolor),
//                       height: MediaQuery.of(context).size.height * .065,
//                       width: MediaQuery.of(context).size.width * .75,
//                       child: Center(
//                           child: Text(
//                         widget.isPuchased && widget.purchases != null
//                             ? "Check Payment Details"
//                             : "Subscribe Plan",
//                         style: TextStyle(
//                             fontSize: 15,
//                             color: textColor,
//                             fontWeight: FontWeight.bold),
//                       ))),
//                   onTap: () async {
//                     if (widget.isPuchased && widget.purchases != null) {
//                       Navigator.push(
//                         context,
//                         CupertinoPageRoute(
//                             builder: (context) =>
//                                 PaymentDetails(widget.purchases)),
//                       );
//                     } else {
//                       Navigator.push(
//                         context,
//                         CupertinoPageRoute(
//                             builder: (context) => Subscription(
//                                 widget.currentUser, null, widget.items)),
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ]),
//       ),
//     );
//   }
// }

// class CurvePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint();

//     paint.color = secondryColor.withOpacity(.4);
//     paint.style = PaintingStyle.stroke;
//     paint.strokeWidth = 1.5;

//     var startPoint = Offset(0, -size.height / 2);
//     var controlPoint1 = Offset(size.width / 4, size.height / 3);
//     var controlPoint2 = Offset(3 * size.width / 4, size.height / 3);
//     var endPoint = Offset(size.width, -size.height / 2);

//     var path = Path();
//     path.moveTo(startPoint.dx, startPoint.dy);
//     path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
//         controlPoint2.dy, endPoint.dx, endPoint.dy);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Information.dart';
import 'package:hookup4u/Screens/Payment/paymentDetails.dart';
import 'package:hookup4u/Screens/Payment/premium.dart';
import 'package:hookup4u/Screens/Payment/subscriptions.dart';
import 'package:hookup4u/Screens/Profile/EditProfile.dart';
import 'package:hookup4u/Screens/Profile/settings.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/util/color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:easy_localization/easy_localization.dart';

final List adds = [
  {
    'icon': Icons.whatshot,
    'color': Colors.indigo,
    'title': "Get matches faster",
    'subtitle': "Boost your profile once a month",
  },
  {
    'icon': Icons.favorite,
    'color': Colors.lightBlueAccent,
    'title': "more likes",
    'subtitle': "Get free rewindes",
  },
  {
    'icon': Icons.star_half,
    'color': Colors.amber,
    'title': "Increase your chances",
    'subtitle': "Get unlimited free likes",
  },
  {
    'icon': Icons.location_on,
    'color': Colors.purple,
    'title': "Swipe around the world",
    'subtitle': "Passport to anywhere with Opulent Dating",
  },
  {
    'icon': Icons.vpn_key,
    'color': Colors.orange,
    'title': "Control your profile",
    'subtitle': "highly secured",
  }
];

class Profile extends StatefulWidget {
  final User currentUser;
  final bool isPuchased;
  final Map items;
  final List<PurchaseDetails> purchases;
  Profile(this.currentUser, this.isPuchased, this.purchases, this.items);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final EditProfileState _editProfileState = EditProfileState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backcolor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.38,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('asset/shape.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.099),
                  Center(
                    child: Hero(
                      tag: "abc",
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.01),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: pink, width: 2.0),
                          ),
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.12,
                            backgroundColor: secondryColor,
                            child: Stack(
                              children: <Widget>[
                                InkWell(
                                  onTap: () => showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Info(widget.currentUser,
                                          widget.currentUser, null);
                                    },
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(80),
                                      child: CachedNetworkImage(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        fit: BoxFit.fill,
                                        imageUrl: widget.currentUser.imageUrl!
                                                    .length >
                                                0
                                            ? widget.currentUser.imageUrl![0] ??
                                                ''
                                            : '',
                                        useOldImageOnUrlChange: true,
                                        placeholder: (context, url) =>
                                            const CupertinoActivityIndicator(
                                          radius: 15,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            const Icon(
                                              Icons.error,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                            Text(
                                              "Enable to load".tr(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () {
                                      _editProfileState.source(
                                          context, widget.currentUser, true);
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: white),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          size: 25,
                                          color: black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Text(
                    "${widget.currentUser.editInfo != null && widget.currentUser.editInfo!['UserName'] != null ? widget.currentUser.editInfo!['UserName'] : widget.currentUser.name},${widget.currentUser.age}",
                    // widget.currentUser.age != null ||
                    //         widget.currentUser.name != null
                    //     ? "${widget.currentUser.editInfo!['UserName']},${widget.currentUser.age}"
                    //     : "${widget.currentUser.name},${widget.currentUser.age}",
                    style: TextStyle(
                        color: black,
                        fontFamily: AppStrings.fontname,
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.width * 0.07),
                  ),

                  // Text(
                  //   widget.currentUser.editInfo!['job_title'] != null
                  //       ? "${widget.currentUser.editInfo!['job_title']}  ${widget.currentUser.editInfo!['company'] != null ? "at ${widget.currentUser.editInfo!['company']}" : ""}"
                  //       : "",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //       color: black.withOpacity(0.7),
                  //       fontFamily: AppStrings.fontname,
                  //       fontWeight: FontWeight.w400,
                  //       fontSize: MediaQuery.of(context).size.width * 0.05),
                  // ),
                  // Text(
                  //   widget.currentUser.editInfo!['university'] != null
                  //       ? "${widget.currentUser.editInfo!['university']}"
                  //       : "",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //       color: black.withOpacity(0.7),
                  //       fontFamily: AppStrings.fontname,
                  //       fontWeight: FontWeight.w400,
                  //       fontSize: MediaQuery.of(context).size.width * 0.05),
                  // ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: pink,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        CircularPercentIndicator(
                          radius:
                              MediaQuery.of(context).size.width * 0.15 * 0.5,
                          lineWidth: 1.0,
                          percent: 0.2,
                          center: Text(
                            "20 %",
                            style: TextStyle(
                              fontFamily: AppStrings.fontname,
                              fontWeight: FontWeight.w600,
                              fontSize: MediaQuery.of(context).size.width *
                                  0.18 *
                                  0.18,
                              color: white,
                            ),
                          ),
                          progressColor: white,
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.15 *
                                      0.25),
                              Text(
                                "Complete Your Profile ".tr(),
                                style: TextStyle(
                                  fontFamily: AppStrings.fontname,
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.20 *
                                      0.20,
                                  color: white,
                                ),
                              ),
                              Text(
                                "Complete your profile to experience \n best dating and best matches!",
                                style: TextStyle(
                                  fontFamily: AppStrings.fontname,
                                  fontWeight: FontWeight.w300,
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.17 *
                                      0.14,
                                  color: white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => EditProfile(widget.currentUser),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(width: 10),
                        Image.asset(
                          'asset/addnew.png',
                          height: MediaQuery.of(context).size.width * 0.07,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Edit My Details",
                          style: TextStyle(
                            color: black.withOpacity(0.7),
                            fontFamily: AppStrings.fontname,
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: MediaQuery.of(context).size.width * 0.06,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    _editProfileState.source(
                        context, widget.currentUser, false);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(width: 10),
                        Image.asset(
                          'asset/addphots.png',
                          height: MediaQuery.of(context).size.width * 0.07,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Add Photos",
                          style: TextStyle(
                            color: black.withOpacity(0.7),
                            fontFamily: AppStrings.fontname,
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: MediaQuery.of(context).size.width * 0.06,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        maintainState: true,
                        builder: (context) => Settings(widget.currentUser,
                            widget.isPuchased, widget.items),
                      ),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(width: 10),
                        Image.asset(
                          'asset/setting.png',
                          height: MediaQuery.of(context).size.width * 0.07,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Setting",
                          style: TextStyle(
                            color: black.withOpacity(0.7),
                            fontFamily: AppStrings.fontname,
                            fontWeight: FontWeight.w600,
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: MediaQuery.of(context).size.width * 0.06,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Swiper(
                      key: UniqueKey(),
                      curve: Curves.linear,
                      autoplay: true,
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index2) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  adds[index2]["icon"],
                                  color: adds[index2]["color"],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  adds[index2]["title"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: AppStrings.fontname,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    color: black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              adds[index2]["subtitle"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppStrings.fontname,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                                color: black.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      },
                      itemCount: adds.length,
                      pagination: SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        builder: DotSwiperPaginationBuilder(
                          activeSize: 10,
                          color: secondryColor,
                          activeColor: btncolor,
                        ),
                      ),
                      control: SwiperControl(
                        size: 20,
                        color: btncolor,
                        disableColor: secondryColor,
                      ),
                      loop: false,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: InkWell(
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        color: btncolor),
                    height: MediaQuery.of(context).size.height * 0.065,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Center(
                        child: Text(
                      widget.isPuchased && widget.purchases != null
                          ? "Check Payment Details"
                          : "Subscribe Plan",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          color: textColor,
                          fontWeight: FontWeight.bold),
                    ))),
                onTap: () async {
                  if (widget.isPuchased && widget.purchases != null) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) =>
                              PaymentDetails(widget.purchases)),
                    );
                  } else {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => PremiumScreen()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
