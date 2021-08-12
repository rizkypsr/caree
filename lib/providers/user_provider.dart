import 'dart:io';

import 'package:caree/models/data.dart';
import 'package:caree/models/single_res.dart';
import 'package:caree/models/user.dart';
import 'package:dio/dio.dart';
import 'package:caree/utils/file_extensions.dart';

class UserProvider {
  Dio _client;

  UserProvider(this._client);

  Future<SingleResponse> getUserById(int id) async {
    try {
      Response response = await _client.get("/user/$id");

      return SingleResponse<Data>.fromJson(response.data,
          (json) => Data.fromJson(json, (data) => User.fromJson(data), "user"));
    } catch (e) {
      throw e;
    }
  }

  Future<SingleResponse> updateUserData(User user, File? image) async {
    var url = "/user/${user.id}";

    var formData = FormData.fromMap({
      'fullname': user.fullname,
      'email': user.email,
      'image': image != null
          ? await MultipartFile.fromFile(image.path, filename: image.name)
          : null,
      'firebaseToken': user.firebaseToken
    });

    try {
      Response response = await _client.put(url, data: formData);

      return SingleResponse<Data>.fromJson(
          response.data,
          (json) =>
              Data<User>.fromJson(json, (data) => User.fromJson(data), "user"));
    } catch (e) {
      throw e;
    }
  }

  Future saveRating(
    int rating,
    int userId,
  ) async {
    try {
      var data = {
        'rating': rating,
        'userId': userId,
      };

      await _client.post("/rating", data: data);
    } catch (e) {
      throw (e);
    }
  }
}
