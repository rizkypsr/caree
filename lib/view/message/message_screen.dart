import 'dart:convert';

import 'package:caree/constants.dart';
import 'package:caree/models/chat.dart';
import 'package:caree/models/user.dart';
import 'package:caree/network/API.dart';
import 'package:caree/utils/socket.dart';
import 'package:caree/utils/user_secure_storage.dart';
import 'package:caree/view/widgets/loading.dart';
import 'package:flutter/material.dart';

import 'widgets/message_body.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<Chat> listChat = [];
  User? _user;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    SocketClient.disconnect();
    super.dispose();
  }

  Future getAllChatById() async {
    var localUser = await UserSecureStorage.getUser();
    User user = User.fromJson(json.decode(localUser!));

    var res = await API.getAllChatById(user.uuid!);

    _user = user;

    _socket();

    return res.data.data;
  }

  _socket() {
    SocketClient.initialize();

    SocketClient.emit('user_connected', _user!.uuid);

    SocketClient.subscribe("new_message", (data) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pesan',
          style: TextStyle(color: kSecondaryColor),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
      ),
      body: FutureBuilder(
        future: getAllChatById(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              return messageBody(snapshot.data, _user);
            }
          }

          return LoadingAnimation();
        },
      ),
    );
  }
}
