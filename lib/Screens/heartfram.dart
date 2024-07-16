import 'package:flutter/material.dart';

class HeartClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(size.width / 2, size.height * 0.90);
    path.cubicTo(
        size.width * 0.6,
        size.height * 0.40, // starting point
        size.width,
        size.height * 0.25, // control point 1
        size.width * 0.5,
        size.height * 0.10); // control point 2
    path.cubicTo(
        size.width * 0.1,
        size.height * 0.25, // starting point
        size.width * 0.4,
        size.height * 0.40, // control point 1
        size.width / 2,
        size.height * 0.90); // control point 2

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
