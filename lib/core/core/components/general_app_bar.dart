import 'package:flutter/material.dart';
import '../../core/assets/icons/icons.dart';
import '../../core/components/back_button_widget.dart';
import '../../core/components/custom_image.dart';
import '../../core/components/notification_widget.dart';
import '../../core/theme/colors.dart';
import '../../core/utils/app_constants.dart';
import '../../core/utils/extensions/app_common.dart';
import '../../core/utils/size_utils.dart';

class GeneralAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final bool withNotification;
  final bool withBackButton;
  final List<Widget> actions;
  final String title;
  final double height;
  final double leadingWidth;

  const GeneralAppBar({
    super.key,
    this.leading,
    this.title = '',
    this.actions = const [],
    this.height = kToolbarHeight,
    this.withNotification = false,
    this.withBackButton = true,
    this.leadingWidth = 75,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 70, // leadingWidth,
      toolbarHeight: appBarHeight,
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.whiteColor,
      iconTheme: const IconThemeData(color: AppColors.blackColor),
      leading: leading ?? (withBackButton ? closePageWidget() : SizedBox()),
      title: Text(
        title,
        style: boldTextStyle(color: AppColors.whiteColor, size: 18.adaptSize),
      ),
      actions: [if (withNotification) NotificationWidget()],

      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.adaptSize),
            bottomRight: Radius.circular(24.adaptSize),
          ),
          /* gradient: LinearGradient(
                    colors: [Colors.red,Colors.pink],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter
                ), */
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
