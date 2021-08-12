import 'package:caree/constants.dart';
import 'package:caree/core/controllers/user_controller.dart';
import 'package:caree/core/view/message/controllers/message_controller.dart';
import 'package:caree/core/view/widgets/loading.dart';
import 'package:caree/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MessageController _messageController = Get.find<MessageController>();
    final UserController _userController = Get.find<UserController>();

    _messageController.getAllChatById();

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
        body: Obx(() {
          if (_messageController.isLoading.value) {
            return LoadingAnimation();
          } else {
            return Container(
                child: ListView.builder(
                    itemCount: _messageController.listChat.length,
                    itemBuilder: (context, index) {
                      Chat chat = _messageController.listChat[index];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(kChatPrivateRoute, arguments: chat)!
                              .then((_) {
                            _messageController.getAllChatById();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: kDefaultPadding),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff7090B0).withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 24,
                                offset:
                                    Offset(0, 8), // changes position of shadow
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 24.0, horizontal: 18.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 25,
                                    backgroundColor: Colors.white,
                                    backgroundImage: chat.receiver.picture !=
                                            null
                                        ? NetworkImage(
                                            "$BASE_IP/${chat.receiver.picture}")
                                        : AssetImage("assets/people.png")
                                            as ImageProvider,
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _userController.user.value.id ==
                                              chat.receiver.id
                                          ? chat.sender.fullname!
                                          : chat.receiver.fullname!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    SizedBox(
                                      height: 15.0,
                                    ),
                                    Text(
                                      chat.message,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12.0),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }));
          }
        }));
  }
}
