import 'package:caree/models/response.dart';

class SingleResponse<T> extends ResponseData {
  T? data;

  SingleResponse({
    required String message,
    required bool success,
    this.data,
  }) : super(message: message, success: success);

  factory SingleResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    return SingleResponse<T>(
        success: json["success"],
        message: json["message"],
        data: create(json["data"]));
  }
}
