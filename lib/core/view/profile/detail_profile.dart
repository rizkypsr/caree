import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Get.arguments;

    return Scaffold(
      body: Column(
        children: [Text(user.fullname)],
      ),
    );
  }
}
