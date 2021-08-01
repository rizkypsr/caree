import 'package:caree/constants.dart';
import 'package:caree/core/view/home/controllers/food_controller.dart';
import 'package:caree/view/home/widget/empty_state.dart';
import 'package:caree/view/widgets/loading.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ListFood extends StatelessWidget {
  final FoodController _foodController = Get.find<FoodController>();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await _foodController.fetchListFood();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _foodController.isLoading.value
          ? Center(child: LoadingAnimation())
          : _foodController.listFood.isNotEmpty
              ? SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: ListView.builder(
                      itemCount: _foodController.listFood.length,
                      itemBuilder: (context, index) {
                        String _meterToKilo(double m) {
                          return (m / 1000).toStringAsFixed(1);
                        }

                        String getFirstWords(String sentence, int wordCounts) {
                          return sentence
                              .split(" ")
                              .sublist(0, wordCounts)
                              .join(" ");
                        }

                        return InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 24.0, horizontal: 26.0),
                            child: Row(
                              children: <Widget>[
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 90,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                "$BASE_IP/uploads/${_foodController.listFood[index].picture}")),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -15,
                                      child: Container(
                                        height: 35,
                                        width: 90,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                blurRadius: 4,
                                                offset: Offset(0, 1),
                                                spreadRadius: 0,
                                              ),
                                            ]),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.location_on_rounded,
                                              color: Color(0xFF292D33),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Text(
                                              "${_meterToKilo(_foodController.listFood[index].distance!)} km",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 240,
                                        child: Text(
                                          _foodController.listFood[index].name,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: kSecondaryColor,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        _foodController
                                            .listFood[index].description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: kSecondaryColor,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: DottedLine(
                                          lineLength: 240.0,
                                          dashColor:
                                              Colors.black.withOpacity(0.2),
                                        ),
                                      ),
                                      Container(
                                        child: Wrap(
                                          spacing: 6.0,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 12.0,
                                              backgroundColor: Colors.white,
                                              backgroundImage: _foodController
                                                          .listFood[index]
                                                          .user!
                                                          .picture !=
                                                      null
                                                  ? NetworkImage(
                                                      "$BASE_IP/uploads/${_foodController.listFood[index].user!.picture}")
                                                  : AssetImage(
                                                          "assets/people.png")
                                                      as ImageProvider,
                                            ),
                                            Text(
                                              getFirstWords(
                                                  _foodController
                                                      .listFood[index]
                                                      .user!
                                                      .fullname,
                                                  1),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10.0),
                                            ),
                                            Container(
                                              width: 5.0,
                                              height: 5.0,
                                              decoration: BoxDecoration(
                                                  color: kSecondaryColor,
                                                  shape: BoxShape.circle),
                                            ),
                                            Wrap(
                                              spacing: 3.0,
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.star,
                                                  color: Color(0xFFF7CA63),
                                                  size: 20,
                                                ),
                                                Text(
                                                  _foodController
                                                              .listFood[index]
                                                              .user!
                                                              .ratingAvg ==
                                                          null
                                                      ? "User Baru"
                                                      : double.parse(
                                                              _foodController
                                                                  .listFood[
                                                                      index]
                                                                  .user!
                                                                  .ratingAvg!)
                                                          .toStringAsFixed(1)
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 10.0),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              : emptyState(context);
    });
  }
}
