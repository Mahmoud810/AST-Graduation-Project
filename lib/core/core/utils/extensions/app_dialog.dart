import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../utils/common_method.dart';
import '../..//utils/extensions/app_common.dart';
import '../..//utils/size_utils.dart';

import '../../assets/icons/icons.dart';
import '../../theme/colors.dart';

class TopLoader {
  static const SizedBox _container = SizedBox(
    width: 40,
    height: 40,
    child: Center(
      child: CircularProgressIndicator(color: AppColors.orangColor),
    ),
  );

  static void startLoading() {
    showDialog(
      barrierColor: Colors.black54,
      barrierDismissible: false,
      context: Get.context!,
      builder: (context) => _container,
    );
  }

  static void stopLoading() {
    Navigator.of(Get.context!).pop();
  }
}

class AppDialog {
  static Future<Object?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required Function onAccept,
    String? okTitle,
    bool dismissable = true,
  }) async {
    return await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: dismissable,
      // barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, _, __) {
        return ConfirmDialogContent(
          title: title,
          onAccept: onAccept,
          okTitle: okTitle,
        );
      },
      transitionBuilder: (context, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(anim),
          child: child,
        );
      },
    );
  }

  static Future<Object?> showDeleteDialog(
    BuildContext context, {
    required String title,
    required Function onAccept,
    bool dismissable = true,
  }) async {
    return await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: dismissable,
      // barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, _, __) {
        return DeleteDialogContent(title: title, onAccept: onAccept);
      },
      transitionBuilder: (context, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(anim),
          child: child,
        );
      },
    );
  }

  static Future<Object?> showSelectSatusDialog(
    BuildContext context, {
    required Function onSelect,
    required String title,
    required String choice1,
    required String choice2,
    String choice3 = '',
    bool dismissable = true,
  }) async {
    return await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: dismissable,
      // barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, _, __) {
        return StatusDialogContent(
          onSatusSelect: onSelect,
          title: title,
          choice1: choice1,
          choice2: choice2,
          choice3: choice3,
        );
      },
      transitionBuilder: (context, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(anim),
          child: child,
        );
      },
    );
  }

  static Future<DateTime?> showMyDatePicker(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 400)),
      lastDate: DateTime.now().add(const Duration(days: 400)),
    );
  }

  static Future<TimeOfDay?> showMyTimePicker(BuildContext context) async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  static Future<bool?> showCustomBottomSheet(
    BuildContext context, {
    required Widget contentWidget,
  }) async {
    final bottomSheet = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 3.5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: AppColors.gray8Color,
              ),
            ),
            const SizedBox(height: 20),
            contentWidget,
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
    final isConfirmed = await showModalBottomSheet<bool>(
      backgroundColor: AppColors.whiteColor,
      isScrollControlled: true,
      context: context,
      builder: (context) => bottomSheet,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
    return isConfirmed;
  }
}

class ConfirmDialogContent extends StatelessWidget {
  final String title;
  final Function onAccept;
  final String? okTitle;
  const ConfirmDialogContent({
    super.key,
    required this.title,
    required this.onAccept,
    this.okTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: isTablet
              ? (isLandscape ? Get.width * 0.45 : Get.width * 0.7)
              : (isLandscape ? Get.width * 0.5 : Get.width * 0.85),
          height: isTablet
              ? (isLandscape ? Get.height * 0.45 : Get.height * 0.4)
              : (isLandscape ? Get.height * 0.7 : Get.height * 0.4),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: radius(),
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                AppIcons.ic_IconsSuccess,
                width: isTablet
                    ? (isLandscape ? Get.width * 0.2 : Get.width * 0.35)
                    : (isLandscape ? Get.width * 0.2 : Get.width * 0.45),
                height: isTablet
                    ? (isLandscape ? Get.height * 0.2 : Get.height * 0.2)
                    : (isLandscape ? Get.height * 0.35 : Get.height * 0.2),
              ),
              vSpace(8),
              Text(title, style: boldTextStyle(size: 17)),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => onAccept.call(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: radius(4.adaptSize),
                          border: Border.all(color: AppColors.primaryColor),
                        ),
                        child: Text(
                          okTitle ?? 'save'.tr,
                          style: boldTextStyle(
                            size: 17,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  hSpace(8),
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: radius(4.adaptSize),
                          border: Border.all(color: AppColors.primaryColor),
                        ),
                        child: Text(
                          'cancel'.tr,
                          style: boldTextStyle(
                            size: 17,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteDialogContent extends StatelessWidget {
  final String title;
  final Function onAccept;
  const DeleteDialogContent({
    super.key,
    required this.title,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: isTablet
              ? (isLandscape ? Get.width * 0.45 : Get.width * 0.7)
              : (isLandscape ? Get.width * 0.5 : Get.width * 0.85),
          height: isTablet
              ? (isLandscape ? Get.height * 0.45 : Get.height * 0.4)
              : (isLandscape ? Get.height * 0.7 : Get.height * 0.4),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: radius(),
          ),
          child: Column(
            children: [
              SvgPicture.asset(
                AppIcons.ic_IconsSuccess,
                width: isTablet
                    ? (isLandscape ? Get.width * 0.2 : Get.width * 0.35)
                    : (isLandscape ? Get.width * 0.2 : Get.width * 0.45),
                height: isTablet
                    ? (isLandscape ? Get.height * 0.2 : Get.height * 0.2)
                    : (isLandscape ? Get.height * 0.35 : Get.height * 0.2),
              ),
              vSpace(8),
              Text(title, style: boldTextStyle(size: 17)),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => onAccept.call(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: radius(4.adaptSize),
                          border: Border.all(color: AppColors.redLightColor),
                        ),
                        child: Text(
                          'delete'.tr,
                          style: boldTextStyle(
                            size: 17,
                            color: AppColors.redLightColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  hSpace(8),
                  Expanded(
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          borderRadius: radius(4.adaptSize),
                          border: Border.all(color: AppColors.greenColor),
                        ),
                        child: Text(
                          'cancel'.tr,
                          style: boldTextStyle(
                            size: 17,
                            color: AppColors.greenColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatusDialogContent extends StatelessWidget {
  final String choice1;
  final String choice2;
  final String choice3;
  final String title;
  final Function onSatusSelect;
  const StatusDialogContent({
    super.key,
    required this.onSatusSelect,
    required this.choice1,
    required this.choice2,
    this.choice3 = '',
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 314,
          height: (choice3 != '') ? 230 : 193,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: radius(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: boldTextStyle(size: 17)),
              vSpace(12),
              InkWell(
                onTap: () => onSatusSelect(1),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.ic_IconsCorrectCircle,
                      width: 24,
                      height: 24,
                    ),
                    hSpace(8),
                    Text(choice1, style: boldTextStyle(size: 14)),
                  ],
                ),
              ),
              vSpace(8),
              const Divider(),
              vSpace(8),
              InkWell(
                onTap: () => onSatusSelect(0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppIcons.ic_IconsCorrectCircle,
                      width: 24,
                      height: 24,
                    ),
                    hSpace(8),
                    Text(choice2, style: boldTextStyle(size: 14)),
                  ],
                ),
              ),
              if (choice3 != '') const Divider(),
              if (choice3 != '') vSpace(8),
              if (choice3 != '')
                InkWell(
                  onTap: () => onSatusSelect(2),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.ic_IconsCorrectCircle,
                        width: 24,
                        height: 24,
                      ),
                      hSpace(8),
                      Text(choice3, style: boldTextStyle(size: 14)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
