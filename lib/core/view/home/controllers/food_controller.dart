import 'dart:convert';
import 'dart:io';

import 'package:caree/models/food.dart';
import 'package:caree/models/single_res.dart';
import 'package:caree/models/user.dart';
import 'package:caree/network/API.dart';
import 'package:caree/utils/user_secure_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class FoodController extends GetxController {
  var listFood = <Food>[].obs;
  var listFoodById = <Food>[].obs;
  var isLoading = false.obs;
  var imagePath = "".obs;

  @override
  void onInit() {
    fetchListFood();
    super.onInit();
  }

  Future<void> fetchListFood() async {
    showLoading();

    var res = await API.getAllFood();
    var pos = await _getCurrentLocation();

    List<Food> food = res.data.data
        .where((element) => element.order!.isNotEmpty
            ? element.order![0].status != "FINISHED"
            : true)
        .toList();

    food.forEach((it) {
      it.distance = _distanceInMeters(it.addressPoint!.coordinates[0],
          it.addressPoint!.coordinates[1], pos.latitude, pos.longitude);
    });

    listFood.clear();

    listFood.addAll(food);

    hideLoading();
  }

  Future<Position> _getCurrentLocation() async {
    var pos = await Geolocator.getCurrentPosition();
    return pos;
  }

  double _distanceInMeters(
      startLatitude, startLongitude, endLatitude, endLongitude) {
    return Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);
  }

  showLoading() {
    isLoading.toggle();
  }

  hideLoading() {
    isLoading.toggle();
  }

  Future<SingleResponse> saveFood(food, imagePath) async {
    showLoading();
    var res = await API.addFood(food, File(imagePath));
    hideLoading();
    fetchListFood();
    return res;
  }

  Future<SingleResponse> updateFood(food) async {
    EasyLoading.show(status: 'loading...');
    var file = imagePath.value.isNotEmpty ? File(imagePath.value) : null;
    var res = await API.updateFoodData(food, file);
    return res;
  }

  getAllFoodById() async {
    showLoading();
    var localUser = await UserSecureStorage.getUser();
    var user = User.fromJson(json.decode(localUser!));
    var res = await API.getAllFoodById(user.uuid!);
    hideLoading();

    listFoodById.clear();

    listFoodById.addAll(res.data.data);

    return res.data.data;
  }

  Future<void> deleteFood(uuid) async {
    EasyLoading.show(status: "Tunggu sebentar...");

    await API.deleteFood(uuid);

    EasyLoading.dismiss();

    getAllFoodById();
  }

  void resetImagePath() => imagePath.value = "";
}
