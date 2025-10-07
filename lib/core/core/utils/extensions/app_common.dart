import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../..//utils/app_constants.dart';
import '../..//utils/extensions/boolean_extension.dart';
import '../..//utils/size_utils.dart';

import '../../enums/toast_enum.dart';
import '../../theme/colors.dart';
import 'string_extensions.dart';
// import 'package:google_fonts/google_fonts.dart';

InputDecoration inputDecoration(
  BuildContext context, {
  String? label,
  bool? floatingLable,
  Widget? prefixIcon,
  Widget? suffixIcon,
  Color? borderColor,
  Color? focusedBorderColor,
  Color? fillColor,
  double? borderRad,
  String? hintText,
  double? borderWidth,
  EdgeInsets? padding,
  TextStyle? hintStyle,
}) {
  return InputDecoration(
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,

    hintText: hintText ?? "",
    prefixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
    suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
    //contentPadding: EdgeInsets.only(bottom: 8),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRad ?? defaultRadius),
      borderSide: BorderSide(
        //color: borderColor ?? AppColors.gray4Color,
        width: borderWidth ?? 1,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRad ?? defaultRadius),
      borderSide: BorderSide(
        color: borderColor ?? AppColors.gray4Color,
        width: borderWidth ?? 1,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRad ?? defaultRadius),
      borderSide: BorderSide(
        color: borderColor ?? AppColors.gray4Color,
        width: borderWidth ?? 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRad ?? defaultRadius),
      borderSide: BorderSide(
        color: focusedBorderColor ?? AppColors.gray4Color,
        width: borderWidth ?? 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRad ?? defaultRadius),
      borderSide: BorderSide(
        color: borderColor ?? AppColors.gray4Color,
        width: borderWidth ?? 1,
      ),
    ),
    alignLabelWithHint: true,
    floatingLabelBehavior: floatingLable.validate()
        ? FloatingLabelBehavior.always
        : FloatingLabelBehavior.auto,
    filled: true,
    isDense: true,
    contentPadding: padding,
    fillColor: fillColor ?? AppColors.gray9Color,
    labelText: label,
    labelStyle: primaryTextFeildTextStyle(),
    hintStyle: hintStyle,
  );
}

TextStyle boldTextStyle({
  double? size,
  Color? color,
  FontWeight? weight,
  double? height,
}) {
  return TextStyle(
    fontSize: size ?? textBoldSizeGlobal,
    color: color ?? textPrimaryColorGlobal,
    fontWeight: weight ?? FontWeight.bold,
    height: height,
  );
}

TextStyle normalTextStyle({
  double? size,
  Color? color,
  FontWeight? weight,
  double? height,
}) {
  return TextStyle(
    fontSize: size ?? textBoldSizeGlobal,
    color: color ?? textPrimaryColorGlobal,
    fontWeight: weight ?? FontWeight.w400,
    height: height,
  );
}

TextStyle primaryTextFeildTextStyle({
  double? size,
  Color? color,
  FontWeight? weight,
  double? height,
}) {
  return TextStyle(
    fontSize: size ?? textPrimarySizeGlobal,
    color: color ?? textPrimaryColorGlobal,
    fontWeight: weight ?? FontWeight.normal,
    height: height,
  );
}

// Primary Text Style
TextStyle primaryTextStyle({
  double? size,
  Color? color,
  FontWeight? weight,
  double? height,
}) {
  return TextStyle(
    fontSize: size ?? textPrimarySizeGlobal,
    color: color ?? textPrimaryColorGlobal,
    fontWeight: weight ?? FontWeight.normal,
    height: height,
  );
}

// Secondary Text Style
TextStyle secondaryTextStyle({
  double? size,
  Color? color,
  FontWeight? weight,
  double? height,
}) {
  return TextStyle(
    fontSize: size ?? textSecondarySizeGlobal,
    color: color ?? textSecondaryColorGlobal,
    fontWeight: weight ?? FontWeight.normal,
    height: height,
  );
}

String getDateFormat(String? date) {
  if (date != null && date.isNotEmpty) {
    return DateFormat(
      'dd MMM yyyy - hh:mm a',
      Get.locale?.languageCode,
    ).format(DateTime.parse(date).toLocal());
  } else {
    return '';
  }
}

String getDateFormatDateOnly(String? date) {
  if (date != null && date.isNotEmpty) {
    return DateFormat(
      'dd MMM yyyy ',
      Get.locale?.languageCode,
    ).format(DateTime.parse(date).toLocal());
  } else {
    return '';
  }
}

var outputFormat = DateFormat(
  'dd MMM yyyy - hh:mm a',
  Get.locale?.languageCode,
);

void log(final value) {
  if (!kReleaseMode) dev.log('$value');
}

bool hasMatch(String? s, String p) {
  return (s == null) ? false : RegExp(p).hasMatch(s);
}

Color getColorFromHex(
  String hexColor, {
  Color defaultColor = AppColors.orangColor,
}) {
  if (hexColor.isEmpty) {
    return defaultColor;
  }

  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  } else {
    return defaultColor;
  }
  if (int.tryParse(hexColor, radix: 16) != null) {
    return Color(int.parse(hexColor, radix: 16));
  } else {
    return defaultColor;
  }
}

void toast(
  String? value, {
  ToastGravity? gravity,
  length = Toast.LENGTH_SHORT,
  Color? bgColor,
  Color? textColor,
  bool print = false,
}) {
  if (value!.isEmpty || (!kIsWeb && Platform.isLinux)) {
    log(value);
  } else {
    Fluttertoast.showToast(
      msg: value.validate(),
      gravity: gravity,
      toastLength: length,
      backgroundColor: bgColor,
      textColor: textColor,
      timeInSecForIosWeb: 2,
    );
    if (print) log(value);
  }
}

/// Launch a new screen
Future<T?> launchScreen<T>(
  BuildContext context,
  Widget child, {
  bool isNewTask = false,
  PageRouteAnimation? pageRouteAnimation,
  Duration? duration,
}) async {
  if (isNewTask) {
    return await Navigator.of(context).pushAndRemoveUntil(
      buildPageRoute(child, pageRouteAnimation, duration),
      (route) => false,
    );
  } else {
    return await Navigator.of(
      context,
    ).push(buildPageRoute(child, pageRouteAnimation, duration));
  }
}

// ignore: constant_identifier_names
enum PageRouteAnimation { Fade, Scale, Rotate, Slide, SlideBottomTop }

Route<T> buildPageRoute<T>(
  Widget? child,
  PageRouteAnimation? pageRouteAnimation,
  Duration? duration,
) {
  if (pageRouteAnimation != null) {
    if (pageRouteAnimation == PageRouteAnimation.Fade) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child!,
        transitionsBuilder: (c, anim, a2, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 1000),
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Rotate) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child!,
        transitionsBuilder: (c, anim, a2, child) =>
            RotationTransition(turns: ReverseAnimation(anim), child: child),
        transitionDuration: const Duration(milliseconds: 700),
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Scale) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child!,
        transitionsBuilder: (c, anim, a2, child) =>
            ScaleTransition(scale: anim, child: child),
        transitionDuration: const Duration(milliseconds: 700),
      );
    } else if (pageRouteAnimation == PageRouteAnimation.Slide) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child!,
        transitionsBuilder: (c, anim, a2, child) => SlideTransition(
          position: Tween(
            begin: const Offset(1.0, 0.0),
            end: const Offset(0.0, 0.0),
          ).animate(anim),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 500),
      );
    } else if (pageRouteAnimation == PageRouteAnimation.SlideBottomTop) {
      return PageRouteBuilder(
        pageBuilder: (c, a1, a2) => child!,
        transitionsBuilder: (c, anim, a2, child) => SlideTransition(
          position: Tween(
            begin: const Offset(0.0, 1.0),
            end: const Offset(0.0, 0.0),
          ).animate(anim),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 500),
      );
    }
  }
  return MaterialPageRoute<T>(builder: (_) => child!);
}

/// Returns MaterialColor from Color
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

ShapeBorder dialogShape([double? borderRadius]) {
  return RoundedRectangleBorder(
    borderRadius: radius(borderRadius ?? defaultRadius),
  );
}

/// returns Radius
BorderRadius radius([double? radius]) {
  return BorderRadius.all(radiusCircular(radius ?? defaultRadius));
}

/// returns Radius
BorderRadius radiusOnly({
  double? topLeft,
  double? topRight,
  double? bottomLeft,
  double? bottomRight,
}) {
  return BorderRadius.only(
    bottomLeft: Radius.circular(bottomLeft ?? 0),
    bottomRight: Radius.circular(bottomRight ?? 0),
    topLeft: Radius.circular(topLeft ?? 0),
    topRight: Radius.circular(topRight ?? 0),
  );
}

/// returns Radius
Radius radiusCircular([double? radius]) {
  return Radius.circular(radius ?? defaultRadius);
}

vSpace(double height) {
  return SizedBox(height: height);
}

hSpace(double width) {
  return SizedBox(width: width);
}

Widget svgImage({
  required String name,
  double? width,
  double? height,
  Color? color,
}) {
  return SvgPicture.asset(name, width: width, height: height, color: color);
}

EdgeInsets dynamicAppButtonPadding(BuildContext context) {
  return const EdgeInsets.symmetric(vertical: 14, horizontal: 16);
}

Widget inkWellWidget({Function()? onTap, required Widget child}) {
  return InkWell(
    onTap: onTap,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    splashColor: Colors.transparent,
    child: child,
  );
}

Widget commonCachedNetworkImage(
  String? url, {
  double? height,
  double? width,
  BoxFit? fit,
  Color? color,
  AlignmentGeometry? alignment,
  bool usePlaceholderIfUrlEmpty = true,
  double? radius,
}) {
  if (url != null && url.isEmpty) {
    return placeHolderWidget(
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
      radius: radius,
    );
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      color: color,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(
          height: height,
          width: width,
          fit: fit,
          alignment: alignment,
          radius: radius,
        );
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return const SizedBox();
        return placeHolderWidget(
          height: height,
          width: width,
          fit: fit,
          alignment: alignment,
          radius: radius,
        );
      },
    );
  } else {
    return Image.network(
      url!,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment ?? Alignment.center,
    );
  }
}

Widget placeHolderWidget({
  double? height,
  double? width,
  BoxFit? fit,
  AlignmentGeometry? alignment,
  double? radius,
}) {
  return Image.asset(
    placeholderImage,
    height: height,
    width: width,
    fit: fit ?? BoxFit.cover,
    alignment: alignment ?? Alignment.center,
  );
}

Future<dynamic> showAppBottomSheet({
  required BuildContext context,
  required Widget widgetBuilder,
  bool isDismissible = true,
}) async {
  final data = await showModalBottomSheet<dynamic>(
    isDismissible: isDismissible,
    isScrollControlled: true,
    constraints: BoxConstraints(maxHeight: Get.height * 0.5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(defaultRadius),
        topRight: Radius.circular(defaultRadius),
      ),
    ),
    context: context,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(bottom: context.bottom),
        child: widgetBuilder,
      );
    },
  );
  return data;
}

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;
    case ToastStates.error:
      color = AppColors.redColor;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}

Future<String> getAppInfo() async {
  WidgetsFlutterBinding.ensureInitialized();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

String getRandom(int length) {
  const ch = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789';
  Random r = Random();
  return String.fromCharCodes(
    Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))),
  );
}

Future<DateTime?> dateTimePicker(
  BuildContext context, {
  TimeOfDay? timeOfday,
}) async {
  DateTime? date = await pickDate(context);
  if (date == null) return null;

  // ignore: use_build_context_synchronously
  TimeOfDay? time = await pickTime(context, timeOfday: timeOfday);
  if (time == null) return null;

  DateTime newDateTime = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
  return newDateTime;
}

Future<DateTime?> pickDate(BuildContext context) => showDatePicker(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(1900),
  lastDate: DateTime(2100),
);

Future<TimeOfDay?> pickTime(BuildContext context, {TimeOfDay? timeOfday}) =>
    showTimePicker(context: context, initialTime: timeOfday ?? TimeOfDay.now());
