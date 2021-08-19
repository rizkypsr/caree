import 'package:caree/constants.dart';
import 'package:caree/core/view/order/controllers/order_controller.dart';
import 'package:caree/core/view/widgets/loading.dart';
import 'package:caree/main.dart';
import 'package:caree/models/chat.dart';
import 'package:caree/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

class OrderFoodView extends StatefulWidget {
  const OrderFoodView({Key? key, required this.type, required this.statusOrder})
      : super(key: key);

  final String type;
  final String statusOrder;

  @override
  _OrderFoodViewState createState() => _OrderFoodViewState();
}

class _OrderFoodViewState extends State<OrderFoodView> {
  final OrderController _orderController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.type == 'myfood'
            ? _orderController.getAllOrder(widget.statusOrder)
            : _orderController.getAllOrdered(widget.statusOrder),
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
                                Get.toNamed(kDetailOrder,
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
                                            '$BASE_IP/${orders[index].food!.picture}'),
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
                                            orders[index].user!.fullname!,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                    widget.type == "myfood" &&
                                            widget.statusOrder != "FINISHED"
                                        ? Expanded(
                                            child: IconButton(
                                            onPressed: () async {
                                              var res = await _orderController
                                                  .deleteOrder(
                                                      orders[index].id!);

                                              if (res.success) {
                                                widget.type == 'myfood'
                                                    ? _orderController
                                                        .getAllOrder(
                                                            widget.statusOrder)
                                                    : _orderController
                                                        .getAllOrdered(
                                                            widget.statusOrder);

                                                setState(() {});
                                              } else {
                                                EasyLoading.showError(
                                                    "Terjadi kesalahan!");
                                              }
                                            },
                                            icon: widget.statusOrder ==
                                                    "WAITING"
                                                ? Showcase(
                                                    key: KeysToBeIherited.of(
                                                            context)!
                                                        .declineFood,
                                                    description:
                                                        "Klik disini untuk menolak pesanan atau membatalkan pesanan jika kamu berada pada tab pengambilan",
                                                    child: Icon(
                                                      Icons
                                                          .do_not_disturb_rounded,
                                                      color: kSecondaryColor,
                                                    ),
                                                  )
                                                : Icon(
                                                    Icons
                                                        .do_not_disturb_rounded,
                                                    color: kSecondaryColor,
                                                  ),
                                          ))
                                        : SizedBox(),
                                    widget.type == "myfood" &&
                                            widget.statusOrder != "FINISHED"
                                        ? Expanded(
                                            child: IconButton(
                                            onPressed: () async {
                                              switch (widget.statusOrder) {
                                                case 'WAITING':
                                                  var res =
                                                      await _orderController
                                                          .updateOrder(
                                                              orders[index],
                                                              'ONGOING');

                                                  if (res.success) {
                                                    EasyLoading.showSuccess(
                                                        'Berhasil Menerima Permintaan');
                                                  } else {
                                                    EasyLoading.showError(
                                                        res.message);
                                                  }

                                                  var chat = Chat(
                                                      sender: orders[index]
                                                          .food!
                                                          .user!,
                                                      receiver:
                                                          orders[index].user!,
                                                      message: "Dari Awal");

                                                  Get.toNamed(kChatPrivateRoute,
                                                      arguments: chat);

                                                  break;
                                                case 'ONGOING':
                                                  var res =
                                                      await _orderController
                                                          .updateOrder(
                                                              orders[index],
                                                              'FINISHED');

                                                  if (res.success) {
                                                    EasyLoading.showSuccess(
                                                        'Pesanan selesai!');
                                                    Get.toNamed(
                                                        kFinishOrderRoute,
                                                        arguments:
                                                            orders[index].user);
                                                  } else {
                                                    EasyLoading.showError(
                                                        res.message);
                                                  }
                                                  break;
                                              }
                                            },
                                            icon: widget.statusOrder ==
                                                    "WAITING"
                                                ? Showcase(
                                                    key: KeysToBeIherited.of(
                                                            context)!
                                                        .acceptFood,
                                                    description:
                                                        "Klik disini untuk menerima pesanan atau menyelesaikan pesanan jika kamu berada pada tab pengambilan.",
                                                    child: Icon(
                                                      Icons.check,
                                                      color: kSecondaryColor,
                                                    ),
                                                  )
                                                : Icon(
                                                    Icons.check,
                                                    color: kSecondaryColor,
                                                  ),
                                          ))
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
