// cart_screen.dart
import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/screens/BaseViews/BaseBackView.dart';

import '../models/cart_item_model.dart';
import '../widgets/cart_item_widget.dart';
import 'payment_summary_screen.dart';

class CartScreen extends StatefulWidget {
  final List<CartItem> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = List.from(widget.cartItems); // clone list
  }

  @override
  Widget build(BuildContext context) {
    final double total = cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    final bool isCartEmpty = cartItems.isEmpty || total == 0;

    return BaseBackView(
      title: 'My Cart',
      onBackPressed: () => Navigator.pop(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                cartItems.isEmpty
                    ? 'Your cart is empty'
                    : 'You have ${cartItems.length} item${cartItems.length > 1 ? 's' : ''} in cart',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(
                      child: Text(
                        'Your cart is empty.',
                        style: TextStyle(fontSize: 18, color: AppColors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return CartItemWidget(
                          item: cartItems[index],
                          onDelete: () {
                            setState(() {
                              cartItems.removeAt(index);
                            });
                          },
                        );
                      },
                    ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  'EGP ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isCartEmpty
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentSummaryScreen(subtotal: total),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: isCartEmpty
                    ? AppColors.grey
                    : AppColors.appColor,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Check Out', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
