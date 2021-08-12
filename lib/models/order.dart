import 'package:caree/models/food.dart';
import 'package:caree/models/user.dart';

class Order {
  late int? id;
  late String status;
  late String? createdAt;
  late String? updatedAt;
  late User? user;
  late Food? food;

  Order(
      {this.id,
      required this.status,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.food});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    food =
        json['food'] != null ? Food.fromJson(json['food'], (v) => null) : null;
  }
}
