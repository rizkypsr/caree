import 'package:caree/core/controllers/user_controller.dart';
import 'package:caree/models/chat.dart';
import 'package:caree/network/http_client.dart';
import 'package:caree/providers/chat_provider.dart';
import 'package:caree/utils/socket.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  var listChat = <Chat>[].obs;
  var isLoading = false.obs;

  final UserController _userController = Get.find<UserController>();
  var _chatProvider = ChatProvider(DioClient().init());

  @override
  void onInit() {
    super.onInit();
    _socket();
  }

  Future<void> getAllChatById() async {
    _showLoading();

    var user = _userController.user.value;

    var res = await _chatProvider.getAllChatById(user.id!);

    listChat.clear();
    listChat.addAll(res.data.data);

    _hideLoading();
  }

  _socket() {
    SocketClient.initialize();

    var user = _userController.user.value;

    SocketClient.emit('user_connected', user.id);

    SocketClient.subscribe("new_message", (data) {
      getAllChatById();
    });
  }

  _showLoading() {
    isLoading.toggle();
  }

  _hideLoading() {
    isLoading.toggle();
  }
}
