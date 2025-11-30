import 'package:flutter/material.dart';

// Legacy AppColors for backward compatibility
// Use theme/app_colors.dart for new development
class AppColors {
  AppColors._(); // Private constructor
  
  // === PRIMARY COLORS ===
  static const Color appColor = Color(0xFF335e90); // Main blue color
  
  // === TEXT COLORS ===  
  static const Color textDark = Color(0xFF333333); // Primary text
  static const Color textHint = Color(0xFFB0B0B0); // Hint text
  
  // === BASIC COLORS ===
  static const Color white = Colors.white;
  static const Color red = Colors.red;
  static const Color grey = Colors.grey;
  static const Color black = Colors.black;
  static const Color green = Colors.green;
  static const Color orange = Colors.orange;
  
  // === SURFACE COLORS ===
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color container = Color(0xFFFBFAFC);
  
  // === STATUS COLORS ===
  static const Color success = Color(0xFF039208);
  static const Color warning = Color(0xFFF66A17);
  static const Color error = Color(0xFFCB0000);
  
  // === NEUTRAL COLORS ===
  static const Color greyLight = Color(0xFFE4E4E4);
  static const Color greyVeryLight = Color(0xFFF0F0F0);
  
  // === OPACITY HELPERS ===
  static Color primaryOpacity(double opacity) => appColor.withOpacity(opacity);
  static Color errorOpacity(double opacity) => error.withOpacity(opacity);
  static Color successOpacity(double opacity) => success.withOpacity(opacity);
  static Color warningOpacity(double opacity) => warning.withOpacity(opacity);
  static Color blackOpacity(double opacity) => black.withOpacity(opacity);
  static Color whiteOpacity(double opacity) => white.withOpacity(opacity);
  static Color greyOpacity(double opacity) => grey.withOpacity(opacity);
}

// App-wide constants
class AppConstants {
  AppConstants._();
  
  static const String appName = "Graduation Project";
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultSpacing = 8.0;
}
