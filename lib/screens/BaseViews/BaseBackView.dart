import 'package:flutter/material.dart';
import '../../constants.dart';

class BaseBackView extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onBackPressed;
  final VoidCallback? onFilterPressed;

  const BaseBackView({
    super.key,
    required this.title,
    required this.body,
    this.onBackPressed,
    this.onFilterPressed,
  });

  @override
  Widget build(BuildContext context) {
    const double overlapAmount = 24.0;
    const double navigationRowHeight = 44.0;
    const double titleRowHeight = 30.0;
    const double verticalSpacing =
        20.0; // Spacing between navigation row and title
    const double topContentPadding = 20.0;
    const double bottomContentPadding =
        50.0; // INCREASE THIS for more spacing after the title/header content

    // Calculate the total height required for the header content area (Navigation + Spacing + Title)
    final double contentAreaHeight =
        navigationRowHeight + verticalSpacing + titleRowHeight;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Compute safe area top padding
          final double topPadding = MediaQuery.of(context).padding.top;

          // Total height of the blue header section
          final double headerTotalHeight =
              topPadding +
              topContentPadding +
              contentAreaHeight +
              bottomContentPadding; // Use increased bottom padding

          return Stack(
            children: [
              // --- 1. Header (Blue Section) ---
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: headerTotalHeight,
                child: Container(
                  padding: EdgeInsets.only(
                    top: topPadding + topContentPadding,
                    left: 16,
                    right: 16,
                    bottom:
                        bottomContentPadding, // Apply increased bottom padding here
                  ),
                  decoration: const BoxDecoration(color: AppColors.appColor),

                  // Constrain the content area height
                  child: SizedBox(
                    height: contentAreaHeight,
                    child: Stack(
                      children: [
                        // --- 1. Navigation Row (Back Button + "Back" text) ---
                        Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            height: navigationRowHeight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: AppColors.white,
                                    size: 22,
                                  ),
                                  onPressed:
                                      onBackPressed ??
                                      () => Navigator.pop(context),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const Text(
                                  'Back',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // --- 2. Centered Title (Below Navigation Row with Spacing) ---
                        Positioned(
                          top:
                              navigationRowHeight +
                              verticalSpacing, // Title starts after Nav Row + 30px spacing
                          left: 0,
                          right: 0,
                          height: titleRowHeight,
                          child: Center(
                            child: Text(
                              title,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        // --- 3. Optional Filter Button (Right) ---
                        if (onFilterPressed != null)
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: navigationRowHeight,
                              width: navigationRowHeight,
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: Image.asset(
                                  "assets/filterIcon.png",
                                  color: AppColors.white,
                                  height: 20,
                                ),
                                onPressed: onFilterPressed,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints.tightFor(
                                  width: navigationRowHeight,
                                  height: navigationRowHeight,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // --- 2. Body (White Section with Rounded Top Corners) ---
              Positioned(
                top: headerTotalHeight - overlapAmount,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(overlapAmount),
                      topRight: Radius.circular(overlapAmount),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: body,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
