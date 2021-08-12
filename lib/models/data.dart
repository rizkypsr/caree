class Data<T> {
  String? token;
  T? data;

  Data({this.token, this.data});

  Data.fromJson(Map<String, dynamic> json,
      Function(Map<String, dynamic>) create, String keyName) {
    token = json['token'] != null ? json['token'] : null;
    data = json[keyName] != null ? create(json[keyName]) : null;
  }
}

Type typeOf<T>() => T;
