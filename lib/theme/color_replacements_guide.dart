/// 🎨 COLOR REPLACEMENTS GUIDE
/// 
/// This file contains all the color replacements needed to standardize the app colors.
/// 
/// HOW TO USE:
/// 1. Search for each "OLD COLOR" pattern in your project
/// 2. Replace with the "NEW COLOR" pattern
/// 3. Test the UI to ensure consistency
/// 
/// Priority: HIGH - Replace these first for immediate consistency
/// Priority: MEDIUM - Replace these for better theming
/// Priority: LOW - Replace these when you have time

/// === PRIORITY 1: CRITICAL REPLACEMENTS ===

/// Direct Material Colors (Most Important)
const List<Map<String, String>> CRITICAL_REPLACEMENTS = [
  // Replace all direct Colors.white usage
  {
    'old': 'Colors.white',
    'new': 'AppColors.white',
    'files': '15+ files',
    'impact': 'Backgrounds, text, containers',
  },
  
  // Replace all direct Colors.grey usage
  {
    'old': 'Colors.grey',
    'new': 'AppColors.grey',
    'files': '20+ files',
    'impact': 'Text, borders, disabled states',
  },
  
  // Replace all direct Colors.black usage
  {
    'old': 'Colors.black',
    'new': 'AppColors.black',
    'files': '10+ files',
    'impact': 'Text, overlays, shadows',
  },
  
  // Replace all direct Colors.green usage
  {
    'old': 'Colors.green',
    'new': 'AppColors.success',
    'files': '5+ files',
    'impact': 'Success states, free shipping',
  },
  
  // Replace all direct Colors.orange usage
  {
    'old': 'Colors.orange',
    'new': 'AppColors.warning',
    'files': '3+ files',
    'impact': 'Warning states, out of stock',
  },
];

/// === PRIORITY 2: THEME IMPROVEMENTS ===

/// Opacity Variants (Better UX)
const List<Map<String, String>> OPACITY_REPLACEMENTS = [
  // Black opacity variants
  {
    'old': 'Colors.black.withOpacity(',
    'new': 'AppColors.blackOpacity(',
    'files': '10+ files',
    'example': 'Colors.black.withOpacity(0.1) → AppColors.blackOpacity(0.1)',
  },
  
  // White opacity variants
  {
    'old': 'Colors.white.withOpacity(',
    'new': 'AppColors.whiteOpacity(',
    'files': '5+ files',
    'example': 'Colors.white.withOpacity(0.8) → AppColors.whiteOpacity(0.8)',
  },
  
  // Grey opacity variants
  {
    'old': 'Colors.grey.withOpacity(',
    'new': 'AppColors.greyOpacity(',
    'files': '8+ files',
    'example': 'Colors.grey.withOpacity(0.4) → AppColors.greyOpacity(0.4)',
  },
  
  // Primary color opacity variants
  {
    'old': 'AppColors.appColor.withOpacity(',
    'new': 'AppColors.primaryOpacity(',
    'files': '10+ files',
    'example': 'AppColors.appColor.withOpacity(0.1) → AppColors.primaryOpacity(0.1)',
  },
];

/// === PRIORITY 3: LEGACY CLEANUP ===

/// Legacy AppColors Usage (Future-proofing)
const List<Map<String, String>> LEGACY_REPLACEMENTS = [
  // Update to new primary color naming
  {
    'old': 'AppColors.appColor',
    'new': 'AppColors.primary',
    'files': '45+ files',
    'impact': 'Main brand color',
    'note': 'Already mapped in constants.dart for backward compatibility',
  },
  
  // Update to new text color naming
  {
    'old': 'AppColors.textDark',
    'new': 'AppColors.textPrimary',
    'files': '8+ files',
    'impact': 'Primary text color',
    'note': 'Already mapped in constants.dart for backward compatibility',
  },
  
  // Update to new hint color naming
  {
    'old': 'AppColors.textHint',
    'new': 'AppColors.textHint',
    'files': '10+ files',
    'impact': 'Hint text color',
    'note': 'No change needed, just consistency',
  },
];

/// === PRIORITY 4: HARD CODED COLORS ===

/// Hardcoded Hex Colors (Must be replaced)
const List<Map<String, dynamic>> HARDCODED_REPLACEMENTS = [
  // Specific hardcoded color found
  {
    'old': 'Color(0xFF888888)',
    'new': 'AppColors.grey',
    'files': ['BaseView.dart:129'],
    'impact': 'Icon color in search bar',
    'line': 129,
  },
];

/// === SPECIFIC FILE REPLACEMENTS ===

/// Files that need specific attention
const Map<String, List<Map<String, String>>> FILE_SPECIFIC_REPLACEMENTS = {
  'lib/widgets/product_card_widget.dart': [
    {'old': 'Colors.grey.withOpacity(0.4)', 'new': 'AppColors.greyOpacity(0.4)'},
    {'old': 'Colors.orange', 'new': 'AppColors.warning'},
  ],
  
  'lib/widgets/prescription_grid_cell.dart': [
    {'old': 'Colors.black.withOpacity(0.1)', 'new': 'AppColors.blackOpacity(0.1)'},
    {'old': 'Colors.black.withOpacity(0.6)', 'new': 'AppColors.blackOpacity(0.6)'},
    {'old': 'Colors.black.withOpacity(0.5)', 'new': 'AppColors.blackOpacity(0.5)'},
    {'old': 'Colors.black.withOpacity(0.7)', 'new': 'AppColors.blackOpacity(0.7)'},
  ],
  
  'lib/screens/NavBar/GiftScreen.dart': [
    {'old': 'Colors.green', 'new': 'AppColors.success'},
    {'old': 'Colors.white', 'new': 'AppColors.white'},
  ],
  
  'lib/screens/Authentication/signin_screen.dart': [
    {'old': 'Colors.grey', 'new': 'AppColors.grey'},
    {'old': 'Colors.black54', 'new': 'AppColors.blackOpacity(0.54)'},
  ],
  
  'lib/screens/NavBar/prescription_upload_screen.dart': [
    {'old': 'Colors.orange.withOpacity(0.1)', 'new': 'AppColors.warningOpacity(0.1)'},
    {'old': 'Colors.orange.withOpacity(0.3)', 'new': 'AppColors.warningOpacity(0.3)'},
  ],
};

/// === REPLACEMENT EXAMPLES ===

/// Before and After Examples
const List<Map<String, String>> EXAMPLES = [
  {
    'file': 'product_card_widget.dart',
    'before': 'color: Colors.grey.withOpacity(0.4)',
    'after': 'color: AppColors.greyOpacity(0.4)',
  },
  
  {
    'file': 'prescription_grid_cell.dart',
    'before': 'color: Colors.black.withOpacity(0.6)',
    'after': 'color: AppColors.blackOpacity(0.6)',
  },
  
  {
    'file': 'GiftScreen.dart',
    'before': 'Colors.green',
    'after': 'AppColors.success',
  },
  
  {
    'file': 'BaseView.dart',
    'before': 'Color(0xFF888888)',
    'after': 'AppColors.grey',
  },
];

/// === SEARCH PATTERNS ===

/// Use these patterns in your IDE search/replace
const List<String> SEARCH_PATTERNS = [
  'Colors\\.white',
  'Colors\\.grey',
  'Colors\\.black',
  'Colors\\.green',
  'Colors\\.orange',
  'Colors\\.red',
  'Color\\(0x[A-Fa-f0-9]{8}\\)',
  'AppColors\\.appColor\\.withOpacity',
  'Colors\\.black\\.withOpacity',
  'Colors\\.white\\.withOpacity',
  'Colors\\.grey\\.withOpacity',
];

/// === VALIDATION ===

/// After replacements, validate by searching for these patterns
const List<String> VALIDATION_PATTERNS = [
  'Colors\\.', // Should have minimal results
  'Color\\(0x', // Should have no results
  'AppColors\\.(primary|textPrimary|success|warning|error)', // Should have many results
];

/// === IMPLEMENTATION PLAN ===

/// Step-by-step implementation:
/// 1. Update imports in all files to include the new AppColors
/// 2. Replace critical Colors.white, Colors.grey, Colors.black
/// 3. Replace Colors.green and Colors.orange
/// 4. Replace opacity variants
/// 5. Replace hardcoded hex colors
/// 6. Update to new naming conventions (optional)
/// 7. Test all screens for visual consistency
/// 8. Validate no old patterns remain

/// === TESTING CHECKLIST ===

/// After replacements, verify:
/// - All buttons use consistent colors
/// - All text uses proper contrast
/// - All backgrounds are consistent
/// - All error/success states use correct colors
/// - All opacity effects work properly
/// - No visual inconsistencies between screens

/// === BENEFITS ===

/// Benefits of this color standardization:
/// ✅ Consistent visual appearance across all screens
/// ✅ Easy theme switching in the future
/// ✅ Better accessibility with proper contrast ratios
/// ✅ Easier maintenance and updates
/// ✅ Professional, polished look
/// ✅ Reduced color-related bugs
/// ✅ Better developer experience
