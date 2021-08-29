import 'dart:async';

import 'package:caree/constants.dart';
import 'package:caree/core/view/home/controllers/food_controller.dart';
import 'package:caree/core/view/home/controllers/map_controller.dart';
import 'package:caree/network/http_client.dart';
import 'package:caree/providers/user_provider.dart';
import 'package:caree/utils/map_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailOrderScreen extends StatelessWidget {
  final FoodController _foodController = Get.find<FoodController>();
  final _userProvider = UserProvider(DioClient().init());

  _saveRating(int rating, int userUuid) async {
    EasyLoading.show(status: "Tunggu sebentar...");
    await _userProvider.saveRating(rating, userUuid);
    await _foodController.fetchListFood();

    EasyLoading.dismiss();
    EasyLoading.showSuccess("Berhasil memberi penilaian!");

    Get.offNamed(kHomeRoute);
  }

  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> _googleMapController = Completer();
    final MapController _mapController = Get.find<MapController>();

    var order = Get.arguments;

    Future<void> _updateMapPosition(LatLng position) async {
      final GoogleMapController controller = await _googleMapController.future;
      _mapController.center.value = position;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 18)));
      _mapController.setMarker();
    }

    _updateMapPosition(LatLng(order.food.addressPoint!.coordinates[0],
        order.food.addressPoint!.coordinates[1]));

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
          'Detail Pesanan',
          style: TextStyle(color: kSecondaryColor),
        ),
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Status Pesanan"),
              Text(
                order.status,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("Tanggal Pesanan"),
              Text("Kamis, 20 Juli 2021 - 8:50 AM",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(
                height: 10.0,
              ),
              Text("Pemilik Makanan"),
              Text(
                order.food!.user!.fullname,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("Penerima"),
              Wrap(
                  spacing: 3.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      order.user!.fullname,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      Icons.star,
                      color: Color(0xFFF7CA63),
                      size: 20,
                    ),
                    Text(
                      order.user!.ratingAvg == null
                          ? "User Baru"
                          : double.parse(order.user!.ratingAvg!)
                              .toStringAsFixed(1)
                              .toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10.0),
                    ),
                  ]),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                color: kSecondaryColor.withAlpha(100),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Makanan"),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      "$BASE_IP/${order.food!.picture}",
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.food!.name,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    order.food!.description,
                                    style: TextStyle(fontSize: 11.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Divider(
                color: kSecondaryColor.withAlpha(100),
              ),
              SizedBox(
                height: 20.0,
              ),
              Obx(() => Container(
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
                  )),
            ],
          )),
    );
  }
}
