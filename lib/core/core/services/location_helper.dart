import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationHelper {
  static Future<Position?> getCurrentLocation() async {
    try {
      var status = await Permission.location.status;
      log(status.toString());
      if (status.isDenied) {
        await Permission.location.request();
      }
      if (status.isPermanentlyDenied) {
        //open location permission settings
        openAppSettings();
      }

      // You can also directly ask permission about its status.
      if (await Permission.location.isRestricted) {
        await Permission.location.request();
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;
      // Try to get the last known location first
      Position? position = await Geolocator.getLastKnownPosition();

      // If no last known location, request a new one
      position ??= await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      log("Error fetching location: $e");
      return null;
    }
  }
}
