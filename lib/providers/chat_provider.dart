import 'package:caree/models/chat.dart';
import 'package:caree/models/list_data.dart';
import 'package:caree/models/single_res.dart';
import 'package:dio/dio.dart';

class ChatProvider {
  Dio _client;

  ChatProvider(this._client);

  Future sendMessage(Chat chat) async {
    try {
      var data = {
        'senderId': chat.sender.id,
        'receiverId': chat.receiver.id,
        'message': chat.message
      };

      await _client.post("/chat", data: data);
    } catch (e) {
      throw e;
    }
  }

  Future<SingleResponse> getAllChatById(int id) async {
    try {
      Response response = await _client.get("/chat/$id");

      return SingleResponse<ListData>.fromJson(
          response.data,
          (json) => ListData<Chat>.fromJson(
              json, (data) => Chat.fromJson(data), 'chat'));
    } catch (e) {
      throw e;
    }
  }

  Future<SingleResponse> getAllPrivateChat(int sender, int receiver) async {
    try {
      Response response = await _client.get("/chat/$sender/$receiver");

      return SingleResponse<ListData>.fromJson(
          response.data,
          (json) => ListData<Chat>.fromJson(
              json, (data) => Chat.fromJson(data), 'chat'));
    } catch (e) {
      throw e;
    }
  }
}
