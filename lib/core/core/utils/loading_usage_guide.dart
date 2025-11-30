import 'package:flutter/material.dart';
import 'package:graduation_project/core/core/services/loading_service.dart';
import '../widgets/stream_loading_widget.dart';

/// LOADING INDICATORS USAGE GUIDE
///
/// This file demonstrates how to use the loading indicators throughout the app.
///
/// IMPORT THE SERVICES:
/// import '../../core/core/services/loading_service.dart';
/// import '../../core/core/widgets/stream_loading_widget.dart';
///
/// 1. OVERLAY LOADING FOR NETWORK OPERATIONS
/// Use this for one-time operations like API calls, uploads, sign-in, etc.
///
/// EXAMPLE IN WIDGET:
///
/// Future<void> _uploadData() async {
///   try {
///     final result = await context.withLoading(
///       () => _apiService.uploadData(data),
///       message: 'Uploading data...',
///     );
///
///     // Handle success
///   } catch (e) {
///     // Handle error
///   }
/// }
///
/// 2. STREAM LOADING FOR FIREBASE DATA
/// Use this for real-time data like Firestore streams.
///
/// EXAMPLE IN WIDGET:
///
/// Widget _buildUserData() {
///   return StreamLoadingWidget<UserData>(
///     stream: _userService.getUserDataStream(),
///     loadingMessage: 'Loading user data...',
///     emptyBuilder: () => Center(
///       child: Text('No user data found'),
///     ),
///     errorBuilder: (error) => Center(
///       child: Text('Error: ${error.toString()}'),
///     ),
///     builder: (userData) {
///       return UserProfileWidget(userData: userData);
///     },
///   );
/// }
///
/// 3. FUTURE LOADING FOR ONE-TIME DATA
/// Use this for one-time data fetching.
///
/// EXAMPLE IN WIDGET:
///
/// Widget _buildProductDetails() {
///   return FutureLoadingWidget<Product>(
///     future: _productService.getProductById(productId),
///     loadingMessage: 'Loading product details...',
///     errorBuilder: (error) => Center(
///       child: Column(
///         children: [
///           Icon(Icons.error),
///           Text('Failed to load product'),
///           ElevatedButton(
///             onPressed: () => setState(() {}),
///             child: Text('Retry'),
///           ),
///         ],
///       ),
///     ),
///     builder: (product) {
///       return ProductDetailWidget(product: product);
///     },
///   );
/// }
///
/// 4. CUSTOM LOADING MESSAGES
/// Provide specific messages for better UX:
///
/// - 'Signing in...'
/// - 'Uploading prescriptions...\n3 image(s)'
/// - 'Loading products...'
/// - 'Saving changes...'
/// - 'Deleting item...'
///
/// 5. MANUAL LOADING CONTROL
/// For complex scenarios, you can control loading manually:
///
/// void _startOperation() {
///   context.showLoading(message: 'Processing...');
///
///   _someAsyncOperation().then((result) {
///     context.hideLoading();
///     // Handle success
///   }).catchError((error) {
///     context.hideLoading();
///     // Handle error
///   });
/// }
///
/// 6. BEST PRACTICES
///
/// - Always provide meaningful loading messages
/// - Include retry buttons in error states
/// - Show empty states when appropriate
/// - Use overlay loading for blocking operations
/// - Use stream/future loading for data display
/// - Handle all error states gracefully
///
/// 7. COMMON PATTERNS
///
/// SIGN-IN SCREEN:
/// await context.withLoading(() => _auth.signInWithEmailAndPassword(...));
///
/// UPLOAD SCREEN:
/// await context.withLoading(() => _storageService.uploadFile(file));
///
/// DATA LIST SCREEN:
/// StreamLoadingWidget<List<Item>>(stream: _service.getItemsStream(), ...)
///
/// DETAIL SCREEN:
/// FutureLoadingWidget<Item>(future: _service.getItemById(id), ...)
///
/// FORM SUBMISSION:
/// await context.withLoading(() => _service.submitForm(formData));

/// EXAMPLE IMPLEMENTATIONS FOR COMMON SCENARIOS

class LoadingExamples {
  /// Example: Product list with loading
  static Widget buildProductList(Stream<List<Product>> productStream) {
    return StreamLoadingWidget<List<Product>>(
      stream: productStream,
      loadingMessage: 'Loading products...',
      emptyBuilder: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64),
            Text('No products found'),
            ElevatedButton(
              onPressed: () {
                /* Refresh */
              },
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
      errorBuilder: (error) => Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48),
            Text('Failed to load products'),
            Text(error.toString(), style: TextStyle(fontSize: 12)),
            ElevatedButton(
              onPressed: () {
                /* Retry */
              },
              child: Text('Retry'),
            ),
          ],
        ),
      ),
      builder: (products) => ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => ProductCard(product: products[index]),
      ),
    );
  }

  /// Example: Form submission with loading
  static Future<void> submitForm(BuildContext context, FormData data) async {
    try {
      await context.withLoading(
        () => _submitForm(data),
        message: 'Submitting form...',
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Form submitted successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: ${e.toString()}')),
      );
    }
  }

  static Future<void> _submitForm(FormData data) async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));
    if (data.email.isEmpty) throw Exception('Email is required');
  }
}

// Mock classes for demonstration
class Product {
  final String name;
  Product(this.name);
}

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(product.name));
  }
}

class FormData {
  String email = '';
}
