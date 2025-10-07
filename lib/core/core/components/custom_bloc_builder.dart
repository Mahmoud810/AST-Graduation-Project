import 'package:flutter/material.dart';
import '../../core/components/custom_loading_indicator.dart';

class CustomBlocBuilderView extends StatelessWidget {
  final bool isLoadingState;
  final bool isErrorgState;
  final bool isSuccessState;
  final Widget? errorView;
  final Widget? loadingView;
  final Widget successView;
  const CustomBlocBuilderView({
    super.key,
    required this.isLoadingState,
    required this.isSuccessState,
    required this.isErrorgState,
    this.errorView,
    this.loadingView,
    required this.successView,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingState) {
      return loadingView ?? const CustomLoadingIndicator();
    } else if (isErrorgState) {
      return errorView ?? const CustomErrorView();
    } else if (isSuccessState) {
      return successView;
    } else {
      return const CustomEmptyDataView();
    }
  }
}
