import 'package:caree/models/data.dart';
import 'package:caree/models/list_data.dart';
import 'package:caree/models/order.dart';
import 'package:caree/models/single_res.dart';
import 'package:dio/dio.dart';

class OrderProvider {
  Dio _client;

  OrderProvider(this._client);

  Future<SingleResponse> addOrder(Order order) async {
    try {
      var data = {
        'status': order.status,
        'userId': order.user!.id,
        'foodId': order.food!.id
      };

      Response response = await _client.post("/order", data: data);

      return SingleResponse<Data>.fromJson(
          response.data,
          (json) => Data<Order>.fromJson(
              json, (data) => Order.fromJson(data), "order"));
    } catch (e) {
      throw e;
    }
  }

  Future<SingleResponse> getAllOrderById(int userId, String status) async {
    try {
      Response response = await _client.get("/order/$userId/$status");

      return SingleResponse<ListData>.fromJson(
          response.data,
          (json) => ListData<Order>.fromJson(
              json, (data) => Order.fromJson(data), 'order'));
    } catch (e) {
      throw e;
    }
  }

  Future<SingleResponse> getAllOrderedById(int userId, String status) async {
    try {
      Response response = await _client.get("/ordered/$userId/$status");

      return SingleResponse<ListData>.fromJson(
          response.data,
          (json) => ListData<Order>.fromJson(
              json, (data) => Order.fromJson(data), 'order'));
    } catch (e) {
      throw e;
    }
  }

  Future<SingleResponse> updateOrder(int orderId, String status) async {
    try {
      var data = {'status': status};

      var response = await _client.put("/order/$orderId", data: data);

      return SingleResponse<Data>.fromJson(response.data, (json) => null);
    } catch (e) {
      throw e;
    }
  }

  Future<SingleResponse> deleteOrder(int orderId) async {
    try {
      var response = await _client.delete("/order/$orderId");

      return SingleResponse<Data>.fromJson(response.data, (json) => null);
    } catch (e) {
      throw e;
    }
  }

  Future<SingleResponse> deleteOrderByStatus(int orderId, String status) async {
    try {
      var response = await _client.delete("/order/$orderId/$status");

      return SingleResponse<Data>.fromJson(response.data, (json) => null);
    } catch (e) {
      throw e;
    }
  }
}
