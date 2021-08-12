import 'package:caree/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as client;

class SocketClient {
  static client.Socket? _socket;

  static initialize() {
    if (_socket != null) return;

    _socket = client.io(
        SOCKET_URL,
        client.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    _socket!.connect();
  }

  static emit(String event, dynamic arguments) {
    initialize(); // Ensure it's initialized
    _socket!.emit(event, arguments ?? {});
  }

  static subscribe(String event, Function(dynamic) function) {
    initialize(); // Ensure it's initialized
    _socket!.on(event, function);
  }

  static unsubscribe(String event, Function(dynamic) function) {
    initialize(); // Ensure it's initialized
    _socket!.off(event, function);
  }

  static disconnect() {
    _socket!.disconnect();
    _socket = null;
  }
}
