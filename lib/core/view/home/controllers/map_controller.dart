import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  var center = LatLng(0, 0).obs;
  var markers = <Marker>{}.obs;

  @override
  void onInit() {
    _setMarker();
    super.onInit();
  }

  void _setMarker() {
    markers.clear();
    markers.add(Marker(
      markerId: MarkerId("location"),
      position: center.value,
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  void onCameraMove(CameraPosition position) {
    center.value = position.target;
    markers.clear();
    markers.add(Marker(
      markerId: MarkerId("location"),
      position: position.target,
      icon: BitmapDescriptor.defaultMarker,
    ));
  }
}
