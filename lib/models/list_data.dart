class ListData<T> {
  List<T>? data;

  ListData({
    this.data,
  });

  factory ListData.fromJson(Map<String, dynamic> json,
      Function(Map<String, dynamic>) create, String keyName) {
    var data = <T>[];

    if (json[keyName] != null) {
      json[keyName].forEach((v) {
        data.add(create(v));
      });
    }

    return ListData<T>(data: data);
  }
}
