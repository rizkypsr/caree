import 'package:caree/constants.dart';
import 'package:caree/network/interceptors/app_interceptor.dart';
import 'package:dio/dio.dart';

class DioClient {
  Dio init() {
    Dio _dio = Dio();
    _dio.interceptors.addAll([AppInterceptors()]);

    _dio.options.baseUrl = SERVER_IP;
    _dio.options.connectTimeout = 15000;
    _dio.options.receiveTimeout = 3000;
    _dio.options.followRedirects = false;

    return _dio;
  }
}
