import 'package:caree/models/order.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:caree/constants.dart';

class MyOrderView extends StatefulWidget {
  const MyOrderView({Key? key, required this.orders}) : super(key: key);

  final List<Order> orders;

  @override
  _MyOrderViewState createState() => _MyOrderViewState();
}

class _MyOrderViewState extends State<MyOrderView> {
  final storage = FlutterSecureStorage();
  late final jwt;

  _getJwt() async {
    var getJwt = await storage.read(key: "jwt");
    setState(() {
      jwt = getJwt;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.orders.isNotEmpty
        ? Container(
            child: ListView.builder(
                itemCount: widget.orders.length, itemBuilder: _listContents))
        : Center(
            child: Text('No Item'),
          );
  }

  Widget _listContents(BuildContext context, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 18.0),
        child: Row(
          children: [
            Expanded(
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    '$SERVER_IP/uploads/${widget.orders[index].food!.picture}'),
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.orders[index].user!.fullname,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Text(
              "Menunggu Konfirmasi",
              style: TextStyle(fontSize: 12.0),
            )),
          ],
        ),
      ),
    );
  }
}
