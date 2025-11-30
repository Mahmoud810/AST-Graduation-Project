import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../components/custom_loading_indicator.dart';
import '../../../constants.dart';
import '../utils/extensions/app_common.dart';

/// Global Loading Service for managing loading states across the app
class LoadingService {
  static final LoadingService _instance = LoadingService._internal();
  factory LoadingService() => _instance;
  LoadingService._internal();

  OverlayEntry? _overlayEntry;
  bool _isLoading = false;

  /// Show loading overlay
  void showLoading(BuildContext context, {String? message}) {
    if (_isLoading) return; // Prevent multiple overlays

    _isLoading = true;
    _overlayEntry = OverlayEntry(
      builder: (context) => _LoadingOverlay(message: message),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  /// Hide loading overlay
  void hideLoading() {
    if (!_isLoading || _overlayEntry == null) return;

    _isLoading = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Execute async operation with loading indicator
  Future<T> withLoading<T>(
    BuildContext context,
    Future<T> Function() operation, {
    String? message,
  }) async {
    try {
      showLoading(context, message: message);
      final result = await operation();
      return result;
    } finally {
      hideLoading();
    }
  }

  /// Check if loading is currently showing
  bool get isLoading => _isLoading;
}

/// Custom Loading Overlay Widget
class _LoadingOverlay extends StatelessWidget {
  final String? message;

  const _LoadingOverlay({this.message});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballScale,
                    colors: [AppColors.appColor],
                    strokeWidth: 2,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    message!,
                    style: primaryTextStyle(
                      color: AppColors.textDark,
                      size: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension for easy loading usage
extension LoadingServiceExtension on BuildContext {
  /// Show loading indicator
  void showLoading({String? message}) {
    LoadingService().showLoading(this, message: message);
  }

  /// Hide loading indicator
  void hideLoading() {
    LoadingService().hideLoading();
  }

  /// Execute operation with loading
  Future<T> withLoading<T>(
    Future<T> Function() operation, {
    String? message,
  }) {
    return LoadingService().withLoading<T>(this, operation, message: message);
  }
}
