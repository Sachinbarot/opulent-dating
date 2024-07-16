// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, prefer_const_constructors, prefer_is_empty, sort_child_properties_last, avoid_print, file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as au;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as i;
import '../util/color.dart';
import 'AllowLocation.dart';

class ProfilePicSet extends StatefulWidget {
  final Map<String, dynamic> userData;
  const ProfilePicSet(
    this.userData,
  );

  @override
  State<ProfilePicSet> createState() => _ProfilePicSetState();
}

class _ProfilePicSetState extends State<ProfilePicSet> {
  final FirebaseAuth? auth = au.FirebaseAuth.instance;
  String? imgUrl = '';
  bool isImageUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backcolor,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: black.withOpacity(0.5))),
            child: Padding(
                padding: EdgeInsets.only(left: 7),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 22,
                )),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: <Widget>[
                  Padding(
                    child: Text(
                      "Upload Your Image ",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: black,
                          fontSize: 30,
                          fontFamily: AppStrings.fontname),
                    ),
                    padding: EdgeInsets.only(left: 50, top: 120),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  alignment: Alignment.center,
                  child: Container(
                      width: 250,
                      height: 250,
                      margin: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: white,
                        border: Border.all(color: btncolor, width: 2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: !isImageUploaded
                          ? IconButton(
                              color: btncolor,
                              iconSize: 60,
                              icon: Icon(Icons.add_a_photo),
                              onPressed: () async {
                                await source(context, true);
                              },
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                imgUrl!,
                                width: 250,
                                height: 250,
                                fit: BoxFit.fill,
                              ))),
                ),
              ),
              isImageUploaded
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                color: btncolor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: MediaQuery.of(context).size.height * .065,
                              width: MediaQuery.of(context).size.width * .75,
                              child: Center(
                                  child: Text(
                                "Change Image",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: white,
                                    fontWeight: FontWeight.bold),
                              ))),
                          onTap: () async {
                            await source(context, true);
                          },
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              imgUrl!.length > 0
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: btncolor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: MediaQuery.of(context).size.height * .065,
                              width: MediaQuery.of(context).size.width * .55,
                              child: Center(
                                  child: Text(
                                'Continue',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                              ))),
                          onTap: () async {
                            print(widget.userData);
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      AllowLocation(widget.userData),
                                  // Gender(widget.userData)
                                ));
                          },
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              height: MediaQuery.of(context).size.height * .065,
                              width: MediaQuery.of(context).size.width * .75,
                              child: Center(
                                  child: Text(
                                '',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: secondryColor,
                                    fontWeight: FontWeight.bold),
                              ))),
                          onTap: () {},
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> source(BuildContext context, bool isProfilePicture) async {
    print("Source CAlled");
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text('Add Picture'),
              content: Text('Select Source'),
              insetAnimationCurve: Curves.decelerate,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.photo_camera,
                          size: 28,
                        ),
                        Text(
                          'camera',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) {
                            getImage(
                                ImageSource.camera, context, isProfilePicture);
                            return Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(btncolor),
                            ));
                          });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(
                          Icons.photo_library,
                          size: 28,
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
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
                            getImage(
                                ImageSource.gallery, context, isProfilePicture);
                            return Center(
                                child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(btncolor),
                            ));
                          });
                    },
                  ),
                ),
              ]);
        });
  }

  Future<void> getImage(
      ImageSource imageSource, context, isProfilePicture) async {
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
                toolbarColor: btncolor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: true),
            IOSUiSettings(
              minimumAspectRatio: 1.0,
              title: 'Crop',
            )
          ],
        );

        // CroppedFile croppedFile = await ImageCropper().cropImage(
        //     sourcePath: image.path,
        //     cropStyle: CropStyle.circle,
        //     aspectRatioPresets: [CropAspectRatioPreset.square],
        //     androidUiSettings: AndroidUiSettings(
        //         toolbarTitle: 'Crop',
        //         toolbarColor: primaryColor,
        //         toolbarWidgetColor: Colors.white,
        //         initAspectRatio: CropAspectRatioPreset.square,
        //         lockAspectRatio: true),
        //     iosUiSettings: IOSUiSettings(
        //       minimumAspectRatio: 1.0,
        //     ));

        if (croppedFile != null) {
          await uploadFile(await compressimage(croppedFile), isProfilePicture);
        }
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future uploadFile(File image, isProfilePicture) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('users/${auth!.currentUser!.uid}/${image.hashCode}.jpg');
    UploadTask uploadTask = storageReference.putFile(image);
    //if (uploadTask.isInProgress == true) {}
    //if (await uploadTask.onComplete != null) {
    await uploadTask.whenComplete(() {
      storageReference.getDownloadURL().then((fileURL) async {
        setState(() {
          print('jbjjjjjjjjjjjjjjjjjjjj');
          imgUrl = fileURL;
          isImageUploaded = true;
        });
        Map<String, dynamic> updateObject = {
          "Pictures": FieldValue.arrayUnion([
            fileURL,
          ])
        };

        // try {
        //   if (isProfilePicture) {
        //     //currentUser.imageUrl.removeAt(0);
        //     .imageUrl!.insert(0, fileURL);
        //     print("object");
        //     await FirebaseFirestore.instance
        //         .collection("Users")
        //         .doc(currentUser.id)
        //         .set(
        //       {"Pictures": currentUser.imageUrl},
        //     );
        //   } else {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(auth!.currentUser!.uid)
            .set(updateObject, SetOptions(merge: true));
        // widget.currentUser.imageUrl!.add(fileURL);
        //}
        //   if (mounted) setState(() {});
        // } catch (err) {
        //   print("Error: $err");
        // }
      });
      // .then((value) {
      //   print('-----${storageReference.getDownloadURL().toString()}');
      //   uploadTask.whenComplete(() {
      //     storageReference.getDownloadURL().then((valuee) {
      //       imgUrl = valuee;
      //     });
      //   });
      // });
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
}
