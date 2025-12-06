import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../components/custom_loading_indicator.dart';
import '../theme/colors.dart';
import '../utils/extensions/app_common.dart';

/// Widget for handling StreamBuilder with loading states
class StreamLoadingWidget<T> extends StatelessWidget {
  final Stream<T> stream;
  final Widget Function(T data) builder;
  final Widget Function(Object? error)? errorBuilder;
  final Widget Function()? emptyBuilder;
  final String? loadingMessage;
  final Widget? customLoadingWidget;

  const StreamLoadingWidget({
    super.key,
    required this.stream,
    required this.builder,
    this.errorBuilder,
    this.emptyBuilder,
    this.loadingMessage,
    this.customLoadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return customLoadingWidget ??
              _LoadingWidget(message: loadingMessage ?? 'Loading...');
        }

        // Error state
        if (snapshot.hasError) {
          return errorBuilder?.call(snapshot.error) ??
              _ErrorWidget(error: snapshot.error);
        }

        // No data state
        if (!snapshot.hasData || snapshot.data == null) {
          return emptyBuilder?.call() ?? const _EmptyWidget();
        }

        // Handle list data
        if (snapshot.data is List && (snapshot.data as List).isEmpty) {
          return emptyBuilder?.call() ?? const _EmptyWidget();
        }

        // Data loaded
        return builder(snapshot.data as T);
      },
    );
  }
}

/// Widget for handling FutureBuilder with loading states
class FutureLoadingWidget<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T data) builder;
  final Widget Function(Object? error)? errorBuilder;
  final Widget Function()? emptyBuilder;
  final String? loadingMessage;
  final Widget? customLoadingWidget;

  const FutureLoadingWidget({
    super.key,
    required this.future,
    required this.builder,
    this.errorBuilder,
    this.emptyBuilder,
    this.loadingMessage,
    this.customLoadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return customLoadingWidget ??
              _LoadingWidget(message: loadingMessage ?? 'Loading...');
        }

        // Error state
        if (snapshot.hasError) {
          return errorBuilder?.call(snapshot.error) ??
              _ErrorWidget(error: snapshot.error);
        }

        // No data state
        if (!snapshot.hasData || snapshot.data == null) {
          return emptyBuilder?.call() ?? const _EmptyWidget();
        }

        // Handle list data
        if (snapshot.data is List && (snapshot.data as List).isEmpty) {
          return emptyBuilder?.call() ?? const _EmptyWidget();
        }

        // Data loaded
        return builder(snapshot.data as T);
      },
    );
  }
}

/// Custom loading widget
class _LoadingWidget extends StatelessWidget {
  final String message;

  const _LoadingWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 60,
            height: 60,
            child: LoadingIndicator(
              indicatorType: Indicator.ballScale,
              colors: [AppColors.primaryColor],
              strokeWidth: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: primaryTextStyle(color: AppColors.text1Color, size: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Custom error widget
class _ErrorWidget extends StatelessWidget {
  final Object? error;

  const _ErrorWidget({this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.redColor, size: 50),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: primaryTextStyle(
              color: AppColors.text1Color,
              size: 16,
              weight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error?.toString() ?? 'Unknown error',
            style: primaryTextStyle(color: AppColors.text1Color, size: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // try a safer retry: pop if possible, otherwise do nothing
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

/// Custom empty widget
class _EmptyWidget extends StatelessWidget {
  const _EmptyWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, color: AppColors.text1Color, size: 64),
          const SizedBox(height: 16),
          Text(
            'No data available',
            style: primaryTextStyle(
              color: AppColors.text1Color,
              size: 16,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Extension for easy usage
extension StreamLoadingExtension on Stream {
  Widget withLoading<T>({
    required Widget Function(T data) builder,
    Widget Function(Object? error)? errorBuilder,
    Widget Function()? emptyBuilder,
    String? loadingMessage,
    Widget? customLoadingWidget,
  }) {
    return StreamLoadingWidget<T>(
      stream: this as Stream<T>,
      builder: builder,
      errorBuilder: errorBuilder,
      emptyBuilder: emptyBuilder,
      loadingMessage: loadingMessage,
      customLoadingWidget: customLoadingWidget,
    );
  }
}

extension FutureLoadingExtension on Future {
  Widget withLoading<T>({
    required Widget Function(T data) builder,
    Widget Function(Object? error)? errorBuilder,
    Widget Function()? emptyBuilder,
    String? loadingMessage,
    Widget? customLoadingWidget,
  }) {
    return FutureLoadingWidget<T>(
      future: this as Future<T>,
      builder: builder,
      errorBuilder: errorBuilder,
      emptyBuilder: emptyBuilder,
      loadingMessage: loadingMessage,
      customLoadingWidget: customLoadingWidget,
    );
  }
}
