import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../theme/colors.dart';
import '../utils/size_utils.dart';

class MainLayoutWidget extends StatelessWidget {
  final Widget widget;
  final Widget? bottomWidget;
  final Color? backGroundColor;
  final ScrollController? scrollController;
  final double? minHeight;
  final bool isScrollable;
  final Future Function()? onRefresh;
  final double heightMargin;
  final double widthMargin;
  final Widget? drawer;
  final PreferredSizeWidget? appBar;
  final Future<bool> Function()? onWillPop;
  final bool isSafeArea;
  final SystemUiOverlayStyle systemUiOverlayColor;
  final double? maxHeight;
  final Widget? backgroundWidget;
  final Widget? floatingButton;
  final bool extendBodyBehindAppBar;

  const MainLayoutWidget({
    super.key,
    required this.widget,
    this.bottomWidget,
    this.backGroundColor,
    this.scrollController,
    this.minHeight,
    this.maxHeight,
    this.isScrollable = true,
    this.heightMargin = 12.0,
    this.widthMargin = 18.0,
    this.drawer,
    this.appBar,
    this.onWillPop,
    this.isSafeArea = true,
    this.systemUiOverlayColor = SystemUiOverlayStyle.dark,
    this.onRefresh,
    this.backgroundWidget,
    this.extendBodyBehindAppBar = false,
    this.floatingButton,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayColor);
    mediaQueryData = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
            appBar: appBar,
            drawer: drawer,
            bottomNavigationBar: bottomWidget,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            floatingActionButton: floatingButton,
            backgroundColor: AppColors.appbarColor,
            //backGroundColor,
            body:
                // backgroundWidget != null
                //     ?
                Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  height: double.maxFinite,
                  decoration: const BoxDecoration(
                      //gradient:  backgroundGradient,
                      color: AppColors.backgroundColor),
                ),
                IsScrollable(
                  maxHeight: maxHeight,
                  onRefresh: onRefresh,
                  scrollController: scrollController,
                  minHeight: minHeight,
                  widthMargin: widthMargin,
                  heightMargin: heightMargin,
                  widget: widget,
                  isSafeArea: isSafeArea,
                  isScrollable: isScrollable,
                ),
              ],
            )
            // : IsScrollable(
            //     maxHeight: maxHeight,
            //     onRefresh: onRefresh,
            //     scrollController: scrollController,
            //     minHeight: minHeight,
            //     widthMargin: widthMargin,
            //     heightMargin: heightMargin,
            //     widget: widget,
            //     isSafeArea: isSafeArea,
            //     isScrollable: isScrollable,
            //   ),
            ),
      ),
    );
  }
}

class IsScrollable extends StatelessWidget {
  const IsScrollable({
    super.key,
    required this.scrollController,
    required this.minHeight,
    required this.widthMargin,
    required this.heightMargin,
    required this.widget,
    required this.isSafeArea,
    required this.isScrollable,
    required this.onRefresh,
    required this.maxHeight,
  });

  final bool isScrollable;
  final ScrollController? scrollController;
  final double? minHeight;
  final double widthMargin;
  final double heightMargin;
  final Widget widget;
  final bool isSafeArea;
  final Future Function()? onRefresh;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    if (isScrollable) {
      return onRefresh != null
          ? RefreshIndicator(
              onRefresh: onRefresh!,
              backgroundColor: AppColors.textFormFieldFillColor,
              color: AppColors.primaryColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                controller: scrollController,
                child: MainBodyWidget(
                  maxHeight: maxHeight,
                  minHeight: minHeight,
                  widthMargin: widthMargin,
                  heightMargin: heightMargin,
                  widget: widget,
                  isSafeArea: isSafeArea,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.zero,
              controller: scrollController,
              child: MainBodyWidget(
                maxHeight: maxHeight,
                minHeight: minHeight,
                widthMargin: widthMargin,
                heightMargin: heightMargin,
                widget: widget,
                isSafeArea: isSafeArea,
              ),
            );
    } else {
      return MainBodyWidget(
        maxHeight: maxHeight,
        minHeight: minHeight,
        widthMargin: widthMargin,
        heightMargin: heightMargin,
        widget: widget,
        isSafeArea: isSafeArea,
      );
    }
  }
}

class MainBodyWidget extends StatelessWidget {
  const MainBodyWidget({
    super.key,
    required this.minHeight,
    required this.widthMargin,
    required this.heightMargin,
    required this.widget,
    required this.isSafeArea,
    required this.maxHeight,
  });

  final double? minHeight;
  final double widthMargin;
  final double heightMargin;
  final Widget widget;
  final bool isSafeArea;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints(
      //   minHeight: minHeight ?? SizeConfig.screenHeight,
      //   maxHeight: maxHeight ?? SizeConfig.screenHeight,
      // ),

      margin: EdgeInsets.symmetric(
        horizontal: widthMargin,
      ),
      padding: EdgeInsets.symmetric(
        vertical: heightMargin,
      ),
      width: context.width,
      child: isSafeArea
          ? SafeArea(
              child: widget,
            )
          : widget,
    );
  }
}
