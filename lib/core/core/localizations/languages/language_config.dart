import 'dart:ui';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../utils/app_constants.dart';
import '../../utils/local_storage.dart';

Future<void> getSavedLanguage() async {
  // final sharedPref = await SharedPreferences.getInstance();
  //LocalStorage localStorage = LocalStorage(prefs: preferences!);
  String res = LocalStorage.getStringFromDisk(key: LANG_key);
  var appLocal = res.isEmpty ? const Locale('ar') : Locale(res);
  await initializeDateFormatting(appLocal.languageCode);
  Intl.defaultLocale = appLocal.languageCode;
  Get.updateLocale(appLocal);
}
