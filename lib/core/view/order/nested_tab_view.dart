import 'package:caree/constants.dart';
import 'package:caree/core/view/order/order_food_view.dart';
import 'package:caree/main.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

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
                  widget.statusOrder == "WAITING"
                      ? Showcase(
                          key: KeysToBeIherited.of(context)!.myFoodKey,
                          description:
                              "Disini tempat menampilkan daftar pengguna yang memesan makananmu",
                          child: Tab(
                            text: 'Makanan kamu',
                          ),
                        )
                      : Tab(
                          text: 'Makanan kamu',
                        ),
                  widget.statusOrder == "WAITING"
                      ? Showcase(
                          key: KeysToBeIherited.of(context)!.myOrderFood,
                          description:
                              "Disini tempat menampilkan daftar makanan yang kamu pesan",
                          child: Tab(
                            text: 'Makanan yang kamu pesan',
                          ),
                        )
                      : Tab(
                          text: 'Makanan yang kamu pesan',
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
