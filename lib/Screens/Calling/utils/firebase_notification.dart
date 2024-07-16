// import 'dart:convert';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class FirebaseNotificationService {
//   static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//   static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

//   static initializeService() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       var initializationSettingsAndroid =
//           AndroidInitializationSettings('@mipmap/ic_launcher');
//       var initializationSettings =
//           InitializationSettings(android: initializationSettingsAndroid);
//       flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
//       flutterLocalNotificationsPlugin?.initialize(initializationSettings);
//       showLog("IOS NOTIFICATION DATA $message");
//       if (message.notification != null) {
//         PushNotificationModel model = PushNotificationModel();
//         model.title = message.notification!.title;
//         model.body = message.notification!.body;
//         showNotification(model);
//       } else {
//         PushNotificationModel model = PushNotificationModel();
//         model.title = message.data["title"];
//         model.body = message.data["body"];
//         showNotification(model);
//       }
//     });
//     FirebaseMessaging.onMessage.listen((message) {
//       print("onMessage data: ${message.data}");
//       print("onmessage${message.data['type']}");

//       print("onMessage data: ${message.data}");
//       print("onmessage${message.data['type']}");

//       if (Platform.isIOS && message.data['type'] == 'Call') {
//         Map callInfo = {};
//         callInfo['channel_id'] = message.data['channel_id'];
//         callInfo['senderName'] = message.data['senderName'];
//         callInfo['senderPicture'] = message.data['senderPicture'];
//         // Navigator.push(context,
//         //     MaterialPageRoute(builder: (context) => Incoming(callInfo)));
//       } else if (Platform.isAndroid && message.data['type'] == 'Call') {
//         print("call by me >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//         // Navigator.push(context,
//         //     MaterialPageRoute(builder: (context) => Incoming(message.data)));
//       } else
//         print("object>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((message) {
//       print('onMessageOpenedApp data: ${message.data}');
//       if (Platform.isIOS && message.data['type'] == 'Call') {
//         Map callInfo = {};
//         callInfo['channel_id'] = message.data['channel_id'];
//         callInfo['senderName'] = message.data['senderName'];
//         callInfo['senderPicture'] = message.data['senderPicture'];
//         bool iscallling = _checkcallState(message.data['channel_id']);
//         print("=================$iscallling");
//         //   if (iscallling) {
//         //     Navigator.push(context,
//         //         MaterialPageRoute(builder: (context) => Incoming(message.data)));
//         //   }
//         // } else if (Platform.isAndroid && message.data['type'] == 'Call') {
//         //   bool iscallling = await _checkcallState(message.data['channel_id']);
//         //   print("=================$iscallling");
//         //   if (iscallling) {
//         //     Navigator.push(context,
//         //         MaterialPageRoute(builder: (context) => Incoming(message.data)));
//         //   } else {
//         //     print("Timeout");
//         //   }
//       }
//     });
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     firebaseMessaging.requestPermission(
//         sound: true, badge: true, alert: true, provisional: true);
//     // if (!isNotEmptyString(getFcmToken())) {
//     firebaseMessaging.getToken().then((String? token) {
//       assert(token != null);
//       showLog("FCM-TOKEN $token");
//       // setFcmToken(token!);
//     });
//     // }
//     //  else {
//     //   showLog("FCM TOKEN ${getFcmToken()}");
//     // }
//   }

//   static showNotification(PushNotificationModel data) async {
//     showLog(data);
//     var android = const AndroidNotificationDetails(
//         'giving_channel_id', 'giving_channel_name',
//         priority: Priority.high, importance: Importance.max);
//     var iOS = const DarwinNotificationDetails();
//     var platform = NotificationDetails(android: android, iOS: iOS);
//     var jsonData = jsonEncode(data);
//     await flutterLocalNotificationsPlugin!
//         .show(123, data.title, data.body, platform, payload: jsonData);
//   }

//   static Future<void> _firebaseMessagingBackgroundHandler(
//       RemoteMessage message) async {
//     await Firebase.initializeApp();
//     showLog('Handling a background message ${message.messageId}');

//     // showSnackBar(title: "Notification", message: "Notification message");
//   }
// }

// class PushNotificationModel {
//   PushNotificationModel({this.title, this.body, this.data});

//   String? title;
//   String? body;
//   PushNotificationData? data;

//   PushNotificationModel.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     body = json['body'];
//     data = json['data'] != null
//         ? PushNotificationData.fromJson(json['data'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['title'] = title;
//     map['body'] = body;
//     if (data != null) {
//       map['data'] = data?.toJson();
//     }
//     return map;
//   }
// }

// class PushNotificationData {
//   PushNotificationData(
//       {this.id,
//       this.title,
//       this.createdat,
//       this.description,
//       this.image,
//       this.url});

//   int? id;
//   String? title;
//   String? description;
//   String? url;
//   String? image;
//   String? createdat;

//   PushNotificationData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     description = json['description'];
//     url = json['url'];
//     image = json['image'];
//     createdat = json['createdat'];
//   }

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = id;
//     map['title'] = title;
//     map['description'] = description;
//     map['url'] = url;
//     map['image'] = image;
//     map['createdat'] = createdat;
//     return map;
//   }
// }

// showLog(dynamic value) {
//   if (kDebugMode) {
//     print(value);
//   }
// }

// _checkcallState(channelId) async {
//   bool iscalling = await FirebaseFirestore.instance
//       .collection("calls")
//       .doc(channelId)
//       .get()
//       .then((value) {
//     return value.data()!["calling"] ?? false;
//   });
//   return iscalling;
// }

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  static initializeService() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onMessage.listen((message) {
      if (flutterLocalNotificationsPlugin == null) {
        var initializationSettingsAndroid =
            const AndroidInitializationSettings('@mipmap/ic_launcher');
        var initializationSettings =
            InitializationSettings(android: initializationSettingsAndroid);
        flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin?.initialize(initializationSettings);
      }

      if (message.notification != null) {
        PushNotificationModel model = PushNotificationModel.fromJson({
          'title': message.notification!.title ?? '',
          'body': message.notification!.body ?? '',
          // 'channel_id': message.data,
          // 'channel_name': message.data,
          // 'senderPicture': message.data,
          // 'senderName': message.data
        });
        // Incoming(message.data);
        showNotification(model);
      } else {
        PushNotificationModel model = PushNotificationModel.fromJson({
          'title': message.data['title'] ?? '',
          'body': message.data['body'] ?? '',
        });
        showNotification(model);
      }

      // if (Platform.isIOS && message.data['type'] == 'Call') {
      //   Incoming(message.data);
      // } else if (Platform.isAndroid && message.data['type'] == 'Call') {
      //   print("call start");
      //   Incoming(message.data);
      // } else {
      //   print("Unhandled notification type");
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      // if ((Platform.isIOS || Platform.isAndroid) &&
      //     message.data['type'] == 'Call') {
      //   bool isCalling = await _checkCallState(message.data['channel_id']);
      //   if (isCalling) {
      //     Incoming(message.data);
      //   } else {
      //     print("Timeout or call state not found");
      //   }
      // }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: true);

    // String? token = await firebaseMessaging.getToken();
    // if (token != null) {
    //   showLog("FCM-TOKEN $token");
    // } else {
    //   print("Failed to get FCM token");
    // }
  }

  static showNotification(PushNotificationModel data) async {
    var android = const AndroidNotificationDetails('channel_id', 'opulentcall',
        priority: Priority.high, importance: Importance.max);
    var iOS = const DarwinNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    var jsonData = jsonEncode(data.toJson()); // Using toJson method here
    await flutterLocalNotificationsPlugin
        ?.show(123, data.title, data.body, platform, payload: jsonData);
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    showLog('Handling a background message ${message.messageId}');
  }
}

class PushNotificationModel {
  String? title;
  String? body;

  PushNotificationModel({this.title, this.body});

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) {
    return PushNotificationModel(
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
    };
  }
}

// ignore: unused_element
Future<bool> _checkCallState(String channelId) async {
  try {
    // Check if the document exists
    var snapshot = await FirebaseFirestore.instance
        .collection("calls")
        .doc(channelId)
        .get();
    if (!snapshot.exists) {
      print("Document does not exist");
      return false;
    }

    // Retrieve the calling status from the document data
    bool isCalling = snapshot.data()?["calling"] ?? false;
    return isCalling;
  } catch (error) {
    // Handle errors
    print("Error checking call state: $error");
    return false;
  }
}

void showLog(dynamic value) {
  if (kDebugMode) {
    print(value);
  }
}
