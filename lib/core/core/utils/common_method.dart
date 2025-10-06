import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? preferences;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

bool get isArabic {
  return Get.locale?.languageCode == 'ar' ? true : false;
}

bool get isLandscape {
  Orientation currentOrientation = MediaQuery.of(Get.context!).orientation;
  return currentOrientation == Orientation.landscape ? true : false;
}

bool get isTablet {
  return (MediaQuery.of(Get.context!).size.width > 600 && !isLandscape)
      ? true
      : false;
}
