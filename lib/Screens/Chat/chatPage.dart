// ignore_for_file: file_names, library_private_types_in_public_api, unused_field, unnecessary_new, unnecessary_this, avoid_print, no_leading_underscores_for_local_identifiers, unnecessary_nullable_for_final_variable_declarations, sort_child_properties_last, unnecessary_string_interpolations, prefer_is_empty, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hookup4u/Screens/Calling/utils/settings.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Chat/largeImage.dart';
import 'package:hookup4u/Screens/Information.dart';
import 'package:hookup4u/Screens/reportUser.dart';
import 'package:hookup4u/ads/ads.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/util/color.dart';
import 'package:hookup4u/util/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Calling/dial.dart';

class ChatPage extends StatefulWidget {
  final User sender;
  final String chatId;
  final User second;
  const ChatPage(
      {super.key,
      required this.sender,
      required this.chatId,
      required this.second});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  // final BannerAd myBanner = BannerAd(
  //   adUnitId: AdHelper.bannerAdUnitId,
  //   size: AdSize.banner,
  //   request: AdRequest(),
  //   listener: BannerAdListener(),
  // );
  // late AdWidget adWidget;

  // final AdSize adSize = AdSize(
  //   height: 50,
  //   width: 320,
  // );
  bool isBlocked = false;
  final db = FirebaseFirestore.instance;
  late CollectionReference chatReference;
  final TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Ads _ads = new Ads();

  @override
  void initState() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));

    _loadInterstitialAd();
    Future.delayed(const Duration(milliseconds: 5000), () {
      setState(() {
        if (_isInterstitialAdReady) {
          _interstitialAd?.show();
        }
      });
    });

    WidgetsBinding.instance.addObserver(this);
    setstatus("Online");
    //_initSharedPreferences();
    super.initState();
    //myBanner.load();
    //  _ad
    chatReference =
        db.collection("chats").doc(widget.chatId).collection('messages');
    checkblock();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();

    super.dispose();
  }

  Future<void> sendNotification() async {
    try {
      if (widget.sender.pushToken != null) {
        var headers = {
          'Authorization': 'key=$SERVER_KEY',
          'Content-Type': 'application/json'
        };
        var data = json.encode({
          "to": widget.second.pushToken,
          "notification": {
            "body": "You Have New Message by ${widget.sender.name}"
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

  var blockedBy;
  checkblock() {
    chatReference.doc('blocked').snapshots().listen((onData) {
      if (true) {
        // (onData.data != null) {
        blockedBy = onData.get('blockedBy');
        if (onData.get('isBlocked')) {
          isBlocked = true;
        } else {
          isBlocked = false;
        }

        if (mounted) setState(() {});
      }
      // print(onData.data['blockedBy']);
    });
  }

  // Future<void> _initSharedPreferences() async {
  //   _prefs = await SharedPreferences.getInstance();
  // }
  String? globalStatus;

  Future<void> setStatus(String statusUser) async {
    if (widget.second.id != null) {
      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(widget.second.id)
            .update({"status": statusUser});

        final SharedPreferences _prefs = await SharedPreferences.getInstance();
        await _prefs.setString('status', statusUser);
        globalStatus = statusUser;
      } catch (e) {
        print("Error in setstatus: $e");
      }
    }
  }

  Future<void> setstatus(String status) async {
    final User? user = widget.second;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.id)
            .update({"status": status});

        final SharedPreferences _prefs = await SharedPreferences.getInstance();
        await _prefs.setString('status', status);
      } catch (e) {
        print("Error in setstatus: $e");
      }
    }
  }

  List<Widget> generateSenderLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              child: documentSnapshot.get('image_url') != ''
                  ? InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Container(
                            margin: const EdgeInsets.only(
                                top: 2.0, bottom: 2.0, right: 15),
                            child: Stack(
                              children: <Widget>[
                                CachedNetworkImage(
                                  placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator(
                                      radius: 10,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  height:
                                      MediaQuery.of(context).size.height * .65,
                                  width: MediaQuery.of(context).size.width * .9,
                                  imageUrl:
                                      documentSnapshot.get('image_url') ?? '',
                                  fit: BoxFit.fitWidth,
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: documentSnapshot.get('isRead') == false
                                      ? Icon(
                                          Icons.done,
                                          color: secondryColor,
                                          size: 15,
                                        )
                                      : Icon(
                                          Icons.done_all,
                                          color: btncolor,
                                          size: 15,
                                        ),
                                )
                              ],
                            ),
                            height: 150,
                            width: 150.0,
                            color: secondryColor.withOpacity(.5),
                            padding: const EdgeInsets.all(5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                                documentSnapshot.get('time') != null
                                    ? DateFormat.yMMMd('en_US')
                                        .add_jm()
                                        .format(documentSnapshot
                                            .get('time')
                                            .toDate())
                                        .toString()
                                    : "",
                                style: TextStyle(
                                  color: secondryColor,
                                  fontSize: 15.0,
                                  fontFamily: AppStrings.fontname,
                                  fontWeight: FontWeight.w500,
                                )),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => LargeImage(
                              documentSnapshot.get('image_url'),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      width: MediaQuery.of(context).size.width * 0.65,
                      margin: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 80.0, right: 10),
                      decoration: BoxDecoration(
                          color: btncolor.withOpacity(.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  documentSnapshot.get('text'),
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 15.0,
                                    fontFamily: AppStrings.fontname,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    documentSnapshot.get('time') != null
                                        ? DateFormat.MMMd('en_US')
                                            .add_jm()
                                            .format(documentSnapshot
                                                .get('time')
                                                .toDate())
                                            .toString()
                                        : "",
                                    style: TextStyle(
                                      color: secondryColor,
                                      fontSize: 10.0,
                                      fontFamily: AppStrings.fontname,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  documentSnapshot.get('isRead') == false
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.grey,
                                          size: 15,
                                        )
                                      : Icon(
                                          Icons.done_all,
                                          color: btncolor,
                                          size: 15,
                                        )
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
            ),
          ],
        ),
      ),
    ];
  }

  _messagesIsRead(documentSnapshot) {
    return <Widget>[
      // Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: <Widget>[
      //     // InkWell(
      //     //   child: CircleAvatar(
      //     //     backgroundColor: secondryColor,
      //     //     radius: 25.0,
      //     //     child: ClipRRect(
      //     //       borderRadius: BorderRadius.circular(90),
      //     //       child: CachedNetworkImage(
      //     //         imageUrl: widget.second.imageUrl![0] ?? '',
      //     //         useOldImageOnUrlChange: true,
      //     //         placeholder: (context, url) =>
      //     //             const CupertinoActivityIndicator(
      //     //           radius: 15,
      //     //         ),
      //     //         errorWidget: (context, url, error) => const Icon(Icons.error),
      //     //       ),
      //     //     ),
      //     //   ),
      //     //   onTap: () => showDialog(
      //     //       barrierDismissible: false,
      //     //       context: context,
      //     //       builder: (context) {
      //     //         return Info(widget.second, widget.sender, null);
      //     //       }),
      //     // ),
      //   ],
      // ),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: documentSnapshot.data()!['image_url'] != ''
                  ? InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                              top: 2.0,
                              bottom: 2.0,
                              right: 15,
                            ),
                            child: CachedNetworkImage(
                              placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator(
                                  radius: 10,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              height: MediaQuery.of(context).size.height * .65,
                              width: MediaQuery.of(context).size.width * .9,
                              imageUrl:
                                  documentSnapshot.data()!['image_url'] ?? '',
                              fit: BoxFit.fitWidth,
                            ),
                            height: 150,
                            width: 150.0,
                            color: const Color.fromRGBO(0, 0, 0, 0.2),
                            padding: const EdgeInsets.all(5),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                                documentSnapshot.data()!["time"] != null
                                    ? DateFormat.yMMMd('en_US')
                                        .add_jm()
                                        .format(documentSnapshot
                                            .data()!["time"]
                                            .toDate())
                                        .toString()
                                    : "",
                                style: TextStyle(
                                  color: secondryColor,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400,
                                )),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => LargeImage(
                            documentSnapshot.data()!['image_url'],
                          ),
                        ));
                      },
                    )
                  : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      width: MediaQuery.of(context).size.width * 0.65,
                      margin: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, right: 10, left: 10),
                      decoration: BoxDecoration(
                          color: recivedcolor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  documentSnapshot.data()!['text'],
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 15.0,
                                    fontFamily: AppStrings.fontname,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    documentSnapshot.data()!["time"] != null
                                        ? DateFormat.MMMd('en_US')
                                            .add_jm()
                                            .format(documentSnapshot
                                                .data()!["time"]
                                                .toDate())
                                            .toString()
                                        : "",
                                    style: TextStyle(
                                      color: lightgrey,
                                      fontSize: 10.0,
                                      fontFamily: AppStrings.fontname,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    if (!documentSnapshot.get('isRead')) {
      chatReference.doc(documentSnapshot.id).update({
        'isRead': true,
      });

      return _messagesIsRead(documentSnapshot);
    }
    return _messagesIsRead(documentSnapshot);
  }

  generateMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map<Widget>((doc) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: doc.get('type') == "Call"
                      ? [
                          Text(doc.get('time') != null
                              ? "${doc.get('text')} : ${DateFormat.yMMMd('en_US').add_jm().format(doc.get('time').toDate())} by ${doc.get('sender_id') == widget.sender.id ? "You" : "${widget.second.name}"}"
                              : "")
                        ]
                      : doc.get('sender_id') != widget.sender.id
                          ? generateReceiverLayout(
                              doc,
                            )
                          : generateSenderLayout(doc)),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: pink,
      appBar: AppBar(
          backgroundColor: pink,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: black,
                onPressed: () => Navigator.pop(context),
              ),
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return Info(widget.second, widget.sender, null);
                      });
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.second.imageUrl![0]),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.second.name!,
                      style: TextStyle(
                        fontFamily: AppStrings.fontname,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Users")
                          .doc(widget.second.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }

                        var userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        var userStatus = userData['status'] ?? "No status";

                        return Text(
                          '$userStatus',
                          style: TextStyle(
                            fontFamily: AppStrings.fontname,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back_ios),
          //   color: black,
          //   onPressed: () => Navigator.pop(context),
          // ),
          actions: <Widget>[
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                onJoin("VideoCall");
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: btncolor),
                  color: callcolor,
                ),
                margin: const EdgeInsets.all(5),
                child: Icon(
                  Icons.video_call,
                  color: black,
                ),
              ),
            ),
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: btncolor),
                color: callcolor,
              ),
              margin: const EdgeInsets.all(5),
              child: IconButton(
                icon: Icon(
                  Icons.call,
                  color: black,
                ),
                onPressed: () => onJoin("AudioCall"),
              ),
            ),
            // const SizedBox(
            //   width: 20,
            // ),
            PopupMenuButton(itemBuilder: (ct) {
              return [
                PopupMenuItem(
                  value: 'value1',
                  child: InkWell(
                    onTap: () => showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => ReportUser(
                              currentUser: widget.sender,
                              seconduser: widget.second,
                            )).then((value) => Navigator.pop(ct)),
                    child: Container(
                        width: 100,
                        height: 30,
                        child: const Text(
                          "Report",
                        )),
                  ),
                ),
                PopupMenuItem(
                  height: 30,
                  value: 'value2',
                  child: InkWell(
                    child: Text(isBlocked ? "Unblock user" : "Block user"),
                    onTap: () {
                      Navigator.pop(ct);
                      showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: Text(isBlocked ? 'Unblock' : 'Block'),
                            content: const Text('Do you want to ').tr(args: [
                              "${isBlocked ? 'Unblock' : 'Block'}",
                              "${widget.second.name}"
                            ]),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('No'.tr().toString()),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(ctx);
                                  if (isBlocked &&
                                      blockedBy == widget.sender.id) {
                                    chatReference.doc('blocked').set({
                                      'isBlocked': !isBlocked,
                                      'blockedBy': widget.sender.id,
                                    }, SetOptions(merge: true));
                                  } else if (!isBlocked) {
                                    chatReference.doc('blocked').set({
                                      'isBlocked': !isBlocked,
                                      'blockedBy': widget.sender.id,
                                    }, SetOptions(merge: true));
                                  } else {
                                    CustomSnackbar.snackbar(
                                        "You can't unblock", context);
                                  }
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                )
              ];
            })
          ]),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: pink,
          body: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            child: Container(
              decoration: const BoxDecoration(
                  // image: DecorationImage(
                  //     fit: BoxFit.fitWidth,
                  //     image: AssetImage("asset/chat.jpg")),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Colors.white),
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: chatReference
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(primaryColor),
                            strokeWidth: 2,
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView(
                          reverse: true,
                          children: generateMessages(snapshot),
                        ),
                      );
                    },
                  ),
                  // const Divider(height: 1.0),
                  Container(
                    height: 64,
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(color: white),
                    child: isBlocked
                        ? const Text("Sorry You can't send message!")
                        : _buildTextComposer(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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

  Widget getDefaultSendButton() {
    return IconButton(
      icon: Transform.rotate(
        angle: -pi / 9,
        child: const Icon(
          Icons.send,
          size: 16,
        ),
      ),
      color: black,
      onPressed: _isWritting
          ? () => _sendText(_textController.text.trimRight())
          : null,
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(color: _isWritting ? primaryColor : secondryColor),
        child: Container(
          height: 64,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
              border: Border.all(color: massagecolor),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  ImagePicker imagePicker = ImagePicker();
                  var image =
                      await imagePicker.pickImage(source: ImageSource.gallery);
                  int timestamp = new DateTime.now().millisecondsSinceEpoch;
                  Reference storageReference = FirebaseStorage.instance
                      .ref()
                      .child('chats/${widget.chatId}/img_$timestamp.jpg');
                  UploadTask uploadTask =
                      storageReference.putFile(File(image!.path));
                  await uploadTask.then((p0) async {
                    String fileUrl = await storageReference.getDownloadURL();
                    _sendImage(messageText: 'Photo', imageUrl: fileUrl);
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  height: 33,
                  width: 33,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100), color: pink),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: black,
                    ),
                  ),
                ),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  maxLines: 15,
                  minLines: 1,
                  autofocus: false,
                  onChanged: (String messageText) {
                    setState(() {
                      _isWritting = messageText.trim().length > 0;
                    });
                  },
                  decoration: const InputDecoration.collapsed(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      hintText: "Type Message"),
                ),
              ),
              Row(
                children: [
                  Image.asset(
                    'asset/lines.png',
                    height: 40,
                  ),
                  Container(
                    height: 33,
                    width: 33,
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100), color: pink),
                    child: getDefaultSendButton(),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Future<Null> _sendText(String text) async {
    _textController.clear();
    sendNotification();
    chatReference.add({
      'type': 'Msg',
      'text': text,
      'sender_id': widget.sender.id,
      'receiver_id': widget.second.id,
      'isRead': false,
      'image_url': '',
      'time': FieldValue.serverTimestamp(),
    }).then((documentReference) {
      setState(() {
        _isWritting = false;
      });
    }).catchError((e) {});
  }

  void _sendImage({required String messageText, required String imageUrl}) {
    chatReference.add({
      'type': 'Image',
      'text': messageText,
      'sender_id': widget.sender.id,
      'receiver_id': widget.second.id,
      'isRead': false,
      'image_url': imageUrl,
      'time': FieldValue.serverTimestamp(),
    });
  }

  Future<void> onJoin(callType) async {
    if (!isBlocked) {
      print('----------call tye-----------$callType');
      print('----------widget.sender.ide-----------${widget.sender.id}');
      print('----------widget.sec.id-----------${widget.second.id}');
      await handleCameraAndMic(callType);
      await chatReference.add({
        'type': 'Call',
        'text': callType,
        'sender_id': widget.sender.id,
        'receiver_id': widget.second.id,
        'isRead': false,
        'image_url': "",
        'time': FieldValue.serverTimestamp(),
      });
      print('%%%%%%%%%%%%%%%${widget.chatId},${widget.second},$callType');

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DialCall(
              channelName: widget.chatId,
              receiver: widget.second,
              callType: callType,
              currentUser: widget.sender.name.toString(),
              imageUrl: widget.sender.imageUrl![0].toString()),
        ),
      );
    } else {
      CustomSnackbar.snackbar("Blocked !", context);
    }
  }



}

Future<void> handleCameraAndMic(callType) async {
  if (callType == 'VideoCall') {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  } else {
    await Permission.microphone.request();
  }

  // await PermissionHandler().requestPermissions(callType == "VideoCall"
  //     ? [PermissionGroup.camera, PermissionGroup.microphone]
  //     : [PermissionGroup.microphone]);
}
