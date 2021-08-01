import 'package:caree/models/order.dart';
import 'package:caree/models/user.dart';

import 'address_point.dart';

class Food {
  late String? uuid;
  late String name;
  late String description;
  late String? picture;
  late String pickupTimes;
  late AddressPoint? addressPoint;
  late double? distance;
  late String? createdAt;
  late String? updatedAt;
  late User? user;
  late List<Order>? order;

  Food({
    this.uuid,
    required this.name,
    required this.description,
    this.picture,
    required this.pickupTimes,
    this.addressPoint,
    this.distance,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.order,
  });

  Food.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    uuid = json['uuid'];
    name = json['name'];
    description = json['description'];
    picture = json['picture'];
    pickupTimes = json['pickupTimes'];
    addressPoint = json['addressPoint'] != null
        ? AddressPoint.fromJson(json['addressPoint'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;

    if (json['order'] != null) {
      order = <Order>[];
      json['order'].forEach((v) {
        order!.add(create(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['description'] = this.description;
    data['picture'] = this.picture;
    data['pickupTimes'] = this.pickupTimes;
    if (this.addressPoint != null) {
      data['addressPoint'] = this.addressPoint!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }

  @override
  String toString() {
    return 'Food: {id : $uuid, name : $name, point: {$addressPoint}, user : $user, order: $order}';
  }
}
