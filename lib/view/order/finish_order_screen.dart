import 'package:caree/constants.dart';
import 'package:caree/main.dart';
import 'package:caree/models/user.dart';
import 'package:caree/network/API.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

class FinishOrderScreen extends StatefulWidget {
  const FinishOrderScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _FinishOrderScreenState createState() => _FinishOrderScreenState();
}

class _FinishOrderScreenState extends State<FinishOrderScreen> {
  _saveRating(int rating, String userUuid) async {
    await API.saveRating(rating, userUuid);

    EasyLoading.showSuccess("Berhasil memberi penilaian!");

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Main()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/finished.svg',
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  top: kDefaultPadding,
                  bottom: kDefaultPadding * 0.9),
              child: Text(
                "Order selesai\nTerima kasih sudah berbagi",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              "Silahkan beri nilai ke penerima",
              style: TextStyle(
                  color: kSecondaryColor.withOpacity(0.6), fontSize: 16.0),
            ),
            SizedBox(
              height: 30.0,
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage: widget.user.picture == null
                  ? Image.asset(
                      "assets/people.png",
                      fit: BoxFit.cover,
                    ).image
                  : Image.network(
                      "$SERVER_IP/uploads/${widget.user.picture}",
                      fit: BoxFit.cover,
                    ).image,
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 100,
              width: 300,
              padding: EdgeInsets.symmetric(),
              decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bambang Sutrisno',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _saveRating(rating.toInt(), widget.user.uuid!);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
