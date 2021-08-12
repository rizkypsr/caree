import 'package:caree/core/controllers/user_controller.dart';
import 'package:caree/models/chat.dart';
import 'package:caree/network/http_client.dart';
import 'package:caree/providers/chat_provider.dart';
import 'package:caree/utils/socket.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final UserController _userController = Get.find<UserController>();
  var _chatProvider = ChatProvider(DioClient().init());

  var isLoading = false.obs;
  var listChat = <Chat>[].obs;

  getAllPrivateChat(senderUuid, receiverUuid) async {
    _showLoading();
    var user = _userController.user.value;

    var receiver = senderUuid != user.id ? senderUuid : receiverUuid;

    await _chatProvider.getAllPrivateChat(user.id!, receiver!).then((response) {
      var listData = response.data.data;

      listChat.addAll(listData);
    });

    _hideLoading();
  }

  sendMessage(Chat chat) {
    listChat.add(chat);

    SocketClient.emit("send_message", {
      "sender": chat.sender,
      "receiver": chat.receiver,
      "message": chat.message
    });
  }

  _socket() {
    SocketClient.initialize();

    var user = _userController.user.value;

    SocketClient.emit('user_connected', user.id);

    SocketClient.subscribe("new_message", (data) {
      Chat incomingChat = Chat.fromJson(data);

      listChat.add(incomingChat);
    });
  }

  _showLoading() {
    isLoading.toggle();
  }

  _hideLoading() {
    isLoading.toggle();
  }

  @override
  void onInit() {
    super.onInit();
    _socket();
  }
}
