import 'package:caree/models/user.dart';

class Chat {
  late int? id;
  late String message;
  late User sender;
  late User receiver;
  late String? createdAt;
  late String? updatedAt;

  Chat(
      {this.id,
      required this.sender,
      required this.receiver,
      required this.message,
      this.createdAt,
      this.updatedAt});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sender = User.fromJson(json['sender']);
    receiver = User.fromJson(json['receiver']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['sender'] = this.sender.toJson();
    data['receiver'] = this.receiver.toJson();
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
