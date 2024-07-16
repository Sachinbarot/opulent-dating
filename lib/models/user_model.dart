// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/date_time_patterns.dart';

class User {
  final String? id;
  final String? name;
  final String? pushToken;
  final bool? isBlocked;
  String? address;
  final Map? coordinates;
  final List? sexualOrientation;
  final List? personal;
  final double? yourheight;

  final Map? MyInterests;
  final String? gender;
  final String? userGender;
  final String? showGender;
  final String? AboutMe;
  final int? age;
  final String? phoneNumber;
  int? maxDistance;
  Timestamp? lastmsg;
  final Map? ageRange;
  final Map? editInfo;
  List? imageUrl = [];
  var distanceBW;

  User({
    this.id,
    this.age,
    this.address,
    this.isBlocked,
    this.coordinates,
    this.name,
    this.pushToken,
    this.imageUrl,
    this.phoneNumber,
    this.lastmsg,
    this.gender,
    this.userGender,
    this.showGender,
    this.AboutMe,
    this.ageRange,
    this.maxDistance,
    this.editInfo,
    this.distanceBW,
    this.sexualOrientation,
    this.personal,
    this.yourheight,
    this.MyInterests,
  });

  @override
  String toString() {
    return 'User: {id: $id,name:$name,pushToken:$pushToken, isBlocked: $isBlocked, address: $address, coordinates: $coordinates, sexualOrientation: $sexualOrientation,personal:$personal,yourheight:$yourheight,MyInterests:$MyInterests, gender: $gender,userGender:$userGender showGender: $showGender,AboutMe: $AboutMe, age: $age, phoneNumber: $phoneNumber, maxDistance: $maxDistance, lastmsg: $lastmsg, ageRange: $ageRange, editInfo: $editInfo, distanceBW : $distanceBW }';
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    // DateTime date = DateTime.parse(doc["user_DOB"]);
    return User(
      id: doc.data().toString().contains('userId') ? doc.get('userId') : '0',
      // id: doc.get('userId')! ?? "",
      isBlocked: doc.data().toString().contains('isBlocked')
          ? doc.get('isBlocked')
          : false,
      // isBlocked: doc.get('isBlocked')! ?? "false",
      // doc.get('isBlocked') : false,
      phoneNumber: doc.data().toString().contains('phoneNumber')
          ? doc.get('phoneNumber')
          : '',

      //   phoneNumber: doc.get('phoneNumber')! ?? "",
      name:
          doc.data().toString().contains('UserName') ? doc.get('UserName') : '',

      pushToken: doc.data().toString().contains('pushToken')
          ? doc.get('pushToken')
          : '',

      // name: doc.get('UserName') ?? "",\\\
      editInfo: doc.data().toString().contains('editInfo')
          ? doc.get('editInfo')
          : [], //List<dynamic>

      // editInfo: doc.get('editInfo'),
      ageRange: doc.data().toString().contains('age_range')
          ? doc.get('age_range')
          : [], //List<dynamic>

      //   ageRange: doc.get('age_range'),
      showGender: doc.data().toString().contains('showGender')
          ? doc.get('showGender')
          : [], //List<dynamic>

      AboutMe:
          doc.data().toString().contains('AboutMe') ? doc.get('AboutMe') : '',

      userGender: doc.data().toString().contains('userGender')
          ? doc.get('userGender')
          : '',

      //   showGender: doc.get('showGender') ?? "",
      maxDistance: doc.data().toString().contains('maximum_distance')
          ? doc.get('maximum_distance')
          : 0, //Number

      //  maxDistance: doc.get('maximum_distance'),
      sexualOrientation: doc.data().toString().contains('sexualOrientation')
          ? doc.get('sexualOrientation')['orientation']
          : [], //List<dynamic>

      // sexualOrientation: doc.get('sexualOrientation')['orientation'] ?? "",
      //  age: doc.data().toString().contains('amount') ? doc.get('amount') : 0,//Number

      age: ((DateTime.now()
                  .difference(DateTime.parse(doc.get('user_DOB')))
                  .inDays) /
              365.2425)
          .truncate(),
      address: doc.data().toString().contains('location')
          ? doc.get('location')['address']
          : '',

      //  address: doc.get('location')['address'],
      coordinates:
          doc.data().toString().contains('location') ? doc.get('location') : [],
      //   coordinates: doc.get('location'),
      // university: doc['editInfo']['university'],
      imageUrl: doc.get('Pictures') != null
          ? List.generate(doc.get('Pictures').length, (index) {
              return doc.get('Pictures')[index];
            })
          : [],
      personal: doc.data().toString().contains('personal')
          ? doc.get('personal')['selectedTexts']
          : [],

      yourheight: doc.data().toString().contains('yourheight')
          ? doc.get('yourheight')
          : '',

      // MyInterests: doc.data().toString().contains('MyInterests') &&
      //         doc.get('MyInterests') != null
      //     ? List<dynamic>.from(doc.get('MyInterests')['data'] ?? [])
      //     : [],

      MyInterests: doc.data().toString().contains('MyInterests')
          ? doc.get('MyInterests')['data']
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return dateTimePatternMap();
  }
}
