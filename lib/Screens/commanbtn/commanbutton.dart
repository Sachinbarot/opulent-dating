import 'package:flutter/material.dart';
import 'package:hookup4u/Screens/Calling/utils/strings.dart';
import 'package:hookup4u/util/color.dart';

class MyButton extends StatelessWidget {
  final double radius;
  final String textname;
  final VoidCallback onTap;
  final bool isProcessing;

  const MyButton({
    Key? key,
    required this.radius,
    required this.textname,
    required this.onTap,
    required this.isProcessing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: 51,
        margin: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: isProcessing ? Colors.grey : btncolor,
        ),
        child: Center(
          child: isProcessing
              ? Container()
              : Text(
                  textname,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}

Widget commanbtn(radius, textname) {
  return Container(
      height: 51,
      margin: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius), color: btncolor),
      child: Center(
          child: Text(
        textname,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: AppStrings.fontname,
            fontWeight: FontWeight.w600),
      )));
}

Widget backbuttoncomman(context) {
  return Scaffold(
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
          child: const Padding(
              padding: EdgeInsets.only(left: 7),
              child: Icon(
                Icons.arrow_back_ios,
                size: 22,
              )),
        ),
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
  );
}

PreferredSizeWidget? commonAppBar(BuildContext context, String headings) {
  return AppBar(
    backgroundColor: backcolor,
    title: Center(
      child: Padding(
        padding:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.15),
        child: Text(
          headings,
          style: TextStyle(
            color: black,
            fontFamily: AppStrings.fontname,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
    ),
    leading: InkWell(
      splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
        child: Image.asset(
          'asset/cross.png',
          width: MediaQuery.of(context).size.width * 0.04,
          height: MediaQuery.of(context).size.width * 0.04,
        ),
      ),
    ),
    elevation: 0,
  );
}
