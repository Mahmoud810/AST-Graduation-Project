import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../theme/colors.dart';
import '../utils/extensions/app_common.dart';
import '../utils/size_utils.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 80,
        height: 80,
        child: const LoadingIndicator(
          indicatorType: Indicator.ballScale,
          colors: [AppColors.primaryColor],
          strokeWidth: 2,
        ),
      ),
    );
  }
}

class CustomErrorView extends StatelessWidget {
  const CustomErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.error_outline, color: AppColors.redColor, size: 50),
    );
  }
}

class CustomEmptyDataView extends StatelessWidget {
  const CustomEmptyDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('no_data_to_preview'.tr, style: primaryTextStyle()),
    );
  }
}
