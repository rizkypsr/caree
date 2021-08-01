class ResponseData {
  late bool success;
  late String message;

  ResponseData({
    required this.success,
    required this.message,
  });

  ResponseData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }
}
