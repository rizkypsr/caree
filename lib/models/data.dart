class Data<T> {
  String? token;
  T? data;

  Data({this.token, this.data});

  Data.fromJson(Map<String, dynamic> json,
      Function(Map<String, dynamic>) create, String keyName) {
    token = json['token'] != null ? json['token'] : null;
    data = json[keyName] != null ? create(json[keyName]) : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = Map<String, dynamic>();
  //   data['token'] = this.token;
  //   if (this.user != null) {
  //     data['user'] = this.user!.toJson();
  //   }
  //   return data;
  // }

  @override
  String toString() {
    return "Data: { token: $token, data: $data }";
  }
}

Type typeOf<T>() => T;
