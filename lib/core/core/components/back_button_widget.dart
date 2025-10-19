import 'dart:ui';

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/common_method.dart';
import '../utils/extensions/app_common.dart';

import '../assets/icons/icons.dart';
import '../services/navigation_handler.dart';

Widget closePageWidget({Function? onTap}) {
  return Builder(
    builder: (context) {
      return IconButton(
        onPressed: () {
          Go.back();
        },
        icon: Container(
          width: 40,
          //height: 40,
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.transparent,
            border: Border.all(color: AppColors.backBorderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: svgImage(
            name: isArabic
                ? AppIcons.ic_IconsArrowLeft
                : AppIcons.ic_IconsArrowRight,
            color: AppColors.backBorderColor,
            height: 24,
            width: 24,
          ),
        ),
      );
    },
  );
}

Widget closePageGlassesWidget({Function? onTap}) {
  return Builder(
    builder: (context) {
      return inkWellWidget(
        onTap: () {
          Go.back();
        },
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: 50,
              //height: 50,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                border: Border.all(color: AppColors.backBorderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: svgImage(
                name: isArabic
                    ? AppIcons.ic_IconsArrowRight
                    : AppIcons.ic_IconsArrowLeft,
                height: 25,
                width: 25,
              ),
            ),
          ),
        ),
      );
    },
  );
}
