import 'package:caree/constants.dart';
import 'package:caree/view/order/order_food_view.dart';
import 'package:flutter/material.dart';

class NestedTabBarView extends StatefulWidget {
  const NestedTabBarView({Key? key, required this.statusOrder})
      : super(key: key);

  final String statusOrder;

  @override
  _NestedTabBarViewState createState() => _NestedTabBarViewState();
}

class _NestedTabBarViewState extends State<NestedTabBarView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
            centerTitle: true,
            backgroundColor: Color(0xFFFAFAFA),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: TabBar(
                labelColor: kSecondaryColor,
                indicatorColor: kSecondaryColor,
                controller: _tabController,
                isScrollable: true,
                tabs: [
                  Tab(
                    text: 'Makanan kamu',
                  ),
                  Tab(
                    text: 'Makanan Yang kamu pesan',
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              OrderFoodView(type: "myfood", statusOrder: widget.statusOrder),
              OrderFoodView(type: "myorder", statusOrder: widget.statusOrder),
            ],
            controller: _tabController,
          ),
        ));
  }
}
