import 'dart:convert';

import 'package:caree/core/controllers/user_controller.dart';
import 'package:caree/models/data.dart';
import 'package:caree/models/single_res.dart';
import 'package:caree/models/user.dart';
import 'package:caree/utils/user_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/instance_manager.dart';

class Auth {
  Dio _client;

  Auth(this._client);

  Future<SingleResponse?> attemptRegister(
      String fullname, String email, String password) async {
    try {
      var firebaseToken = await FirebaseMessaging.instance.getToken();

      var data = {
        'fullname': fullname,
        'email': email,
        'password': password,
        'firebaseToken': firebaseToken
      };

      var response = await _client.post('/register', data: data);

      return SingleResponse<Data>.fromJson(response.data,
          (json) => Data.fromJson(json, (data) => User.fromJson(data), "user"));
    } on DioError catch (e) {
      String error = json.decode(e.response.toString())["message"];
      throw error;
    }
  }

  Future<SingleResponse?> attemptLogin(String email, String password) async {
    try {
      var firebaseToken = await FirebaseMessaging.instance.getToken();

      var data = {'email': email, 'password': password};

      Response response = await _client.post('/login', data: data);

      var results = SingleResponse<Data>.fromJson(response.data,
          (json) => Data.fromJson(json, (data) => User.fromJson(data), "user"));

      Get.find<UserController>().updateUser(
          User(id: results.data!.data.id, firebaseToken: firebaseToken));

      return results;
    } on DioError catch (e) {
      String error = json.decode(e.response.toString())["message"];
      throw error;
    }
  }

  Future getVerification(String email) async {
    try {
      var data = {
        'email': email,
      };

      await _client.post("/user/send-verification-email", data: data);
    } catch (e) {
      throw e;
    }
  }

  static Future<String?> getToken() async {
    String? token = await UserSecureStorage.getToken();

    return token;
  }

  static Future<User> getAuth() async {
    var localUser = await UserSecureStorage.getUser();

    var user = User.fromJson(json.decode(localUser!));
    return user;
  }

  static Future logOut() async {
    await UserSecureStorage.clear();
  }
}
