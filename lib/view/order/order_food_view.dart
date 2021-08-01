import 'dart:convert';

import 'package:caree/constants.dart';
import 'package:caree/models/chat.dart';
import 'package:caree/models/order.dart';
import 'package:caree/models/single_res.dart';
import 'package:caree/models/user.dart';
import 'package:caree/network/API.dart';
import 'package:caree/view/message/chat_screen.dart';
import 'package:caree/utils/user_secure_storage.dart';
import 'package:caree/view/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OrderFoodView extends StatefulWidget {
  const OrderFoodView({Key? key, required this.type, required this.statusOrder})
      : super(key: key);

  final String type;
  final String statusOrder;

  @override
  _OrderFoodViewState createState() => _OrderFoodViewState();
}

class _OrderFoodViewState extends State<OrderFoodView> {
  Future getAllOrder() async {
    var localUser = await UserSecureStorage.getUser();
    User user = User.fromJson(json.decode(localUser!));

    var res = await API.getAllOrderById(user.uuid!, widget.statusOrder);

    return res.data.data;
  }

  Future getAllOrdered() async {
    var localUser = await UserSecureStorage.getUser();
    User user = User.fromJson(json.decode(localUser!));

    var res = await API.getAllOrderedById(user.uuid!, widget.statusOrder);

    return res.data.data;
  }

  _deleteOrder(String orderUuid) async {
    SingleResponse res = await API.deleteOrder(orderUuid);

    if (res.success) {
      EasyLoading.showSuccess("Berhasil menolak request");
      setState(() {});
    } else {
      EasyLoading.showError(res.message);
    }
  }

  _updateOrder(Order order, String statusOrder, String msg) async {
    SingleResponse res = await API.updateOrder(order.uuid!, statusOrder);

    if (res.success) {
      EasyLoading.showSuccess(msg);
      if (widget.statusOrder == 'ONGOING') {
        Navigator.pushNamed(context, kFinishOrderRoute, arguments: order.user);
      }
    } else {
      EasyLoading.showError(res.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.type == 'myfood' ? getAllOrder() : getAllOrdered(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              List<Order> orders = snapshot.data as List<Order>;
              return orders.isNotEmpty
                  ? Container(
                      child: ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, kDetailOrder,
                                    arguments: orders[index]);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 24.0, horizontal: 18.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            '$BASE_IP/uploads/${orders[index].food!.picture}'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            orders[index].food!.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
                                          Text(
                                            orders[index].user!.fullname,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    widget.type == "myfood" &&
                                            widget.statusOrder != "FINISHED"
                                        ? Expanded(
                                            child: IconButton(
                                                onPressed: () {
                                                  _deleteOrder(
                                                      orders[index].uuid!);
                                                },
                                                icon: Icon(
                                                  Icons.do_not_disturb_rounded,
                                                  color: kSecondaryColor,
                                                )))
                                        : SizedBox(),
                                    widget.type == "myfood" &&
                                            widget.statusOrder != "FINISHED"
                                        ? Expanded(
                                            child: IconButton(
                                                onPressed: () async {
                                                  switch (widget.statusOrder) {
                                                    case 'WAITING':
                                                      _updateOrder(
                                                          orders[index],
                                                          'ONGOING',
                                                          'Berhasil Menerima Permintaan');
                                                      var chat = Chat(
                                                          sender: orders[index]
                                                              .food!
                                                              .user!,
                                                          receiver:
                                                              orders[index]
                                                                  .user!,
                                                          message: "Dari Awal");

                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (ctx) =>
                                                                  ChatScreen(
                                                                    chat: chat,
                                                                  )));
                                                      break;
                                                    case 'ONGOING':
                                                      _updateOrder(
                                                          orders[index],
                                                          'FINISHED',
                                                          'Order Selesai!');
                                                      break;
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.check,
                                                  color: kSecondaryColor,
                                                )))
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                            );
                          }))
                  : Center(
                      child: Text(
                        'Tidak ada Order',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w600),
                      ),
                    );
            }
          }

          return LoadingAnimation();
        });
  }
}
