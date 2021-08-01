import 'dart:io';

import 'package:caree/models/chat.dart';
import 'package:caree/models/data.dart';
import 'package:caree/models/food.dart';
import 'package:caree/models/list_data.dart';
import 'package:caree/models/order.dart';
import 'package:caree/models/single_res.dart';
import 'package:caree/models/user.dart';
import 'package:caree/network/http_client.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:caree/utils/file_extensions.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class API {
  static Future<SingleResponse?> attemptLogin(
      String email, String password) async {
    var url = "/login";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      var data = {'email': email, 'password': password};

      Response response = await apiService.postRequest(url, data);

      return SingleResponse<Data>.fromJson(response.data,
          (json) => Data.fromJson(json, (data) => User.fromJson(data), "user"));
    } catch (e) {
      throw e;
    }
  }

  static Future sendMessage(Chat chat) async {
    var url = "/chat";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      var data = {
        'senderUuid': chat.sender.uuid,
        'receiverUuid': chat.receiver.uuid,
        'message': chat.message
      };

      await apiService.postRequestWihtoutLoading(url, data);
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse?> attemptRegister(
      String fullname, String email, String password, String phone) async {
    var url = "/register";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      var data = {
        'fullname': fullname,
        'email': email,
        'password': password,
        'phone': phone
      };

      Response response = await apiService.postRequest(url, data);

      return SingleResponse<Data>.fromJson(response.data,
          (json) => Data.fromJson(json, (data) => User.fromJson(data), "user"));
    } catch (e) {
      print(e);
    }
  }

  static Future saveRating(
    int rating,
    String userUuid,
  ) async {
    var url = "/rating";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      var data = {
        'rating': rating,
        'userUuid': userUuid,
      };

      await apiService.postRequest(url, data);
    } catch (e) {
      print(e);
    }
  }

  static Future getVerification(String email) async {
    var url = "/user/send-verification-email";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      var data = {
        'email': email,
      };

      var res = await apiService.postRequest(url, data);
      print(res.data);
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> getUserById(String uuid) async {
    var url = "/user/$uuid";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      Response response = await apiService.getRequest(url);

      return SingleResponse<Data>.fromJson(response.data,
          (json) => Data.fromJson(json, (data) => User.fromJson(data), "user"));
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> getAllChatById(String uuid) async {
    var url = "/chat/$uuid";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      Response response = await apiService.getRequest(url);

      return SingleResponse<ListData>.fromJson(
          response.data,
          (json) => ListData<Chat>.fromJson(
              json, (data) => Chat.fromJson(data), 'chat'));
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> getAllPrivateChat(
      String sender, String receiver) async {
    var url = "/chat/$sender/$receiver";

    try {
      HttpClient apiService = HttpClient();

      await apiService.clientSetup();

      Response response = await apiService.getRequest(url);

      return SingleResponse<ListData>.fromJson(
          response.data,
          (json) => ListData<Chat>.fromJson(
              json, (data) => Chat.fromJson(data), 'chat'));
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> getAllFood() async {
    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      Response response = await apiService.getRequest("/food");

      return SingleResponse<ListData>.fromJson(
          response.data,
          (json) => ListData<Food>.fromJson(json,
              (data) => Food.fromJson(data, (v) => Order.fromJson(v)), 'food'));
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> getAllFoodById(String userUuid) async {
    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      Response response = await apiService.getRequest("/food/$userUuid");

      return SingleResponse<ListData>.fromJson(
          response.data,
          (json) => ListData<Food>.fromJson(json,
              (data) => Food.fromJson(data, (v) => Order.fromJson(v)), 'food'));
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse?> getFoodById(String id) async {
    var url = "/food/$id";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      var response = await apiService.getRequest(
        url,
      );

      return SingleResponse<Data>.fromJson(
          response.data,
          (json) => Data<Food>.fromJson(json,
              (data) => Food.fromJson(data, (v) => Order.fromJson(v)), "food"));
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> getAllOrderById(
      String userUuid, String status) async {
    var url = "/order/$userUuid/$status";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      Response response = await apiService.getRequest(url);

      return SingleResponse<ListData>.fromJson(
          response.data,
          (json) => ListData<Order>.fromJson(
              json, (data) => Order.fromJson(data), 'order'));
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> getAllOrderedById(
      String userUuid, String status) async {
    var url = "/ordered/$userUuid/$status";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      Response response = await apiService.getRequest(url);

      return SingleResponse<ListData>.fromJson(
          response.data,
          (json) => ListData<Order>.fromJson(
              json, (data) => Order.fromJson(data), 'order'));
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> addFood(Food food, File image) async {
    var url = "/food";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      var formData = FormData.fromMap({
        'name': food.name,
        'description': food.description,
        'userUuid': food.user!.uuid,
        'pickupTimes': food.pickupTimes,
        'lat': food.addressPoint!.coordinates[0],
        'lang': food.addressPoint!.coordinates[1],
        'image': await MultipartFile.fromFile(image.path, filename: image.name)
      });

      Response response = await apiService.postRequest(url, formData);

      return SingleResponse<Data>.fromJson(
          response.data,
          (json) => Data<Food>.fromJson(
              json, (data) => Food.fromJson(data, (v) => null), "food"));
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> addOrder(Order order) async {
    var url = "/order";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();
      var data = {
        'status': order.status,
        'userUuid': order.user!.uuid,
        'foodUuid': order.food!.uuid
      };

      Response response = await apiService.postRequest(url, data);

      print(response);

      return SingleResponse<Data>.fromJson(
          response.data,
          (json) => Data<Order>.fromJson(
              json, (data) => Order.fromJson(data), "order"));
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> updateOrder(
      String orderUuid, String status) async {
    var url = "/order/$orderUuid";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      var data = {'status': status};

      var response = await apiService.putRequest(url, data);

      return SingleResponse<Data>.fromJson(response.data, (json) => null);
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> deleteOrder(String orderUuid) async {
    var url = "/order/$orderUuid";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      var response = await apiService.deleteRequest(url);

      return SingleResponse<Data>.fromJson(response.data, (json) => null);
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> deleteOrderByStatus(
      String orderUuid, String status) async {
    var url = "/order/$orderUuid/$status";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      var response = await apiService.deleteRequest(url);

      return SingleResponse<Data>.fromJson(response.data, (json) => null);
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> updateUserData(User user, File? image) async {
    var url = "/user/${user.uuid}";

    var formData = FormData.fromMap({
      'fullname': user.fullname,
      'email': user.email,
      'phone': user.phone,
      'image': image != null
          ? await MultipartFile.fromFile(image.path, filename: image.name)
          : null
    });

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      Response response = await apiService.putRequest(url, formData);

      EasyLoading.dismiss();

      return SingleResponse<Data>.fromJson(
          response.data,
          (json) =>
              Data<User>.fromJson(json, (data) => User.fromJson(data), "user"));
    } catch (e) {
      throw e;
    }
  }

  static Future deleteFood(String foodUuid) async {
    var url = "/food/$foodUuid";

    try {
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      await apiService.deleteRequest(url);
    } catch (e) {
      throw e;
    }
  }

  static Future<SingleResponse> updateFoodData(Food food, File? image) async {
    var url = "/food/${food.uuid}";

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
      HttpClient apiService = HttpClient();
      await apiService.clientSetup();

      var res = await apiService.putRequest(url, formData);

      return SingleResponse.fromJson(res.data, (_) => null);
    } catch (e) {
      throw e;
    }
  }
}
