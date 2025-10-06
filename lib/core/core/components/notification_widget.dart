import 'package:flutter/material.dart';
import 'package:haretna/core/assets/icons/icons.dart';
import 'package:haretna/core/components/custom_image.dart';
import 'package:haretna/core/theme/colors.dart';
import 'package:haretna/core/utils/extensions/app_common.dart';
import 'package:haretna/core/utils/size_utils.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: inkWellWidget(
        onTap: () {},
        child: CustomImageView(
          imagePath: AppIcons.ic_IconsNotification,
          color: AppColors.whiteColor,
          height: 25.adaptSize,
          width: 25.adaptSize,
        ),
      ),
    );
  }
}
