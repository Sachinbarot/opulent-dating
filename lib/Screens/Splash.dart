// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "asset/newsplash.png",
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
