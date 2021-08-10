import 'package:caree/constants.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final String? hintText;
  final String label;
  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;
  final TextEditingController? controller;
  const PasswordTextField(
      {Key? key,
      this.hintText,
      required this.label,
      this.icon,
      this.color = Colors.white,
      this.backgroundColor = Colors.blueAccent,
      this.controller})
      : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isHide = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        Container(
          padding: EdgeInsets.only(
              left: kDefaultPadding,
              top: kDefaultPadding * 0.1,
              bottom: kDefaultPadding * 0.1,
              right: kDefaultPadding * 0.2),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: widget.controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Pastikan semua field terisi!';
              }
              return null;
            },
            cursorColor: widget.color,
            obscureText: isHide,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isHide = !isHide;
                  });
                },
                icon: Icon(isHide ? Icons.visibility_off : Icons.visibility),
              ),
              hintText: widget.hintText,
              hintStyle: TextStyle(color: widget.color),
              border: InputBorder.none,
            ),
          ),
        )
      ],
    );
  }
}
