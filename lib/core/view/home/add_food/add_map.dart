import 'dart:async';

import 'package:caree/constants.dart';
import 'package:caree/core/view/home/controllers/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;

class AddMapScreen extends StatelessWidget {
  final Completer<GoogleMapController> _googleMapcontroller = Completer();
  final MapController mapController = Get.find<MapController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        return Container(
          child: Stack(
            children: [
              GoogleMap(
                  onMapCreated: (controller) {
                    _googleMapcontroller.complete(controller);
                  },
                  markers: mapController.markers,
                  onCameraMove: mapController.onCameraMove,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                      target: mapController.center.value, zoom: 18)),
              SafeArea(
                  child: Container(
                margin: EdgeInsets.only(
                    left: kDefaultPadding * 0.5, top: kDefaultPadding * 0.5),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios_new)),
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: SizedBox(
                    width: Platform.isIOS ? 200 : double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text("Pilih Lokasi"),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(kPrimaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )))),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
