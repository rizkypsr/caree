import 'package:caree/core/controllers/network_controller.dart';
import 'package:get/instance_manager.dart';

class NetworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NetworkController>(() => NetworkController());
  }
}
