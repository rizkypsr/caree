import 'package:caree/constants.dart';
import 'package:caree/providers/auth.dart';
import 'package:caree/utils/user_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';

class AppInterceptors extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? authToken = await UserSecureStorage.getToken();

    options.headers.addAll({'Authorization': 'Bearer $authToken'});

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response != null) {
      if (err.response!.statusCode == 401) {
        await Auth.logOut();
        Get.offAndToNamed(kWelcomeRoute);
      }
    }

    return super.onError(err, handler);
  }
}
