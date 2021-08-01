import 'package:caree/core/controllers/user_controller.dart';
import 'package:get/instance_manager.dart';

class UserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}
