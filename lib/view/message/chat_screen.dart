import 'dart:convert';

import 'package:caree/constants.dart';
import 'package:caree/models/chat.dart';
import 'package:caree/models/user.dart';
import 'package:caree/network/API.dart';
import 'package:caree/utils/socket.dart';
import 'package:caree/utils/user_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.chat}) : super(key: key);

  final Chat chat;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController textController;
  late ScrollController _scrollController;

  User? _user;

  List<String> messages = [];
  List<Chat> listChat = [];

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    _scrollController = ScrollController();
    _readUserData();
    _getAllPrivateChat();
    _socket();
  }

  @override
  void dispose() {
    textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<Null> _readUserData() async {
    final userData = await UserSecureStorage.getUser();

    _user = User.fromJson(json.decode(userData!));
  }

  sendMessage(Chat chat) {
    setMessage(chat);

    SocketClient.emit("send_message", {
      "sender": chat.sender,
      "receiver": chat.receiver,
      "message": chat.message
    });
  }

  setMessage(Chat chat) {
    if (mounted) {
      setState(() {
        listChat.add(chat);
      });
    }
  }

  _getAllPrivateChat() async {
    var localUser = await UserSecureStorage.getUser();
    User user = User.fromJson(json.decode(localUser!));

    var receiver = widget.chat.sender.uuid != user.uuid
        ? widget.chat.sender.uuid
        : widget.chat.receiver.uuid;

    await API.getAllPrivateChat(user.uuid!, receiver!).then((response) {
      var listData = response.data.data;

      setState(() {
        listData.forEach((chat) {
          setMessage(chat);
        });
      });
    });
  }

  _socket() {
    SocketClient.initialize();

    if (_user != null) {
      SocketClient.emit('user_connected', _user!.uuid);
    }

    SocketClient.subscribe("new_message", (data) {
      Chat incomingChat = Chat.fromJson(data);

      setMessage(incomingChat);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user != null) {
      SchedulerBinding.instance!.addPostFrameCallback((_) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      });
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: kSecondaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 12.0,
                backgroundColor: Colors.white,
                backgroundImage: widget.chat.receiver.uuid == _user!.uuid
                    ? widget.chat.sender.picture != null
                        ? NetworkImage(
                            "$BASE_IP/uploads/${widget.chat.receiver.picture}")
                        : AssetImage("assets/people.png") as ImageProvider
                    : widget.chat.receiver.picture != null
                        ? NetworkImage(
                            "$BASE_IP/uploads/${widget.chat.receiver.picture}")
                        : AssetImage("assets/people.png") as ImageProvider,
              ),
              SizedBox(
                width: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chat.receiver.uuid == _user!.uuid
                        ? widget.chat.sender.fullname
                        : widget.chat.receiver.fullname,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: kSecondaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: listChat.length,
                        itemBuilder: (context, index) {
                          if (listChat[index].sender.uuid == _user!.uuid) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: _chatMessages(
                                  listChat[index], CrossAxisAlignment.end),
                            );
                          } else {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: _chatMessages(
                                  listChat[index], CrossAxisAlignment.start),
                            );
                          }
                        }))),
            Container(
              height: 100,
              padding: EdgeInsets.symmetric(
                  vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: SafeArea(
                child: Row(
                  children: [
                    Icon(Icons.mic, color: kPrimaryColor),
                    SizedBox(
                      width: kDefaultPadding,
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.symmetric(
                            horizontal: kDefaultPadding * 0.75),
                        decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(40)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.sentiment_satisfied_alt_outlined,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                            SizedBox(
                              width: kDefaultPadding / 4,
                            ),
                            Expanded(
                              child: TextField(
                                controller: textController,
                                decoration: InputDecoration(
                                    hintText: 'Type message',
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: IconButton(
                            onPressed: () async {
                              if (textController.text.isNotEmpty) {
                                var sender =
                                    widget.chat.sender.uuid == _user!.uuid
                                        ? widget.chat.sender
                                        : widget.chat.receiver;

                                var receiver =
                                    widget.chat.sender.uuid != _user!.uuid
                                        ? widget.chat.sender
                                        : widget.chat.receiver;

                                var chat = Chat(
                                    sender: sender,
                                    receiver: receiver,
                                    message: textController.text);

                                sendMessage(chat);

                                _scrollController.jumpTo(
                                    _scrollController.position.maxScrollExtent);

                                API.sendMessage(chat).then((_) {
                                  textController.clear();
                                });
                              }
                            },
                            icon: Icon(Icons.send)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _chatMessages(Chat chat, CrossAxisAlignment crossAxisAlignment) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            DateFormat.yMMMd()
                .add_jm()
                .format(DateTime.parse(chat.createdAt!))
                .toString(),
            style: TextStyle(color: kSecondaryColor.withOpacity(0.5)),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: kDefaultPadding * 0.75,
                vertical: kDefaultPadding / 2),
            decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0),
                )),
            child: Text(chat.message, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     Container(
      //       padding: EdgeInsets.symmetric(
      //           horizontal: kDefaultPadding * 0.75,
      //           vertical: kDefaultPadding / 2),
      //       decoration: BoxDecoration(
      //           color: kPrimaryColor,
      //           borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(40.0),
      //             topRight: Radius.circular(40.0),
      //             bottomRight: Radius.circular(40.0),
      //           )),
      //       child: Text(message, style: TextStyle(color: Colors.white)),
      //     ),
      //     Container(
      //       margin: EdgeInsets.only(left: kDefaultPadding / 3),
      //       height: 12,
      //       width: 12,
      //       decoration:
      //           BoxDecoration(shape: BoxShape.circle, color: kPrimaryColor),
      //       child: Icon(
      //         Icons.done,
      //         size: 8,
      //         color: Theme.of(context).scaffoldBackgroundColor,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
