import 'dart:async';

import 'package:caree/constants.dart';
import 'package:caree/core/view/home/controllers/map_controller.dart';
import 'package:caree/core/view/order/controllers/order_controller.dart';
import 'package:caree/models/food.dart';
import 'package:caree/utils/map_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailScreen extends StatelessWidget {
  final storage = FlutterSecureStorage();
  final Completer<GoogleMapController> _googleMapController = Completer();
  final MapController _mapController = Get.find<MapController>();
  final OrderController _orderController = Get.find<OrderController>();

  _addOrder(food) async {
    var res = await _orderController.addOrder(food);

    if (res.success) {
      EasyLoading.showSuccess(
          'Berhasil Request. Silahkan menunggu konfirmasi!');

      Get.back();
    } else {
      EasyLoading.showError('Terjadi kesalahan!');
    }
  }

  Future<void> updateMapPosition(LatLng position) async {
    final GoogleMapController controller = await _googleMapController.future;
    _mapController.center.value = position;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 18)));
    _mapController.setMarker();
  }

  @override
  Widget build(BuildContext context) {
    Food food = Get.arguments;

    updateMapPosition(LatLng(
        food.addressPoint!.coordinates[0], food.addressPoint!.coordinates[1]));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: kSecondaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          food.name,
          style: TextStyle(color: kSecondaryColor),
        ),
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
      ),
      bottomNavigationBar: Obx(() => Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: SizedBox(
              height: 45,
              child: ElevatedButton(
                  onPressed: _orderController.checkIfAlreadyMadeOrder(food)
                      ? null
                      : () => _addOrder(food),
                  child: Text("Request Makanan"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          _orderController.checkIfAlreadyMadeOrder(food)
                              ? Colors.grey
                              : kPrimaryColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )))),
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage("$BASE_IP/${food.picture}")),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: TextStyle(
                        color: kSecondaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 15,
                        color: kSecondaryColor.withOpacity(0.5),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        timeago.format(DateTime.parse(food.createdAt!),
                            locale: 'id'),
                        style: TextStyle(
                            color: kSecondaryColor.withOpacity(0.5),
                            fontSize: 12.0),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Wrap(
                    spacing: 10.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 12.0,
                        backgroundColor: Colors.white,
                        backgroundImage: food.user!.picture != null
                            ? NetworkImage("$BASE_IP/${food.user!.picture}")
                            : AssetImage("assets/people.png") as ImageProvider,
                      ),
                      Text(
                        getFirstWords(food.user!.fullname!, 1),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.0),
                      ),
                      Container(
                        width: 7.0,
                        height: 7.0,
                        decoration: BoxDecoration(
                            color: kSecondaryColor, shape: BoxShape.circle),
                      ),
                      Wrap(
                        spacing: 3.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Color(0xFFF7CA63),
                            size: 20,
                          ),
                          Text(
                            food.user!.ratingAvg == null
                                ? "User baru"
                                : double.parse(food.user!.ratingAvg!)
                                    .toStringAsFixed(1)
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12.0),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Deskripsi",
                    style: TextStyle(
                        color: kSecondaryColor, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    food.description,
                    style: TextStyle(color: kSecondaryColor.withOpacity(0.8)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Waktu Pengambilan",
                    style: TextStyle(
                        color: kSecondaryColor, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    food.pickupTimes,
                    style: TextStyle(color: kSecondaryColor.withOpacity(0.8)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Obx(() {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      child: GoogleMap(
                          onMapCreated: (controller) {
                            _googleMapController.complete(controller);
                          },
                          markers: _mapController.markers,
                          onTap: (latlng) {
                            MapUtils.openMap(latlng.latitude, latlng.longitude);
                          },
                          myLocationButtonEnabled: false,
                          initialCameraPosition: CameraPosition(
                              target: _mapController.center.value, zoom: 18)),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getFirstWords(String sentence, int wordCounts) {
  return sentence.split(" ").sublist(0, wordCounts).join(" ");
}
