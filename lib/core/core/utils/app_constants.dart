import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';

import '../theme/colors.dart';

const double appBarHeight = 75;
const passwordLengthGlobal = 8;
double defaultRadius = 10.0;
double defaultSmallRadius = 6.0;

double defaultPadding = 16.0;
double defaultSmallPadding = 8.0;

double current_latitude = 0.0;
double current_longtude = 0.0;

double textPrimarySizeGlobal = 18.00;
double textBoldSizeGlobal = 15.00;
double textNormalSizeGlobal = 18.00;
double textSecondarySizeGlobal = 16.00;
const String placeholderImage = 'https://placehold.co/600x400/EEE/31343C';
double defaultAppButtonElevation = 4.0;

ShapeBorder defaultAppButtonShapeBorder = const RoundedRectangleBorder();

bool enableAppButtonScaleAnimationGlobal = false;

Color textPrimaryColorGlobal = AppColors.blackColor;
Color textSecondaryColorGlobal = AppColors.subtitleColor;

var errorThisFieldRequired = 'required_feild'.tr;

/// Keys
const String LANG_key = 'lang';

const String TOKEN = 'token';
const String FCM = 'fcm';
const String TYPEVENDOR = 'typeVendor';
const String LOCATION = 'location';
const String PAID = 'paid';
const String validation = 'valid';
const String FIRSTIME = 'firstTime';

GradientBoxBorder defaultGradiantBoxBorder = GradientBoxBorder(
  gradient: LinearGradient(
    colors: [Colors.grey, Colors.white],
  ),
);
GradientBoxBorder goldGradiantBoxBorder = GradientBoxBorder(
  gradient: LinearGradient(colors: [Colors.white, Color(0xffFFDE85)]),
);
