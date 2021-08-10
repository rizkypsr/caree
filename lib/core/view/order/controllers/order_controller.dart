import 'package:caree/core/controllers/user_controller.dart';
import 'package:caree/core/view/home/controllers/food_controller.dart';
import 'package:caree/models/order.dart';
import 'package:caree/models/single_res.dart';
import 'package:caree/network/http_client.dart';
import 'package:caree/providers/order_provider.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  var isLoading = false.obs;

  final UserController _userController = Get.find<UserController>();
  final FoodController _foodController = Get.find<FoodController>();
  var _orderProvider = OrderProvider(DioClient().init());

  @override
  void onInit() {
    super.onInit();
  }

  Future getAllOrder(statusOrder) async {
    var res = await _orderProvider.getAllOrderById(
        _userController.user.value.id!, statusOrder);
    return res.data.data;
  }

  Future getAllOrdered(statusOrder) async {
    var res = await _orderProvider.getAllOrderedById(
        _userController.user.value.id!, statusOrder);

    return res.data.data;
  }

  Future<SingleResponse> addOrder(food) async {
    _showLoading();
    var order =
        Order(status: "WAITING", user: _userController.user.value, food: food);

    SingleResponse res = await _orderProvider.addOrder(order);

    await _foodController.fetchListFood();

    _hideLoading();

    return res;
  }

  Future<SingleResponse> deleteOrder(int orderUuid) async {
    SingleResponse res = await _orderProvider.deleteOrder(orderUuid);
    return res;
  }

  Future<SingleResponse> updateOrder(Order order, String newStatusOrder) async {
    SingleResponse res =
        await _orderProvider.updateOrder(order.id!, newStatusOrder);

    return res;
  }

  bool checkIfAlreadyMadeOrder(food) {
    var userUuid = _userController.user.value.id;
    var foodUserUuid = food.user.id;

    bool isFoodOwner = userUuid == foodUserUuid;

    // Check if food already have order with status FINISHED OR ONGOING
    // If order > 0, that's mean food have an order with status FINISHED OR ONGOING
    var order = food.order.where((o) => o.status != "WAITING").toList().length;

    print(food.order);
    print("isFoodOwner: $isFoodOwner");
    print("order: $order");

    // true: disable button
    // false: enable button

    return isFoodOwner || (order > 0);
  }

  _showLoading() {
    isLoading.toggle();
  }

  _hideLoading() {
    isLoading.toggle();
  }
}
