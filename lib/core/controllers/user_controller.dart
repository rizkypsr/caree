import 'dart:convert';
import 'dart:io';

import 'package:caree/models/single_res.dart';
import 'package:caree/models/user.dart';
import 'package:caree/network/http_client.dart';
import 'package:caree/providers/user_provider.dart';
import 'package:caree/utils/user_secure_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  var imagePath = "".obs;
  var isLoading = false.obs;
  var user = User(
    fullname: "",
    email: "",
  ).obs;

  var _userProvider = UserProvider(DioClient().init());

  @override
  void onInit() {
    fetchLocalUser();
    super.onInit();
  }

  Future<void> fetchUser(int uuid) async {
    _showLoading();

    SingleResponse res = await _userProvider.getUserById(uuid);

    updateLocalUser(res.data.data);
    _hideLoading();
  }

  Future getLocalUser() async {
    var localUser = await UserSecureStorage.getUser();
    if (localUser != null) {
      return User.fromJson(json.decode(localUser));
    }
  }

  void fetchLocalUser() async {
    var localUser = await UserSecureStorage.getUser();
    if (localUser != null) {
      user.value = User.fromJson(json.decode(localUser));
    }
  }

  Future<SingleResponse> updateUser(User user) async {
    EasyLoading.show(status: "Tunggu sebentar...");
    var file = imagePath.value.isNotEmpty ? File(imagePath.value) : null;
    SingleResponse res = await _userProvider.updateUserData(user, file);
    EasyLoading.dismiss();
    return res;
  }

  Future<void> updateLocalUser(User data) async {
    String newUserEncode = json.encode(data);
    await UserSecureStorage.setUser(newUserEncode);
    user.value = data;
  }

  _showLoading() {
    isLoading.toggle();
  }

  _hideLoading() {
    isLoading.toggle();
  }
}
