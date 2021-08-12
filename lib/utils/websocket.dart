import 'package:caree/constants.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final channel = WebSocketChannel.connect(
  Uri.parse(SOCKET_URL),
);
