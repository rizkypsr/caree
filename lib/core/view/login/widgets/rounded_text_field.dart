import 'package:caree/constants.dart';
import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final String? hintText;
  final String label;
  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;
  final TextEditingController? controller;
  const RoundedTextField(
      {Key? key,
      this.hintText,
      required this.label,
      this.icon,
      this.color = Colors.white,
      this.backgroundColor = Colors.blueAccent,
      this.controller})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        Container(
          padding: EdgeInsets.only(
              left: kDefaultPadding,
              top: kDefaultPadding * 0.1,
              bottom: kDefaultPadding * 0.1,
              right: kDefaultPadding * 0.2),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            cursorColor: color,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: color),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
