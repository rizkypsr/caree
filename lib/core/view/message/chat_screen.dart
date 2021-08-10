import 'package:caree/constants.dart';
import 'package:caree/core/controllers/user_controller.dart';
import 'package:caree/core/view/message/controllers/chat_controller.dart';
import 'package:caree/models/chat.dart';
import 'package:caree/network/http_client.dart';
import 'package:caree/providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController textController;
  late ScrollController _scrollController;
  var _chatProvider = ChatProvider(DioClient().init());

  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ChatController _chatController = Get.find<ChatController>();
    final UserController _userController = Get.find<UserController>();

    Chat chat = Get.arguments;

    _chatController.getAllPrivateChat(chat.sender.id, chat.receiver.id);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: kSecondaryColor,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 12.0,
              backgroundColor: Colors.white,
              backgroundImage: chat.receiver.id == _userController.user.value.id
                  ? chat.sender.picture != null
                      ? NetworkImage(
                          "$BASE_IP/uploads/${chat.receiver.picture}")
                      : AssetImage("assets/people.png") as ImageProvider
                  : chat.receiver.picture != null
                      ? NetworkImage(
                          "$BASE_IP/uploads/${chat.receiver.picture}")
                      : AssetImage("assets/people.png") as ImageProvider,
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Text(
                chat.receiver.id == _userController.user.value.id
                    ? chat.sender.fullname!
                    : chat.receiver.fullname!,
                style: TextStyle(
                  fontSize: 14.0,
                  color: kSecondaryColor,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
      ),
      body: Column(
        children: [
          Obx(() {
            if (_chatController.isLoading.value) {
              return SizedBox();
            } else {
              SchedulerBinding.instance!.addPostFrameCallback((_) {
                _scrollController.jumpTo(
                  _scrollController.position.maxScrollExtent,
                );
              });
              return Expanded(
                  child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding),
                      child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: _chatController.listChat.length,
                          itemBuilder: (context, index) {
                            if (_chatController.listChat[index].sender.id ==
                                _userController.user.value.id) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: _chatMessages(
                                    _chatController.listChat[index],
                                    CrossAxisAlignment.end),
                              );
                            } else {
                              return Align(
                                alignment: Alignment.centerLeft,
                                child: _chatMessages(
                                    _chatController.listChat[index],
                                    CrossAxisAlignment.start),
                              );
                            }
                          })));
            }
          }),
          Container(
            height: 100,
            padding: EdgeInsets.symmetric(
                vertical: kDefaultPadding / 2, horizontal: kDefaultPadding),
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: SafeArea(
              child: Row(
                children: [
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
                              var sender = chat.sender.id ==
                                      _userController.user.value.id
                                  ? chat.sender
                                  : chat.receiver;

                              var receiver = chat.sender.id !=
                                      _userController.user.value.id
                                  ? chat.sender
                                  : chat.receiver;

                              var _chat = Chat(
                                  sender: sender,
                                  receiver: receiver,
                                  message: textController.text);

                              _chatController.sendMessage(_chat);

                              _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent);

                              await _chatProvider.sendMessage(_chat);

                              textController.clear();
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

  Widget _chatMessages(Chat chat, CrossAxisAlignment crossAxisAlignment) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            DateFormat.yMMMd()
                .add_jm()
                .format(chat.createdAt != null
                    ? DateTime.parse(chat.createdAt!)
                    : DateTime.now())
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
