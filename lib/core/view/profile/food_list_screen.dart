import 'package:caree/constants.dart';
import 'package:caree/core/view/home/add_food/add_food_screen.dart';
import 'package:caree/core/view/home/controllers/food_controller.dart';
import 'package:caree/models/food.dart';
import 'package:caree/view/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodListScreen extends StatelessWidget {
  _showAlertDialog(BuildContext context, Food food) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
        child: Text(
          "Batal",
          style: TextStyle(color: Colors.grey),
        ),
        onPressed: () {
          Get.back();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ));
    Widget continueButton = ElevatedButton(
        child: Text("Hapus"),
        onPressed: () async {
          await foodController.deleteFood(food.uuid);
          Get.back();
        },
        style: ElevatedButton.styleFrom(primary: Colors.red[400]));
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Hapus Makanan"),
      content: Text("Apakah Anda yakin ingin ingin menghapus makanan ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  final FoodController foodController = Get.find<FoodController>();

  @override
  Widget build(BuildContext context) {
    foodController.getAllFoodById();

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: kSecondaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Daftar Makanan',
            style: TextStyle(color: kSecondaryColor),
          ),
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,
        ),
        body: Obx(() {
          if (foodController.isLoading.value) {
            return LoadingAnimation();
          } else {
            var food = foodController.listFoodById;
            return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: kSecondaryColor.withAlpha(100),
                    ),
                itemCount: foodController.listFoodById.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: kDefaultPadding * 0.5,
                          horizontal: kDefaultPadding),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      "$BASE_IP/uploads/${food[index].picture}",
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    food[index].name,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    food[index].description,
                                    style: TextStyle(fontSize: 11.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          food[index].order!.isEmpty
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          var data = {
                                            'mode': MODE.UPDATE,
                                            'food': food[index]
                                          };
                                          Get.toNamed(kAddFood,
                                              arguments: data);
                                        },
                                        child: Text(
                                          "Ubah Data",
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            elevation: 0,
                                            side: BorderSide(
                                                color: kPrimaryColor)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _showAlertDialog(
                                              context, food[index]);
                                        },
                                        child: Text("Hapus"),
                                        style: ElevatedButton.styleFrom(
                                            primary: Colors.red[400]),
                                      ),
                                    )
                                  ],
                                )
                              : SizedBox()
                        ],
                      ),
                    ),
                  );
                });
          }
        }));
  }
}
