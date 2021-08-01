import 'package:caree/constants.dart';
import 'package:flutter/material.dart';

class PhoneTextField extends StatelessWidget {
  final String? hintText;
  final String label;
  final IconData? icon;
  final Color? color;
  final Color? backgroundColor;
  final TextEditingController? controller;
  const PhoneTextField(
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
            // padding: EdgeInsets.only(
            //     left: kDefaultPadding,
            //     top: kDefaultPadding * 0.1,
            //     bottom: kDefaultPadding * 0.1,
            //     right: kDefaultPadding * 0.2),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                      ),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "+62",
                            style: TextStyle(
                                color: kSecondaryColor.withOpacity(0.7)),
                          )),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      controller: controller,
                      cursorColor: color,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: hintText,
                        hintStyle: TextStyle(color: color),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
