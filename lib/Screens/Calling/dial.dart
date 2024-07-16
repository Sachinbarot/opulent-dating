// ignore_for_file: library_private_types_in_public_api, avoid_print, prefer_const_constructors

import 'dart:convert';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/settings.dart';
import 'package:hookup4u/models/user_model.dart';
import 'call.dart';

class DialCall extends StatefulWidget {
  final String channelName;
  final User? receiver;
  final String callType;
  final String currentUser;
  final String imageUrl;
  const DialCall(
      {super.key,
      required this.channelName,
      required this.receiver,
      required this.callType,
      required this.currentUser,
      required this.imageUrl});

  @override
  _DialCallState createState() => _DialCallState();
}

class _DialCallState extends State<DialCall> {
  bool? ispickup = false;
  User? currentUser;

  CollectionReference callRef = FirebaseFirestore.instance.collection("calls");

  @override
  void initState() {
    _addCallingData();

    super.initState();
  }

  Future<void> _addCallingData() async {
    await callRef.doc(widget.channelName).delete();
    await callRef.doc(widget.channelName).set({
      'callType': widget.callType,
      'calling': true,
      'response': "Awaiting",
      'channel_id': widget.channelName,
      'last_call': FieldValue.serverTimestamp()
    }, SetOptions(merge: true));
    await sendNotification();
  }

  @override
  void dispose() async {
    super.dispose();
    ispickup = true;
    await callRef
        .doc(widget.channelName)
        .set({'calling': false}, SetOptions(merge: true));
    print('-------------dial dispose-----------');
  }

  Future<void> sendNotification() async {
    try {
      if (widget.receiver!.pushToken != null) {
        var headers = {
          'Authorization': 'key=$SERVER_KEY',
          'Content-Type': 'application/json'
        };

        var data = {
          "to": widget.receiver!.pushToken,
          "notification": {
            "body": widget.callType,
            "title": "Incoming Call By ${widget.currentUser}"
          },
          "data": {
            'callType': widget.callType,
            'calling': true,
            'response': "Awaiting",
            'channel_id': widget.channelName,
            'senderName': widget.currentUser,
            'userimage': widget.imageUrl
          },
          "priority": "high"
        };

        var dio = Dio();
        var response = await dio.post(
          'https://fcm.googleapis.com/fcm/send',
          options: Options(
            headers: headers,
          ),
          data: json.encode(data),
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
  Widget build(BuildContext context) {
    print('^^^^^^^^^^^^^^^^^${widget.channelName}, @@@${widget.receiver}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: callRef
              .where("channel_id", isEqualTo: widget.channelName)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // Future.delayed(Duration(seconds: 30), () async {
            //   if (!ispickup) {
            //     await callRef
            //         .doc(widget.channelName)
            //         .update({'response': 'Not-answer'});
            //   }
            // });
            if (!snapshot.hasData) {
              return Container();
            } else {
              try {
                if ((snapshot.data!.docs[0]['response']) == 'Awaiting') {
                  print('call is awaiting');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 60,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              60,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: widget.receiver!.imageUrl![0] ?? '',
                              useOldImageOnUrlChange: true,
                              placeholder: (context, url) =>
                                  const CupertinoActivityIndicator(
                                radius: 15,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.error,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  Text(
                                    "Unable to load",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text("Calling to ${widget.receiver!.name}",
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: Icon(
                            Icons.call_end,
                            color: Colors.white,
                          ),
                          label: Text(
                            "END",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await callRef.doc(widget.channelName).set(
                                {'response': "Call_Cancelled"},
                                SetOptions(merge: true));
                            //Navigator.pop(context);
                          })
                    ],
                  );
                } else if ((snapshot.data!.docs[0]['response']) == 'Pickup') {
                  print('call is pickedup');
                  ispickup = true;
                  return CallPage(
                    channelName: widget.channelName,
                    role: ClientRole.Broadcaster,
                    callType: widget.callType,
                    imagedata: widget.imageUrl,
                  );
                } else if ((snapshot.data!.docs[0]['response']) == 'Decline') {
                  print(
                      'decilne dial dart------------------------------------');
                  print('call declined');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("is Busy " "${widget.receiver!.name}",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Back",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          })
                    ],
                  );
                } else if ((snapshot.data!.docs[0]['response']) == 'Awaiting') {
                  print('not answering');
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("is Not-answering" "${widget.receiver!.name}",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Back",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                          })
                    ],
                  );
                }
                //       break;
                //call end
                else {
                  print('default is print');
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.pop(context);
                  });
                  return Text("Call Ended...");
                }
                //   break;
              }

              //  else if (!snapshot.data.documents[0]['calling']) {
              //   Navigator.pop(context);
              // }
              catch (e) {
                return Container();
              }
            }
          },
        ),
      ),
    );
  }
}
