import 'package:caree/models/food.dart';
import 'package:caree/models/user.dart';

class Order {
  late String? uuid;
  late String status;
  late String? createdAt;
  late String? updatedAt;
  late User? user;
  late Food? food;

  Order(
      {this.uuid,
      required this.status,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.food});

  Order.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    food =
        json['food'] != null ? Food.fromJson(json['food'], (v) => null) : null;
  }

  @override
  String toString() {
    return "Order: { uuid: $uuid, status: $status, user: $user, food: $food }";
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = Map<String, dynamic>();
  //   data['uuid'] = this.uuid;
  //   data['status'] = this.status;
  //   data['createdAt'] = this.createdAt;
  //   data['updatedAt'] = this.updatedAt;
  //   if (this.user != null) {
  //     data['user'] = this.user.toJson();
  //   }
  //   if (this.food != null) {
  //     data['food'] = this.food.toJson();
  //   }
  //   return data;
  // }
}
