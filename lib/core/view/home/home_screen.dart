import 'package:caree/constants.dart';
import 'package:caree/core/controllers/network_controller.dart';
import 'package:caree/core/view/home/add_food/add_food_screen.dart';
import 'package:caree/core/view/home/widgets/list_food.dart';
import 'package:caree/core/view/widgets/no_internet.dart';
import 'package:caree/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:showcaseview/showcaseview.dart';

class HomeScreen extends StatelessWidget {
  final NetworkController _networkController = Get.find<NetworkController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: Showcase(
        key: KeysToBeIherited.of(context)!.addFoodKey,
        description: "Klik disini untuk membagikan makanan",
        child: FloatingActionButton(
          onPressed: () {
            var data = {'mode': MODE.SAVE, 'food': null};
            Get.toNamed(kAddFood, arguments: data);
          },
          child: Icon(Icons.add),
          backgroundColor: kPrimaryColor,
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                'Cari \nMakanan Gratis',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Obx(() {
                if (_networkController.connectionStatus.value == 1 ||
                    _networkController.connectionStatus.value == 2) {
                  return ListFood();
                } else {
                  return NoInternetScreen();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
