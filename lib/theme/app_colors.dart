import 'package:flutter/material.dart';

/// Unified Color System for the App
/// This replaces all scattered color definitions and provides consistent theming
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // === PRIMARY COLORS ===
  /// Main app color - Blue (0xFF335e90)
  static const Color primary = Color(0xFF335e90);
  
  /// Secondary color - Light blue variant
  static const Color secondary = Color(0xFF4A7BA7);
  
  /// Accent color for highlights
  static const Color accent = Color(0xFF5A8FC4);

  // === SURFACE COLORS ===
  /// Background color - White
  static const Color background = Color(0xFFFFFFFF);
  
  /// Card/Surface color - Very light grey
  static const Color surface = Color(0xFFF8F9FA);
  
  /// Container background - Off-white
  static const Color container = Color(0xFFFBFAFC);

  // === TEXT COLORS ===
  /// Primary text color - Dark grey
  static const Color textPrimary = Color(0xFF333333);
  
  /// Secondary text color - Medium grey
  static const Color textSecondary = Color(0xFF707070);
  
  /// Hint/placeholder text color - Light grey
  static const Color textHint = Color(0xFFB0B0B0);
  
  /// Disabled text color - Very light grey
  static const Color textDisabled = Color(0xFFCCCCCC);

  // === STATUS COLORS ===
  /// Success color - Green
  static const Color success = Color(0xFF039208);
  
  /// Warning color - Orange
  static const Color warning = Color(0xFFF66A17);
  
  /// Error color - Red
  static const Color error = Color(0xFFCB0000);
  
  /// Info color - Blue
  static const Color info = Color(0xFF1A5E75);

  // === NEUTRAL COLORS ===
  /// White color
  static const Color white = Color(0xFFFFFFFF);
  
  /// Black color
  static const Color black = Color(0xFF000000);
  
  /// Grey color - Standard grey
  static const Color grey = Color(0xFF707070);
  
  /// Light grey - For borders and dividers
  static const Color greyLight = Color(0xFFE4E4E4);
  
  /// Very light grey - For backgrounds
  static const Color greyVeryLight = Color(0xFFF0F0F0);

  // === OPACITY VARIANTS ===
  /// Primary color with opacity
  static Color primaryOpacity(double opacity) => primary.withOpacity(opacity);
  
  /// Error color with opacity
  static Color errorOpacity(double opacity) => error.withOpacity(opacity);
  
  /// Success color with opacity
  static Color successOpacity(double opacity) => success.withOpacity(opacity);
  
  /// Warning color with opacity
  static Color warningOpacity(double opacity) => warning.withOpacity(opacity);
  
  /// Black color with opacity
  static Color blackOpacity(double opacity) => black.withOpacity(opacity);
  
  /// White color with opacity
  static Color whiteOpacity(double opacity) => white.withOpacity(opacity);
  
  /// Grey color with opacity
  static Color greyOpacity(double opacity) => grey.withOpacity(opacity);

  // === LEGACY COMPATIBILITY ===
  /// For backward compatibility - Maps to primary
  static const Color appColor = primary;
  
  /// For backward compatibility - Maps to textPrimary
  static const Color textDark = textPrimary;
  
  /// For backward compatibility - Maps to grey
  static const Color textHintColor = textHint;

  // === MATERIAL COLOR MAPPINGS ===
  /// Material Design color equivalents
  static const Color materialRed = Colors.red;
  static const Color materialGreen = Colors.green;
  static const Color materialOrange = Colors.orange;
  static const Color materialGrey = Colors.grey;
  static const Color materialWhite = Colors.white;
  static const Color materialBlack = Colors.black;
}

/// Extension for easy color access
extension AppColorExtensions on Color {
  /// Get opacity variant
  Color withOpacityValue(double opacity) => withOpacity(opacity);
  
  /// Check if color is dark
  bool get isDark => computeLuminance() < 0.5;
  
  /// Check if color is light
  bool get isLight => computeLuminance() >= 0.5;
}
