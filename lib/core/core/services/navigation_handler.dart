import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class Go {
  static Future<T?>? to<T>(
    page,
  ) async {
    return await Get.to(page,
        transition: Transition.rightToLeft,
        curve: Curves.easeInOutQuad,
        duration: const Duration(milliseconds: 0));
  }

  static void back({dynamic data}) {
    Get.back(result: data);
  }

  static Future<T?>? off<T>(
    page,
  ) async {
    return await Get.off(page,
        transition: Transition.rightToLeft,
        curve: Curves.easeInOutQuad,
        duration: const Duration(milliseconds: 0));
  }

  static Future<T?>? offAll<T>(
    page,
  ) async {
    return await Get.offAll(page,
        curve: Curves.easeInOutQuad,
        transition: Transition.rightToLeft,
        duration: const Duration(milliseconds: 0));
  }
}
