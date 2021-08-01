import 'package:caree/constants.dart';
import 'package:caree/models/chat.dart';
import 'package:flutter/material.dart';

Widget messageBody(message, user) {
  return Container(
      child: ListView.builder(
          itemCount: message.length,
          itemBuilder: (context, index) {
            Chat chat = message[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, kChatPrivateRoute,
                    arguments: chat);
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
                      offset: Offset(0, 8), // changes position of shadow
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 18.0),
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          backgroundImage: chat.receiver.picture != null
                              ? NetworkImage(
                                  "$BASE_IP/uploads/${chat.receiver.picture}")
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user!.uuid == chat.receiver.uuid
                                    ? chat.sender.fullname
                                    : chat.receiver.fullname,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              Container(
                                width: 30.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kPrimaryColor.withOpacity(0.3)),
                                child: Icon(
                                  Icons.check,
                                  size: 15,
                                  color: kPrimaryColor,
                                ),
                              )
                            ],
                          ),
                          Text(
                            '12 hours',
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor.withOpacity(0.8)),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            chat.message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12.0),
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
