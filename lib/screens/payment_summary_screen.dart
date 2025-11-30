import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart' show AppColors;
import 'package:graduation_project/screens/BaseViews/BaseBackView.dart';
import 'package:graduation_project/data/services/cart_service.dart' as firebase_cart;

import 'add_address_screen.dart';

class PaymentSummaryScreen extends StatefulWidget {
  final double subtotal;

  const PaymentSummaryScreen({super.key, required this.subtotal});

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  // Cash is the only payment method - pre-selected by default
  final String selectedPayment = 'cash';
  String selectedAddressOption = 'same';
  bool _isProcessing = false;

  // Firebase cart service for clearing cart
  final firebase_cart.CartService _cartService = firebase_cart.CartService();

  Future<void> _completeOrder() async {
    if (_isProcessing) return;
    
    setState(() => _isProcessing = true);

    try {
      // Handle different billing address if selected
      if (selectedAddressOption == 'different') {
        final newAddress = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddAddressScreen()),
        );
        if (newAddress == null) {
          setState(() => _isProcessing = false);
          return;
        }
      }

      // Clear the cart after successful order
      await _cartService.clearCart();

      // Navigate to home and remove all previous routes
      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Order placed successfully! Your order will arrive in 30 minutes.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to home screen and clear navigation stack
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing order: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double deliveryFee = 20;
    double total = widget.subtotal + deliveryFee;

    return BaseBackView(
      title: "Checkout",
      onBackPressed: () => Navigator.pop(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === ORDER SUMMARY HEADER ===
            const Text(
              'Order Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Review your order details before confirming.',
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            // === PAYMENT METHOD (Cash Only) ===
            const Text(
              'Payment Method',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            
            // Cash Payment Card - Pre-selected and only option
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.appColor.withOpacity(0.1),
                border: Border.all(
                  color: AppColors.appColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.appColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.payments_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cash on Delivery',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Pay when you receive your order',
                          style: TextStyle(
                            color: AppColors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.appColor,
                    size: 24,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // === DELIVERY ADDRESS ===
            const Text(
              'Delivery Address',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildAddressOption('same', 'Same as shipping address'),
            _buildAddressOption('different', 'Use a different billing address'),

            const Spacer(),

            // === PRICE BREAKDOWN ===
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildPriceRow('Subtotal', widget.subtotal),
                  const SizedBox(height: 8),
                  _buildPriceRow('Delivery Fee', deliveryFee),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        'EGP ${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: AppColors.appColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // === COMPLETE ORDER BUTTON ===
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: _isProcessing ? null : _completeOrder,
              child: _isProcessing
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Complete Order',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.grey,
            fontSize: 15,
          ),
        ),
        Text(
          'EGP ${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressOption(String value, String label) {
    final isSelected = selectedAddressOption == value;
    return GestureDetector(
      onTap: () => setState(() => selectedAddressOption = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.appColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.appColor : AppColors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
