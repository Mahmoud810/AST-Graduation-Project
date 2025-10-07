import 'package:flutter/material.dart';
import '../../core/assets/icons/icons.dart';
import '../../core/components/custom_image.dart';
import '../../core/theme/colors.dart';
import '../../core/utils/extensions/app_common.dart';
import '../../core/utils/size_utils.dart';

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
