import 'package:caree/constants.dart';
import 'package:caree/network/interceptors/app_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  Dio init() {
    Dio _dio = Dio();
    _dio.interceptors.addAll([PrettyDioLogger(), AppInterceptors()]);

    _dio.options.baseUrl = SERVER_IP;
    _dio.options.connectTimeout = 8000;
    _dio.options.receiveTimeout = 3000;
    _dio.options.followRedirects = false;
    // _dio.options.validateStatus = (status) {
    //   return status! < 500;
    // };

    return _dio;
  }
}
