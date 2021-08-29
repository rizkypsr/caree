import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:caree/constants.dart';
import 'package:caree/core/view/home/controllers/food_controller.dart';
import 'package:caree/core/view/home/controllers/map_controller.dart';
import 'package:caree/models/address_point.dart';
import 'package:caree/models/food.dart';
import 'package:caree/models/user.dart';
import 'package:caree/utils/user_secure_storage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

enum MODE { SAVE, UPDATE }

class AddFoodScreen extends StatefulWidget {
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _foodDescController = TextEditingController();
  final TextEditingController _foodPickupTimeController =
      TextEditingController();
  final Completer<GoogleMapController> _googleMapController = Completer();
  final MapController mapController = Get.find<MapController>();
  final FoodController foodController = Get.find<FoodController>();

  void getImageFromGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 40);

    if (pickedFile != null) {
      foodController.imagePath.value = pickedFile.path;

      Get.back();
    }
  }

  _getImageFromCamera() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    if (pickedFile != null) {
      foodController.imagePath.value = pickedFile.path;

      Get.back();
    }
  }

  _saveFood() async {
    AddressPoint addressPoint = AddressPoint(type: 'Point', coordinates: [
      mapController.center.value.latitude,
      mapController.center.value.longitude
    ]);
    var foodName = _foodNameController.text;
    var foodDesc = _foodDescController.text;
    var foodPickupTimes = _foodPickupTimeController.text;

    if (foodName.isNotEmpty &&
        foodDesc.isNotEmpty &&
        foodPickupTimes.isNotEmpty &&
        foodController.imagePath.isNotEmpty &&
        mapController.center.value.latitude != 0.0) {
      var localUser = await UserSecureStorage.getUser();
      var user = User.fromJson(json.decode(localUser!));

      var food = Food(
          name: foodName,
          description: foodDesc,
          pickupTimes: foodPickupTimes,
          addressPoint: addressPoint,
          user: user);

      var res =
          await foodController.saveFood(food, foodController.imagePath.value);

      if (res.success) {
        EasyLoading.showSuccess("Makanan berhasil dibagikan !");
        Get.back();
      } else {
        EasyLoading.showError(res.message);
      }
    } else {
      EasyLoading.showError("Pastikan semua data terisi!");
    }
  }

  Future<void> updateMapPosition(LatLng position) async {
    final GoogleMapController controller = await _googleMapController.future;
    mapController.center.value = position;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 18)));
  }

  _updateFood(food) async {
    var foodName = _foodNameController.text;
    var foodDesc = _foodDescController.text;
    var foodPickupTimes = _foodPickupTimeController.text;

    AddressPoint addressPoint = AddressPoint(type: 'Point', coordinates: [
      mapController.center.value.latitude,
      mapController.center.value.longitude
    ]);

    if (foodName.isNotEmpty &&
        foodDesc.isNotEmpty &&
        foodPickupTimes.isNotEmpty &&
        mapController.center.value.latitude != 0.0) {
      var _food = Food(
        id: food.id,
        name: foodName,
        description: foodDesc,
        pickupTimes: foodPickupTimes,
        addressPoint: addressPoint,
      );

      var res = await foodController.updateFood(_food);

      if (res.success) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess("Berhasil memperbaharui makanan !");
        Get.back();
      } else {
        EasyLoading.showError(res.message);
      }
    } else {
      EasyLoading.showError("Pastikan semua data terisi!");
    }
  }

  @override
  void dispose() {
    foodController.resetImagePath();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var data = Get.arguments;

    if (data['food'] != null) {
      _foodNameController.text = data['food']!.name;
      _foodDescController.text = data['food']!.description;
      _foodPickupTimeController.text = data['food']!.pickupTimes;
      var position = LatLng(data['food']!.addressPoint!.coordinates[0],
          data['food']!.addressPoint!.coordinates[1]);
      updateMapPosition(position);
    }

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
          'Bagikan Makanan',
          style: TextStyle(color: kSecondaryColor),
        ),
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return GestureDetector(
                  onTap: () {
                    Get.bottomSheet(Container(
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: new Icon(Icons.camera),
                            title: new Text('Kamera'),
                            onTap: () {
                              _getImageFromCamera();
                            },
                          ),
                          ListTile(
                            leading: new Icon(Icons.photo),
                            title: new Text('Galeri'),
                            onTap: () {
                              getImageFromGallery();
                            },
                          ),
                        ],
                      ),
                    ));
                  },
                  child: DottedBorder(
                    color: kSecondaryColor,
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(color: Color(0xFFFCFCFF)),
                      child: foodController.imagePath.value.isNotEmpty
                          ? Image.file(
                              File(foodController.imagePath.value),
                              fit: BoxFit.cover,
                            )
                          : data['food'] != null
                              ? Image.network(
                                  "$BASE_IP/${data['food'].picture}",
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.image,
                                  size: 80,
                                ),
                    ),
                  ),
                );
              }),
              SizedBox(
                height: 12.0,
              ),
              TextField(
                controller: _foodNameController,
                style: TextStyle(color: kSecondaryColor),
                decoration: InputDecoration(
                    labelText: 'Nama Makanan',
                    labelStyle: TextStyle(
                        color: kSecondaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kSecondaryColor))),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: _foodDescController,
                style: TextStyle(color: kSecondaryColor),
                decoration: InputDecoration(
                    labelText: 'Deskripsi',
                    labelStyle: TextStyle(
                        color: kSecondaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kSecondaryColor))),
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: _foodPickupTimeController,
                style: TextStyle(color: kSecondaryColor),
                decoration: InputDecoration(
                    labelText: 'Waktu Pengambilan',
                    labelStyle: TextStyle(
                        color: kSecondaryColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: kSecondaryColor))),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.toNamed(kMapRoute)!.then((_) {
                          updateMapPosition(mapController.center.value);
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: kDefaultPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pilih lokasi kamu berada',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios)
                            ],
                          )),
                    ),
                    Obx(() {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        child: GoogleMap(
                            onMapCreated: (controller) {
                              _googleMapController.complete(controller);
                            },
                            markers: mapController.markers,
                            myLocationButtonEnabled: false,
                            initialCameraPosition: CameraPosition(
                                target: mapController.center.value, zoom: 18)),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    onPressed: () {
                      switch (data['mode']) {
                        case MODE.SAVE:
                          _saveFood();
                          break;
                        case MODE.UPDATE:
                          _updateFood(data['food']);
                          break;
                      }
                    },
                    child: Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                        primary: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
