import 'dart:convert';

import 'package:caree/models/user.dart';
import 'package:caree/utils/user_secure_storage.dart';
import 'package:logger/logger.dart';

class Auth {
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
