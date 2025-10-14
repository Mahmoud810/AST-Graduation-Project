import 'package:flutter/material.dart';

import '../../constants.dart';

class BaseView extends StatelessWidget {
  final String title;
  final Widget body;
  final bool isContainSearch;
  final VoidCallback? onCartPressed;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;

  const BaseView({
    super.key,
    required this.title,
    required this.body,
    this.onCartPressed,
    this.onSearchChanged,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.isContainSearch = true,
  });

  @override
  Widget build(BuildContext context) {
    // Constants for consistent layout spacing
    const double componentHeight = 48.0;
    const double headerRowHeight = 48.0;
    const double verticalPadding = 16.0;
    const double spacerHeight = 10.0;
    const double overlapAmount = 16.0; // reduced overlap for cleaner gap
    const double horizontalSpacing = 12.0;
    const double bottomSpacingBelowSearch =
        22.0; // new spacing below search bar

    // Calculate header height
    double headerContentHeight =
        MediaQuery.of(context).padding.top +
        verticalPadding +
        headerRowHeight +
        spacerHeight;

    if (isContainSearch) {
      headerContentHeight +=
          componentHeight + verticalPadding + bottomSpacingBelowSearch;
    } else {
      headerContentHeight += verticalPadding;
    }

    final double headerTotalHeight = headerContentHeight;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // --- Header (blue Section) ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: headerTotalHeight,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + verticalPadding,
                left: 16,
                right: 16,
                bottom: verticalPadding,
              ),
              decoration: const BoxDecoration(color: AppColors.appColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Title Row ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: AppColors.white,
                            ),
                            onPressed: onMenuPressed,
                            iconSize: 24,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_none,
                          color: AppColors.white,
                        ),
                        onPressed: onNotificationPressed,
                        iconSize: 24,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  const SizedBox(height: spacerHeight),

                  // --- Search & Filter Row ---
                  if (isContainSearch) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: componentHeight,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Search',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF888888),
                                ),
                                filled: true,
                                fillColor: AppColors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppColors.appColor,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onChanged: onSearchChanged,
                              style: const TextStyle(color: AppColors.textDark),
                            ),
                          ),
                        ),
                        const SizedBox(width: horizontalSpacing),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: componentHeight,
                              width: componentHeight,
                              decoration: BoxDecoration(
                                color: AppColors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.shopping_cart_outlined,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                                onPressed:
                                    onCartPressed, // same as cart navigation
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints.tightFor(
                                  width: componentHeight,
                                  height: componentHeight,
                                ),
                              ),
                            ),

                            // 🔴 Badge
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: AppColors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  '0', // TODO: make dynamic later
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // --- Body (White Section) ---
          Positioned.fill(
            top: headerTotalHeight - overlapAmount,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(overlapAmount),
                  topRight: Radius.circular(overlapAmount),
                ),
              ),
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}
