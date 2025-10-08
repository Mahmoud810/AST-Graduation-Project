import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';

import '../models/cart_item_model.dart';
import '../widgets/cart_item_widget.dart';
import 'payment_summary_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> cartItems = [
    CartItem(
      title: 'Binta Shampoo',
      imageUrl: 'assets/product.jpg',
      quantity: 3,
      price: 30,
    ),
    CartItem(
      title: 'Binta Conditioner',
      imageUrl: 'assets/product.jpg',
      quantity: 2,
      price: 27.5,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    //Correct total: includes quantity
    final double total = cartItems.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    final bool isCartEmpty = cartItems.isEmpty || total == 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: AppColors.appColor,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display empty message or cart items
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

            // Total Section
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

            // ✅ Checkout button (disabled if cart empty)
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
