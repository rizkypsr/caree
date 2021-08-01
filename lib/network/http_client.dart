import 'package:caree/constants.dart';
import 'package:caree/models/single_res.dart';
import 'package:caree/utils/user_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class HttpClient {
  HttpClient() {
    client = Dio();
    client.options.baseUrl = SERVER_IP;
    client.options.connectTimeout = 12000;
    client.options.receiveTimeout = 30000;
    client.options.followRedirects = false;
    client.options.validateStatus = (status) {
      return status! < 500;
    };
  }

  late Dio client;

  void setToken(String authToken) {
    client.options.headers['Authorization'] = 'Bearer $authToken';
  }

  Future<void> clientSetup() async {
    String? authToken = await UserSecureStorage.getToken();
    if (authToken != null)
      client.options.headers['Authorization'] = 'Bearer $authToken';
  }

  Future<Response> getRequest(String endpoint) async {
    Response response = await client.get(endpoint);

    return response;
  }

  Future<Response> postRequest(String endpoint, dynamic data) async {
    Response response = await client.post(endpoint,
        data: data,
        onSendProgress: (sent, total) =>
            EasyLoading.show(status: 'loading...'));

    return response;
  }

  Future<Response> postRequestWihtoutLoading(
      String endpoint, dynamic data) async {
    Response response = await client.post(
      endpoint,
      data: data,
    );

    return response;
  }

  Future<Response> putRequest(String endpoint, dynamic data) async {
    Response response = await client.put(endpoint,
        data: data,
        onSendProgress: (sent, total) =>
            EasyLoading.show(status: 'loading...'));
    return response;
  }

  Future<Response> deleteRequest(String url) async {
    Response response = await client.delete(url);
    return response;
  }
}
