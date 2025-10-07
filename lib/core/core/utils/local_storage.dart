import '../../core/utils/app_constants.dart';
import '../../core/utils/common_method.dart';

class LocalStorage {
  LocalStorage._();
  /* static final LocalStorage _localStorage = LocalStorage._();
  LocalStorage._() {
    _init();
  }
  factory LocalStorage() {
    return _localStorage;
  }
  _init() async {
    prefs = await SharedPreferences.getInstance();
  } */

  /* late SharedPreferences prefs;
  LocalStorage({
    required this.prefs,
  }); */
  //LocalStorage({required this.prefs});
  /// Write
  static Future<bool> saveStringToDisk({
    required String key,
    required String value,
  }) async {
    return await preferences!.setString(key, value);
  }

  static Future<bool> saveBoolToDisk({
    required String key,
    required bool value,
  }) async {
    return await preferences!.setBool(key, value);
  }

  /// Read
  static String getStringFromDisk({required String key}) {
    return preferences!.getString(key) ?? '';
  }

  /// Read
  static bool getBoolFromDisk({required String key}) {
    return preferences!.getBool(key) ?? false;
  }

  static bool getBoolValid({required String key}) {
    return preferences!.getBool(key) ?? false;
  }

  static Future<bool> removeValueFromDisk({required String key}) async {
    return await preferences!.remove(key);
  }

  static Future<bool> removeAllFromDisk() async {
    await preferences!.remove(TYPEVENDOR);
    return await preferences!.remove(TOKEN);
  }

  static String getTokenFromCache() => getStringFromDisk(key: TOKEN);
}
