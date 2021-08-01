import 'package:caree/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
          child: Image.asset(
        "assets/logo_small.png",
        width: 200,
        height: 200,
      )),
    );
  }
}
