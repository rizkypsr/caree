import 'dart:io';

import 'package:caree/models/data.dart';
import 'package:caree/models/food.dart';
import 'package:caree/models/list_data.dart';
import 'package:caree/models/order.dart';
import 'package:caree/models/single_res.dart';
import 'package:caree/utils/file_extensions.dart';
import 'package:dio/dio.dart';

class FoodProvider {
  Dio _client;

  FoodProvider(this._client);

  Future<SingleResponse> getAllFood() async {
    try {
      Response response = await _client.get("/food");

      return SingleResponse<ListData>.fromJson(
          response.data,
          (json) => ListData<Food>.fromJson(json,
              (data) => Food.fromJson(data, (v) => Order.fromJson(v)), 'food'));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<SingleResponse> getAllFoodById(int userId) async {
    try {
      Response response = await _client.get("/food/user/$userId");

      return SingleResponse<ListData>.fromJson(
          response.data,
          (json) => ListData<Food>.fromJson(json,
              (data) => Food.fromJson(data, (v) => Order.fromJson(v)), 'food'));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<SingleResponse?> getFoodById(int id) async {
    try {
      var response = await _client.get("/food/$id");

      return SingleResponse<Data>.fromJson(
          response.data,
          (json) => Data<Food>.fromJson(json,
              (data) => Food.fromJson(data, (v) => Order.fromJson(v)), "food"));
    } on DioError catch (e) {
      throw e.message;
    }
  }

  Future<SingleResponse> addFood(Food food, File image) async {
    try {
      var formData = FormData.fromMap({
        'name': food.name,
        'description': food.description,
        'userId': food.user!.id,
        'pickupTimes': food.pickupTimes,
        'lat': food.addressPoint!.coordinates[0],
        'lang': food.addressPoint!.coordinates[1],
        'image': await MultipartFile.fromFile(image.path, filename: image.name)
      });

      Response response = await _client.post("/food", data: formData);

      return SingleResponse<Data>.fromJson(
          response.data,
          (json) => Data<Food>.fromJson(
              json, (data) => Food.fromJson(data, (v) => null), "food"));
    } catch (e) {
      throw e;
    }
  }

  Future<SingleResponse> updateFoodData(Food food, File? image) async {
    var formData = FormData.fromMap({
      'name': food.name,
      'description': food.description,
      'pickupTimes': food.pickupTimes,
      'lat': food.addressPoint!.coordinates[0],
      'lang': food.addressPoint!.coordinates[1],
      'image': image != null
          ? await MultipartFile.fromFile(image.path, filename: image.name)
          : null
    });

    try {
      var res = await _client.put("/food/${food.id}", data: formData);

      return SingleResponse.fromJson(res.data, (_) => null);
    } catch (e) {
      throw e;
    }
  }

  Future deleteFood(int foodId) async {
    try {
      await _client.delete("/food/$foodId");
    } catch (e) {
      throw e;
    }
  }
}
