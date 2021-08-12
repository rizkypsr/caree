import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String appleUrl = "https://maps.apple.com/?q=$latitude,$longitude";

    if (Platform.isAndroid) {
      if (await canLaunch(googleUrl)) {
        await launch(googleUrl);
      } else {
        EasyLoading.showError(
            'Tidak bisa membuka Google Maps. Pastikan Google Maps Anda up to date');
      }
    } else if (Platform.isIOS) {
      if (await canLaunch(appleUrl)) {
        await launch(appleUrl);
      } else {
        EasyLoading.showError(
            'Tidak bisa membuka Google Maps. Pastikan Google Maps Anda up to date');
      }
    }
  }
}
