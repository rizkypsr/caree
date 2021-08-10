import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget emptyState(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/emptystate.svg',
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        SizedBox(
          height: 40.0,
        ),
        Text(
          'Maaf, tidak ada makanan \nsaat ini',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
