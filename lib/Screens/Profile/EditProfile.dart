// ignore_for_file: depend_on_referenced_packages, file_names, prefer_typing_uninitialized_variables, avoid_print, prefer_is_empty, no_leading_underscores_for_local_identifiers, await_only_futures

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/Screens/Profile/intrestedscreen.dart';
import 'package:hookup4u/Screens/commanbtn/commanbutton.dart';
import 'package:hookup4u/Screens/seach_location.dart';
import 'package:image/image.dart' as i;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/models/user_model.dart';
import 'package:hookup4u/util/color.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

class EditProfile extends StatefulWidget {
  final User currentUser;
  EditProfile(this.currentUser);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final TextEditingController aboutCtlr = TextEditingController();
  final TextEditingController companyCtlr = TextEditingController();
  final TextEditingController livingCtlr = TextEditingController();
  final TextEditingController jobCtlr = TextEditingController();
  final TextEditingController universityCtlr = TextEditingController();
  final TextEditingController myintersted = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController dobctlr = TextEditingController();
  final TextEditingController yourheight = TextEditingController();
  final TextEditingController heightcontroller = TextEditingController();
  Map<String, dynamic> changeValues = {};

  double convertToInch(double cm) {
    return cm / 2.54;
  }

  bool visibleAge = false;
  bool visibleDistance = true;
  var showMe;
  Map editInfo = {};
  Map testMap = {'edit': 'thanks'};
  DateTime? selecteddate;

  String selectedWeight = 'Weight';

  String selectedGender = '';
  String selectedLocation = '';
  String selectedCity = '';
  String selectedlanguages = '';
  final List<String> religion = [];
  final List<String> cities = ['Gujrat', 'Indore', 'Delhi'];
  final List<String> languages = ['Hindi', 'English', 'Marathi'];

  double _currentHeight = 160.00;

  _showHeightDialog(BuildContext context, Function(double) onHeightSelected) {
    double _currentHeight = widget.currentUser.yourheight!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double inches = convertToInch(_currentHeight);
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                'Height: ${_currentHeight.toStringAsFixed(0)} cm (${inches.toStringAsFixed(2)} inc)',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    thumbColor: Colors.blue,
                    activeColor: Colors.blue,
                    value: _currentHeight,
                    min: 100.0,
                    max: 250.0,
                    divisions: 150,
                    onChanged: (double value) {
                      setState(() {
                        _currentHeight = value;
                        // editInfo.addAll({'yourheight': _currentHeight});
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onHeightSelected(_currentHeight);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String selectedgender = '';
  void _openGenderDialog(BuildContext context) {
    List<String> genderOptions = ['man', 'woman', 'other'];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Select Gender",
            style: TextStyle(
              fontFamily: AppStrings.fontname,
              fontWeight: FontWeight.w600,
              color: Colors.pink,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int index = 0; index < genderOptions.length; index++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedgender = genderOptions[index];
                        editInfo.addAll({'userGender': selectedgender});
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0x0061D5FF),
                            Color(0xFF61D5FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          genderOptions[index],
                          style: const TextStyle(
                            fontFamily: AppStrings.fontname,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void _openLocationsDialog(BuildContext context) {
  //   List<String> genderOptions = ['India', 'Foren', 'Other'];

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text(
  //           "Select Location",
  //           style: TextStyle(
  //             fontFamily: AppStrings.fontname,
  //             fontWeight: FontWeight.w600,
  //             color: Colors.pink,
  //           ),
  //         ),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               for (String gender in genderOptions)
  //                 GestureDetector(
  //                   onTap: () {
  //                     setState(() {
  //                       selectedGender = gender;
  //                     });
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Container(
  //                     margin: const EdgeInsets.all(10),
  //                     height: 40,
  //                     decoration: BoxDecoration(
  //                       gradient: const LinearGradient(
  //                         begin: Alignment.topRight,
  //                         end: Alignment.bottomLeft,
  //                         colors: [
  //                           Color(0x0061D5FF),
  //                           Color(0xFF61D5FF),
  //                         ],
  //                       ),
  //                       borderRadius: BorderRadius.circular(20),
  //                     ),
  //                     child: Center(
  //                       child: Text(
  //                         gender,
  //                         style: const TextStyle(
  //                           fontFamily: AppStrings.fontname,
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  String selectedLanguage = '';

  void _openLocationsLanguage(BuildContext context) {
    List<String> languageOptions = ['Hindi', 'English', 'Other'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Select Language",
            style: TextStyle(
              fontFamily: AppStrings.fontname,
              fontWeight: FontWeight.w600,
              color: Colors.pink,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int index = 0; index < languageOptions.length; index++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedLanguage = languageOptions[index];
                        editInfo.addAll({'language': selectedLanguage});
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0x0061D5FF),
                            Color(0xFF61D5FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          languageOptions[index],
                          style: const TextStyle(
                            fontFamily: AppStrings.fontname,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String selectedReasons = '';
  void _openLocationsReligion(BuildContext context) {
    List<String> genderOptions = ['Hindu', 'Momedian', 'Other'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Select Religion",
            style: TextStyle(
              fontFamily: AppStrings.fontname,
              fontWeight: FontWeight.w600,
              color: Colors.pink,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int index = 0; index < genderOptions.length; index++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedReasons = genderOptions[index];
                        editInfo.addAll({'Reasons': selectedReasons});
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color(0x0061D5FF),
                            Color(0xFF61D5FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          genderOptions[index],
                          style: const TextStyle(
                            fontFamily: AppStrings.fontname,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    initializeDateFormatting('en_US', null);
    super.initState();
    print('---------------------${widget.currentUser.phoneNumber}');
    aboutCtlr.text = widget.currentUser.editInfo!['AboutMe'] ?? '';
    companyCtlr.text = widget.currentUser.editInfo!['company'] ?? '';
    livingCtlr.text = widget.currentUser.editInfo!['living_in'] ?? '';
    myintersted.text = widget.currentUser.editInfo!['MyInterests'] ?? '';
    // universityCtlr.text = widget.currentUser.editInfo!['university'] ?? '';
    jobCtlr.text = widget.currentUser.editInfo!['job_title'] ?? '';
    username.text = widget.currentUser.editInfo!['UserName'] ?? '';
    dobctlr.text = widget.currentUser.editInfo!['age'] ?? '';
    //heightcontroller.text = widget.currentUser.editInfo!['yourheight'] ?? '';

    setState(() {
      showMe = widget.currentUser.editInfo!['userGender'] ?? '';
      visibleAge = widget.currentUser.editInfo!['showMyAge'] ?? false;
      visibleDistance = widget.currentUser.editInfo!['DistanceVisible'] ?? true;
    });
    super.initState();
    print(showMe);
  }

  @override
  void dispose() {
    super.dispose();
    print('-------------------------${editInfo.length}');
    if (editInfo.length > 0) {
      updateData();
    }
    if (changeValues.length > 0) {
      updateData();
    }
    // _ads.disable(_ad);
  }

  Future updateData() async {
    print('---------------------${widget.currentUser.id}');
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.currentUser.id)
        .set({
      'editInfo': editInfo,
      'age': widget.currentUser.age,
      'UserName': widget.currentUser.name,
      'yourheight': widget.currentUser.yourheight,
      'Language': widget.currentUser.personal![1],
      'Reasons': widget.currentUser.personal![9],
    }, SetOptions(merge: true));
  }

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future source(
      BuildContext context, currentUser, bool isProfilePicture) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text(
                  isProfilePicture ? "Update Profile Picture" : "Add Pictures",
                  style: TextStyle(
                      fontFamily: AppStrings.fontname,
                      color: black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              content: Text("Select Source",
                  style: TextStyle(
                      fontFamily: AppStrings.fontname,
                      color: black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400)),
              insetAnimationCurve: Curves.decelerate,
              actions: currentUser.imageUrl.length < 9
                  ? <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_camera,
                                size: 28,
                              ),
                              Text(
                                " Camera",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: AppStrings.fontname,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  getImage(ImageSource.camera, context,
                                      currentUser, isProfilePicture);
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ));
                                });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_library,
                                size: 28,
                              ),
                              Text(
                                " Gallery",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontFamily: AppStrings.fontname,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  getImage(ImageSource.gallery, context,
                                      currentUser, isProfilePicture);
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ));
                                });
                          },
                        ),
                      ),
                    ]
                  : [
                      const Padding(
                        padding: EdgeInsets.all(25.0),
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Icon(Icons.error),
                            Text(
                              "Can't uplaod more than 9 pictures",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        )),
                      )
                    ]);
        });
  }

  Future getImage(
      ImageSource imageSource, context, currentUser, isProfilePicture) async {
    ImagePicker imagePicker = ImagePicker();
    try {
      var image = await imagePicker.pickImage(source: imageSource);
      if (image != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop',
                toolbarColor: backcolor,
                toolbarWidgetColor: Colors.red,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              title: 'Crop',
            )
          ],
        );

        if (croppedFile != null) {
          await uploadFile(
              await compressimage(croppedFile), currentUser, isProfilePicture);
        }
      }

      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future uploadFile(File image, User currentUser, isProfilePicture) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('users/${currentUser.id}/${image.hashCode}.jpg');
    UploadTask uploadTask = storageReference.putFile(image);
    //if (uploadTask.isInProgress == true) {}
    //if (await uploadTask.onComplete != null) {
    await uploadTask.whenComplete(() {
      storageReference.getDownloadURL().then((fileURL) async {
        Map<String, dynamic> updateObject = {
          "Pictures": FieldValue.arrayUnion([
            fileURL,
          ])
        };
        try {
          if (isProfilePicture) {
            //currentUser.imageUrl.removeAt(0);
            currentUser.imageUrl!.insert(0, fileURL);
            print("object");
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.id)
                .set({"Pictures": currentUser.imageUrl},
                    SetOptions(merge: true));
          } else {
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.id)
                .set(updateObject, SetOptions(merge: true));
            widget.currentUser.imageUrl!.add(fileURL);
          }
          if (mounted) setState(() {});
        } catch (err) {
          print("Error: $err");
        }
      });
    });
  }

  Future compressimage(CroppedFile image) async {
    final File croppedToFileImage = File(image.path);
    final tempdir = await getTemporaryDirectory();
    final path = tempdir.path;
    i.Image? imagefile = i.decodeImage(croppedToFileImage.readAsBytesSync());
    final compressedImagefile = File('$path.jpg')
      ..writeAsBytesSync(i.encodeJpg(imagefile!, quality: 80));
    // setState(() {
    return compressedImagefile;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: commonAppBar(context, 'Edit Profile '),
      body: Scaffold(
        backgroundColor: backcolor,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * .45,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: backcolor),
                  borderRadius: BorderRadius.circular(20),
                  color: btncolor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.58,
                          height: MediaQuery.of(context).size.width * 0.61,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: white,
                            surfaceTintColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: widget
                                            .currentUser.imageUrl!.length >
                                        0
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            style: BorderStyle.solid,
                                            width: 3,
                                            color: black.withOpacity(0.2))),
                                child: Stack(
                                  children: <Widget>[
                                    widget.currentUser.imageUrl!.length > 0
                                        ? CachedNetworkImage(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .4,
                                            fit: BoxFit.cover,
                                            imageUrl: widget
                                                    .currentUser.imageUrl![0] ??
                                                '',
                                            placeholder: (context, url) =>
                                                const Center(
                                              child: CupertinoActivityIndicator(
                                                radius: 10,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.error,
                                                    color: Colors.black,
                                                    size: 25,
                                                  ),
                                                  Text(
                                                    "Enable to load",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                source(context,
                                                    widget.currentUser, false);
                                              },
                                              child: Image.asset(
                                                'asset/addprofile.png',
                                                height: 29,
                                                width: 29,
                                              ),
                                            ),
                                          ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: widget.currentUser.imageUrl!
                                                        .length >
                                                    0
                                                ? Colors.white
                                                : primaryColor,
                                          ),
                                          child: widget.currentUser.imageUrl!
                                                      .length >
                                                  0
                                              ? InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  child: const Icon(
                                                    Icons.cancel,
                                                    color: Colors.red,
                                                    size: 22,
                                                  ),
                                                  onTap: () async {
                                                    if (widget.currentUser
                                                            .imageUrl!.length >
                                                        0) {
                                                      _deletePicture(0);
                                                    } else {
                                                      source(
                                                          context,
                                                          widget.currentUser,
                                                          true);
                                                    }
                                                  },
                                                )
                                              : const Text('')),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        //const SizedBox(width: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.288,
                              height: MediaQuery.of(context).size.width * 0.30,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: white,
                                surfaceTintColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: widget
                                                .currentUser.imageUrl!.length >
                                            1
                                        ? BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )
                                        : BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                style: BorderStyle.solid,
                                                width: 3,
                                                color: black.withOpacity(0.2))),
                                    child: Stack(
                                      children: <Widget>[
                                        widget.currentUser.imageUrl!.length > 1
                                            ? CachedNetworkImage(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .4,
                                                fit: BoxFit.cover,
                                                imageUrl: widget.currentUser
                                                        .imageUrl![1] ??
                                                    '',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                    radius: 10,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.error,
                                                        color: Colors.black,
                                                        size: 25,
                                                      ),
                                                      Text(
                                                        "Enable to load",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Center(
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    source(
                                                        context,
                                                        widget.currentUser,
                                                        false);
                                                  },
                                                  child: Image.asset(
                                                    'asset/addprofile.png',
                                                    height: 29,
                                                    width: 29,
                                                  ),
                                                ),
                                              ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: widget.currentUser
                                                            .imageUrl!.length >
                                                        1
                                                    ? Colors.white
                                                    : primaryColor,
                                              ),
                                              child: widget.currentUser
                                                          .imageUrl!.length >
                                                      1
                                                  ? InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      child: const Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                        size: 22,
                                                      ),
                                                      onTap: () async {
                                                        if (widget
                                                                .currentUser
                                                                .imageUrl!
                                                                .length >
                                                            1) {
                                                          _deletePicture(1);
                                                        } else {
                                                          source(
                                                              context,
                                                              widget
                                                                  .currentUser,
                                                              true);
                                                        }
                                                      },
                                                    )
                                                  : const Text('')),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.288,
                              height: MediaQuery.of(context).size.width * 0.30,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: white,
                                surfaceTintColor: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    decoration: widget
                                                .currentUser.imageUrl!.length >
                                            2
                                        ? BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )
                                        : BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                style: BorderStyle.solid,
                                                width: 3,
                                                color: black.withOpacity(0.2))),
                                    child: Stack(
                                      children: <Widget>[
                                        widget.currentUser.imageUrl!.length > 2
                                            ? CachedNetworkImage(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .4,
                                                fit: BoxFit.cover,
                                                imageUrl: widget.currentUser
                                                        .imageUrl![2] ??
                                                    '',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                    radius: 10,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.error,
                                                        color: Colors.black,
                                                        size: 25,
                                                      ),
                                                      Text(
                                                        "Enable to load",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Center(
                                                child: InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () {
                                                    source(
                                                        context,
                                                        widget.currentUser,
                                                        false);
                                                  },
                                                  child: Image.asset(
                                                    'asset/addprofile.png',
                                                    height: 29,
                                                    width: 29,
                                                  ),
                                                ),
                                              ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: widget.currentUser
                                                            .imageUrl!.length >
                                                        2
                                                    ? Colors.white
                                                    : primaryColor,
                                              ),
                                              child: widget.currentUser
                                                          .imageUrl!.length >
                                                      2
                                                  ? InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      child: const Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                        size: 22,
                                                      ),
                                                      onTap: () async {
                                                        if (widget
                                                                .currentUser
                                                                .imageUrl!
                                                                .length >
                                                            2) {
                                                          _deletePicture(2);
                                                        } else {
                                                          source(
                                                              context,
                                                              widget
                                                                  .currentUser,
                                                              true);
                                                        }
                                                      },
                                                    )
                                                  : const Text('')),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.288,
                            height: MediaQuery.of(context).size.width * 0.30,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: white,
                              surfaceTintColor: Colors.white,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration:
                                      widget.currentUser.imageUrl!.length > 3
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )
                                          : BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  style: BorderStyle.solid,
                                                  width: 3,
                                                  color:
                                                      black.withOpacity(0.2))),
                                  child: Stack(
                                    children: <Widget>[
                                      widget.currentUser.imageUrl!.length > 3
                                          ? CachedNetworkImage(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .4,
                                              fit: BoxFit.cover,
                                              imageUrl: widget.currentUser
                                                      .imageUrl![3] ??
                                                  '',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                  radius: 10,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.error,
                                                      color: Colors.black,
                                                      size: 25,
                                                    ),
                                                    Text(
                                                      "Enable to load",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  source(
                                                      context,
                                                      widget.currentUser,
                                                      false);
                                                },
                                                child: Image.asset(
                                                  'asset/addprofile.png',
                                                  height: 29,
                                                  width: 29,
                                                ),
                                              ),
                                            ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: widget.currentUser
                                                          .imageUrl!.length >
                                                      3
                                                  ? Colors.white
                                                  : primaryColor,
                                            ),
                                            child: widget.currentUser.imageUrl!
                                                        .length >
                                                    3
                                                ? InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                      size: 22,
                                                    ),
                                                    onTap: () async {
                                                      if (widget
                                                              .currentUser
                                                              .imageUrl!
                                                              .length >
                                                          3) {
                                                        _deletePicture(3);
                                                      } else {
                                                        source(
                                                            context,
                                                            widget.currentUser,
                                                            true);
                                                      }
                                                    },
                                                  )
                                                : const Text('')),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(width: 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.288,
                            height: MediaQuery.of(context).size.width * 0.30,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: white,
                              surfaceTintColor: Colors.white,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration:
                                      widget.currentUser.imageUrl!.length > 4
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )
                                          : BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  style: BorderStyle.solid,
                                                  width: 3,
                                                  color:
                                                      black.withOpacity(0.2))),
                                  child: Stack(
                                    children: <Widget>[
                                      widget.currentUser.imageUrl!.length > 4
                                          ? CachedNetworkImage(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .4,
                                              fit: BoxFit.cover,
                                              imageUrl: widget.currentUser
                                                      .imageUrl![4] ??
                                                  '',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                  radius: 10,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.error,
                                                      color: Colors.black,
                                                      size: 25,
                                                    ),
                                                    Text(
                                                      "Enable to load",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  source(
                                                      context,
                                                      widget.currentUser,
                                                      false);
                                                },
                                                child: Image.asset(
                                                  'asset/addprofile.png',
                                                  height: 29,
                                                  width: 29,
                                                ),
                                              ),
                                            ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: widget.currentUser
                                                          .imageUrl!.length >
                                                      4
                                                  ? Colors.white
                                                  : primaryColor,
                                            ),
                                            child: widget.currentUser.imageUrl!
                                                        .length >
                                                    4
                                                ? InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                      size: 22,
                                                    ),
                                                    onTap: () async {
                                                      if (widget
                                                              .currentUser
                                                              .imageUrl!
                                                              .length >
                                                          4) {
                                                        _deletePicture(4);
                                                      } else {
                                                        source(
                                                            context,
                                                            widget.currentUser,
                                                            true);
                                                      }
                                                    },
                                                  )
                                                : const Text('')),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(width: 5),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.288,
                            height: MediaQuery.of(context).size.width * 0.30,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: white,
                              surfaceTintColor: Colors.white,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  decoration:
                                      widget.currentUser.imageUrl!.length > 5
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )
                                          : BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  style: BorderStyle.solid,
                                                  width: 3,
                                                  color:
                                                      black.withOpacity(0.2))),
                                  child: Stack(
                                    children: <Widget>[
                                      widget.currentUser.imageUrl!.length > 5
                                          ? CachedNetworkImage(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .4,
                                              fit: BoxFit.cover,
                                              imageUrl: widget.currentUser
                                                      .imageUrl![5] ??
                                                  '',
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                  radius: 10,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.error,
                                                      color: Colors.black,
                                                      size: 25,
                                                    ),
                                                    Text(
                                                      "Enable to load",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: InkWell(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () {
                                                  source(
                                                      context,
                                                      widget.currentUser,
                                                      false);
                                                },
                                                child: Image.asset(
                                                  'asset/addprofile.png',
                                                  height: 29,
                                                  width: 29,
                                                ),
                                              ),
                                            ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: widget.currentUser
                                                          .imageUrl!.length >
                                                      5
                                                  ? Colors.white
                                                  : primaryColor,
                                            ),
                                            child: widget.currentUser.imageUrl!
                                                        .length >
                                                    5
                                                ? InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    child: const Icon(
                                                      Icons.cancel,
                                                      color: Colors.red,
                                                      size: 22,
                                                    ),
                                                    onTap: () async {
                                                      if (widget
                                                              .currentUser
                                                              .imageUrl!
                                                              .length >
                                                          5) {
                                                        _deletePicture(5);
                                                      } else {
                                                        source(
                                                            context,
                                                            widget.currentUser,
                                                            true);
                                                      }
                                                    },
                                                  )
                                                : const Text('')),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Container(
              //   alignment: Alignment.center,
              //   height: MediaQuery.of(context).size.height * .45,
              //   width: MediaQuery.of(context).size.width,
              //   child: GridView.count(
              //       physics: const NeverScrollableScrollPhysics(),
              //       crossAxisCount: 3,
              //       childAspectRatio:
              //           MediaQuery.of(context).size.aspectRatio * 1.5,
              //       crossAxisSpacing: 4,
              //       padding: const EdgeInsets.only(left: 20, right: 20),
              //       children: List.generate(6, (index) {
              //         return Card(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10),
              //           ),
              //           color: btncolor,
              //           child: ClipRRect(
              //             borderRadius: BorderRadius.circular(10),
              //             child: Container(
              //               decoration:
              //                   widget.currentUser.imageUrl!.length > index
              //                       ? BoxDecoration(
              //                           borderRadius: BorderRadius.circular(10),
              //                         )
              //                       : BoxDecoration(
              //                           borderRadius: BorderRadius.circular(10),
              //                           border: Border.all(
              //                               style: BorderStyle.solid,
              //                               width: 1,
              //                               color: secondryColor)),
              //               child: Stack(
              //                 children: <Widget>[
              //                   widget.currentUser.imageUrl!.length > index
              //                       ? CachedNetworkImage(
              //                           height:
              //                               MediaQuery.of(context).size.height *
              //                                   .2,
              //                           fit: BoxFit.cover,
              //                           imageUrl: widget
              //                                   .currentUser.imageUrl![index] ??
              //                               '',
              //                           placeholder: (context, url) =>
              //                               const Center(
              //                             child: CupertinoActivityIndicator(
              //                               radius: 10,
              //                             ),
              //                           ),
              //                           errorWidget: (context, url, error) =>
              //                               const Center(
              //                             child: Column(
              //                               mainAxisAlignment:
              //                                   MainAxisAlignment.center,
              //                               children: <Widget>[
              //                                 Icon(
              //                                   Icons.error,
              //                                   color: Colors.black,
              //                                   size: 25,
              //                                 ),
              //                                 Text(
              //                                   "Enable to load",
              //                                   style: TextStyle(
              //                                     color: Colors.black,
              //                                   ),
              //                                 )
              //                               ],
              //                             ),
              //                           ),
              //                         )
              //                       : Container(),
              //                   Align(
              //                     alignment: Alignment.bottomRight,
              //                     child: Container(
              //                         decoration: BoxDecoration(
              //                           shape: BoxShape.circle,
              //                           color: widget.currentUser.imageUrl!
              //                                       .length >
              //                                   index
              //                               ? Colors.white
              //                               : primaryColor,
              //                         ),
              //                         child: widget.currentUser.imageUrl!
              //                                     .length >
              //                                 index
              //                             ? InkWell(
              //                                 splashColor: Colors.transparent,
              //                                 highlightColor:
              //                                     Colors.transparent,
              //                                 child: Icon(
              //                                   Icons.cancel,
              //                                   color: primaryColor,
              //                                   size: 22,
              //                                 ),
              //                                 onTap: () async {
              //                                   if (widget.currentUser.imageUrl!
              //                                           .length >
              //                                       1) {
              //                                     _deletePicture(index);
              //                                   } else {
              //                                     source(context,
              //                                         widget.currentUser, true);
              //                                   }
              //                                 },
              //                               )
              //                             : InkWell(
              //                                 splashColor: Colors.transparent,
              //                                 highlightColor:
              //                                     Colors.transparent,
              //                                 child: const Icon(
              //                                   Icons.add_circle_outline,
              //                                   size: 22,
              //                                   color: Colors.white,
              //                                 ),
              //                                 onTap: () => source(context,
              //                                     widget.currentUser, false),
              //                               )),
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //       })),
              // ),

              // InkWell(
              //   child: commanbtn(12.0, 'Add media'),
              //   onTap: () async {
              //     await source(context, widget.currentUser, false);
              //   },
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nickname',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppStrings.fontname,
                                  color: lightgrey,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(color: Colors.white),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: TextFormField(
                                  controller: username,
                                  style: const TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintText:
                                        widget.currentUser.name.toString(),
                                    border: InputBorder.none,
                                    helperStyle: TextStyle(
                                      color: black.withOpacity(0.5),
                                      fontSize: 16,
                                      fontFamily: AppStrings.fontname,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 20),
                                  ),
                                  onChanged: (text) {
                                    setState(() {
                                      editInfo.addAll({'UserName': text});
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Birthday',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppStrings.fontname,
                                  color: lightgrey,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 61,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(color: Colors.white),
                              ),
                              child: CupertinoTextField(
                                controller: dobctlr,
                                decoration: BoxDecoration(
                                    border: Border.all(color: white),
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: white),
                                readOnly: true,
                                keyboardType: TextInputType.phone,
                                onChanged: (text) {
                                  setState(() {
                                    editInfo.addAll({'age': text});
                                  });
                                },
                                suffix: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'asset/calenderimg.png',
                                    height: 19,
                                    width: 19,
                                  ),
                                ),
                                onTap: () => showCupertinoModalPopup(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .25,
                                          child: GestureDetector(
                                            child: CupertinoDatePicker(
                                              backgroundColor: Colors.white,
                                              initialDateTime:
                                                  DateTime(2000, 10, 12),
                                              onDateTimeChanged:
                                                  (DateTime newdate) {
                                                setState(() {
                                                  dobctlr.text =
                                                      '${newdate.day}/${newdate.month}/${newdate.year}';
                                                  selecteddate = newdate;
                                                });
                                              },
                                              maximumYear: 2015,
                                              minimumYear: 1800,
                                              maximumDate:
                                                  DateTime(2015, 31, 12),
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                            ),
                                            onTap: () {
                                              print(dobctlr.text);
                                              Navigator.pop(context);
                                            },
                                          ));
                                    }),
                                placeholder: widget.currentUser.age.toString(),
                              ),
                            ),

                            // InkWell(
                            //   splashColor: Colors.transparent,
                            //   highlightColor: Colors.transparent,
                            //   onTap: () {
                            //     //_selectDate(context);

                            //     showCupertinoModalPopup(
                            //         context: context,
                            //         builder: (BuildContext context) {
                            //           return SizedBox(
                            //               height: MediaQuery.of(context)
                            //                       .size
                            //                       .height *
                            //                   .25,
                            //               child: GestureDetector(
                            //                 child: CupertinoDatePicker(
                            //                   backgroundColor: Colors.white,
                            //                   initialDateTime:
                            //                       DateTime(2000, 10, 12),
                            //                   onDateTimeChanged:
                            //                       (DateTime newdate) {
                            //                     setState(() {
                            //                       dobctlr.text =
                            //                           '${newdate.day}/${newdate.month}/${newdate.year}';
                            //                       selecteddate = newdate;
                            //                     });
                            //                   },
                            //                   maximumYear: 2015,
                            //                   minimumYear: 1800,
                            //                   maximumDate:
                            //                       DateTime(2015, 31, 12),
                            //                   mode:
                            //                       CupertinoDatePickerMode.date,
                            //                 ),
                            //                 onTap: () {
                            //                   print(dobctlr.text);
                            //                   Navigator.pop(context);
                            //                 },
                            //               ));
                            //         });
                            //   },
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(12.0),
                            //       border: Border.all(color: Colors.white),
                            //     ),
                            //     child: Row(
                            //       children: [
                            //         Expanded(
                            //           child: Container(
                            //             decoration: BoxDecoration(
                            //               color: white,
                            //               borderRadius: BorderRadius.circular(
                            //                 12.0,
                            //               ),
                            //               border:
                            //                   Border.all(color: Colors.white),
                            //             ),
                            //             padding: const EdgeInsets.symmetric(
                            //                 vertical: 16, horizontal: 20),
                            //             child: Row(
                            //               children: [
                            //                 Expanded(
                            //                   child: Text(
                            //                     selectedDate != null
                            //                         ? DateFormat.yMMMd()
                            //                             .format(selectedDate!)
                            //                         : widget.currentUser.age
                            //                             .toString(),
                            //                     style: const TextStyle(
                            //                         fontSize: 16),
                            //                   ),
                            //                 ),
                            //                 Image.asset(
                            //                   'asset/calenderimg.png',
                            //                   height: 19,
                            //                   width: 19,
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Height',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppStrings.fontname,
                                  color: lightgrey,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${widget.currentUser.editInfo != null && widget.currentUser.editInfo!['yourheight'] != null ? widget.currentUser.editInfo!['yourheight'] : widget.currentUser.yourheight}",

                                        // 'Height: ${_currentHeight.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          _showHeightDialog(context,
                                              (double selectedHeight) {
                                            setState(() {
                                              _currentHeight = selectedHeight;
                                              editInfo.addAll({
                                                'yourheight': selectedHeight
                                              });
                                            });
                                          });
                                        },
                                        child: const Icon(
                                            Icons.keyboard_arrow_down)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weight',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppStrings.fontname,
                                  color: lightgrey,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: white,
                                border: Border.all(color: Colors.white),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      value: selectedWeight,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      padding: const EdgeInsets.only(left: 5),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 16),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.transparent,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedWeight = newValue!;
                                        });
                                      },
                                      items: <String>[
                                        'Weight',
                                        'Under 50 kg',
                                        'Under 60 kg',
                                        'Under 70 kg',
                                        'Under 80 kg',
                                        'Under 90 kg',
                                        'Under 100 kg'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
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
              ),

              Container(
                color: backcolor,
                padding: const EdgeInsets.all(8.0),
                child: ListBody(
                  mainAxis: Axis.vertical,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "About Me",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            fontFamily: AppStrings.fontname,
                            color: lightgrey),
                      ).tr(args: ['${widget.currentUser.name}']),
                      subtitle: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6)),
                        child: CupertinoTextField(
                          controller: aboutCtlr,
                          cursorColor: primaryColor,
                          maxLines: 10,
                          minLines: 5,
                          placeholder: widget.currentUser.AboutMe.toString(),
                          padding: const EdgeInsets.all(10),
                          onChanged: (text) {
                            editInfo.addAll({'AboutMe': text});
                          },
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Gender",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: AppStrings.fontname,
                          color: lightgrey,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(6)),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text(widget.currentUser.userGender! ?? ''),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      _openGenderDialog(context);
                                    },
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Location",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: AppStrings.fontname,
                          color: lightgrey,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(6)),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text(
                                    widget.currentUser.address.toString(),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      // _openLocationsDialog(context);
                                      Map<String, dynamic> userData =
                                          (widget.currentUser as User).toMap();
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  SearchLocation(
                                                    userData,
                                                  )));
                                    },
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "My Interests",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          fontFamily: AppStrings.fontname,
                          color: lightgrey,
                        ),
                      ),
                      subtitle: Container(
                        height: 200,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Interests",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          fontFamily: AppStrings.fontname,
                                          color: black.withOpacity(0.6),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        MyInterests(
                                                          userData: widget
                                                              .currentUser
                                                              .toMap(),
                                                        )));
                                          },
                                          child: const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 145,
                                    child: ListView(
                                      children: List.generate(
                                        (widget.currentUser.MyInterests!
                                                    .length /
                                                3)
                                            .ceil(),
                                        (rowIndex) {
                                          int startIndex = rowIndex * 3;
                                          int endIndex = startIndex + 3;
                                          if (endIndex >
                                              widget.currentUser.MyInterests!
                                                  .length) {
                                            endIndex = widget.currentUser
                                                .MyInterests!.length;
                                          }
                                          return Row(
                                            children: List.generate(
                                              endIndex - startIndex,
                                              (index) {
                                                String name = widget.currentUser
                                                    .MyInterests!.keys
                                                    .elementAt(
                                                        startIndex + index);
                                                String? imagePath = widget
                                                    .currentUser
                                                    .MyInterests![name];
                                                return _buildInterestContainer(
                                                    name, imagePath!);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ListTile(
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(6)),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text(
                                    selectedLanguage.isNotEmpty
                                        ? selectedLanguage
                                        : (widget.currentUser.editInfo !=
                                                    null &&
                                                widget.currentUser.editInfo![
                                                        'Language'] !=
                                                    null
                                            ? widget.currentUser
                                                .editInfo!['Language']
                                            : widget.currentUser.personal![1]),

                                    //"${widget.currentUser.editInfo != null && widget.currentUser.editInfo!['selectedTexts'] != null ? widget.currentUser.editInfo!['selectedTexts'] : widget.currentUser.personal![1]}",

                                    style: TextStyle(
                                        fontFamily: AppStrings.fontname,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: black.withOpacity(0.6)),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      _openLocationsLanguage(context);
                                    },
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ListTile(
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 55,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(6)),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text(
                                    selectedReasons.isNotEmpty
                                        ? selectedReasons
                                        : (widget.currentUser.editInfo !=
                                                    null &&
                                                widget.currentUser
                                                        .editInfo!['Reasons'] !=
                                                    null
                                            ? widget.currentUser
                                                .editInfo!['Reasons']
                                            : widget.currentUser.personal![9]),
                                    style: TextStyle(
                                        fontFamily: AppStrings.fontname,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: black.withOpacity(0.6)),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      _openLocationsReligion(context);
                                    },
                                    child: const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 38,
                            width: 112,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text(
                              'Cancel',
                              style: TextStyle(
                                  fontFamily: AppStrings.fontname,
                                  fontWeight: FontWeight.w700,
                                  color: black,
                                  fontSize: 16),
                            )),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            // editInfo.addAll({
                            //   'selectedTexts': widget.currentUser.personal,

                            // });
                            updateData();
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 38,
                            width: 112,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Color(0xFF61D5FF),
                                    Color(0x0061D5FF),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text(
                              'Apply',
                              style: TextStyle(
                                  fontFamily: AppStrings.fontname,
                                  fontWeight: FontWeight.w700,
                                  color: black,
                                  fontSize: 16),
                            )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // ListTile(
                    //   title: Text(
                    //     "Company",
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.w600,
                    //         fontSize: 16,
                    //         fontFamily: AppStrings.fontname,
                    //         color: newtextcolor),
                    //   ),
                    //   subtitle: CupertinoTextField(
                    //     controller: companyCtlr,
                    //     cursorColor: primaryColor,
                    //     placeholder: "Add company",
                    //     padding: const EdgeInsets.all(10),
                    //     onChanged: (text) {
                    //       editInfo.addAll({'company': text});
                    //     },
                    //   ),
                    // ),
                    // ListTile(
                    //   title: Text(
                    //     "University",
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.w600,
                    //         fontSize: 16,
                    //         fontFamily: AppStrings.fontname,
                    //         color: newtextcolor),
                    //   ),
                    //   subtitle: CupertinoTextField(
                    //     controller: universityCtlr,
                    //     cursorColor: primaryColor,
                    //     placeholder: "Add university",
                    //     padding: EdgeInsets.all(10),
                    //     onChanged: (text) {
                    //       editInfo.addAll({'university': text});
                    //     },
                    //   ),
                    // ),
                    // ListTile(
                    //   title: Text(
                    //     "Living in",
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.w600,
                    //         fontSize: 16,
                    //         fontFamily: AppStrings.fontname,
                    //         color: newtextcolor),
                    //   ),
                    //   subtitle: CupertinoTextField(
                    //     controller: livingCtlr,
                    //     cursorColor: primaryColor,
                    //     placeholder: "Add city",
                    //     padding: const EdgeInsets.all(10),
                    //     onChanged: (text) {
                    //       editInfo.addAll({'living_in': text});
                    //     },
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 10),
                    //   child: ListTile(
                    //       title: Text(
                    //         "I am",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w600,
                    //             fontSize: 16,
                    //             fontFamily: AppStrings.fontname,
                    //             color: newtextcolor),
                    //       ),
                    //       subtitle: DropdownButton(
                    //         iconEnabledColor: primaryColor,
                    //         iconDisabledColor: secondryColor,
                    //         isExpanded: true,
                    //         items: const [
                    //           DropdownMenuItem(
                    //             value: "man",
                    //             child: Text("Man"),
                    //           ),
                    //           DropdownMenuItem(
                    //             value: "woman", // Changed value to "woman"
                    //             child: Text("Woman"),
                    //           ),
                    //           DropdownMenuItem(
                    //             value: "other",
                    //             child: Text("Other"),
                    //           ),
                    //         ],
                    //         onChanged: (val) {
                    //           editInfo.addAll({'userGender': val});
                    //           setState(() {
                    //             showMe = val;
                    //           });
                    //         },
                    //         value: showMe,
                    //       )),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // ListTile(
                    //     title: Text(
                    //       "Control your profile",
                    //       style: TextStyle(
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: 16,
                    //           fontFamily: AppStrings.fontname,
                    //           color: newtextcolor),
                    //     ),
                    //     subtitle: Card(
                    //       color: white,
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: <Widget>[
                    //           Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: <Widget>[
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Text(
                    //                   "Don't Show My Age",
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14,
                    //                       fontFamily: AppStrings.fontname,
                    //                       color: black),
                    //                 ),
                    //               ),
                    //               Switch(
                    //                   activeColor: btncolor,
                    //                   value: visibleAge,
                    //                   onChanged: (value) {
                    //                     editInfo.addAll({'showMyAge': value});
                    //                     setState(() {
                    //                       visibleAge = value;
                    //                     });
                    //                   })
                    //             ],
                    //           ),
                    //           Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: <Widget>[
                    //               Padding(
                    //                 padding: const EdgeInsets.all(8.0),
                    //                 child: Text(
                    //                   "Make My Distance Visible"
                    //                       .tr()
                    //                       .toString(),
                    //                   style: TextStyle(
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14,
                    //                       fontFamily: AppStrings.fontname,
                    //                       color: black),
                    //                 ),
                    //               ),
                    //               Switch(
                    //                   activeColor: btncolor,
                    //                   value: visibleDistance,
                    //                   onChanged: (value) {
                    //                     editInfo
                    //                         .addAll({'DistanceVisible': value});
                    //                     setState(() {
                    //                       visibleDistance = value;
                    //                     });
                    //                   })
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    //     )),
                    // const SizedBox(
                    //   height: 100,
                    // )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deletePicture(index) async {
    if (widget.currentUser.imageUrl![index] != null) {
      try {
        Reference _ref = await FirebaseStorage.instance
            .refFromURL(widget.currentUser.imageUrl![index]);
        print(_ref.fullPath);
        await _ref.delete();
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      widget.currentUser.imageUrl!.removeAt(index);
    });
    var temp = [];
    temp.add(widget.currentUser.imageUrl);
    await FirebaseFirestore.instance
        .collection("Users")
        .doc("${widget.currentUser.id}")
        .set({"Pictures": temp[0]}, SetOptions(merge: true));
  }
}

Widget _buildInterestContainer(String name, String img) {
  return Container(
    height: 39,
    width: 95,
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          img,
          height: 22,
          width: 22,
        ),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
