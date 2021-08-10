import 'package:caree/constants.dart';
import 'package:caree/core/view/home/controllers/food_controller.dart';
import 'package:caree/network/http_client.dart';
import 'package:caree/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class FinishOrderScreen extends StatelessWidget {
  final FoodController _foodController = Get.find<FoodController>();
  final _userProvider = UserProvider(DioClient().init());

  _saveRating(int rating, int userUuid) async {
    await _userProvider.saveRating(rating, userUuid);
    await _foodController.fetchListFood();

    EasyLoading.showSuccess("Berhasil memberi penilaian!");

    Get.toNamed(kHomeRoute);
  }

  @override
  Widget build(BuildContext context) {
    var user = Get.arguments;

    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              backgroundImage: user.picture == null
                  ? Image.asset(
                      "assets/people.png",
                      fit: BoxFit.cover,
                    ).image
                  : Image.network(
                      "$BASE_IP/uploads/${user.picture}",
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
                    user.fullname,
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
                      _saveRating(rating.toInt(), user.id!);
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
