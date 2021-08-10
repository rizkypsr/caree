import 'package:caree/core/view/order/nested_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:caree/constants.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFAFAFA),
            title: Text(
              'Pemesanan',
              style: TextStyle(color: kSecondaryColor),
            ),
            centerTitle: true,
            bottom: TabBar(
              labelColor: kSecondaryColor,
              indicatorColor: kSecondaryColor,
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(
                  text: 'Konfirmasi',
                ),
                Tab(
                  text: 'Pengambilan',
                ),
                Tab(
                  text: 'Selesai',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              NestedTabBarView(statusOrder: "WAITING"),
              NestedTabBarView(statusOrder: "ONGOING"),
              NestedTabBarView(statusOrder: "FINISHED")
            ],
            controller: _tabController,
          ),
        ));
  }
}
