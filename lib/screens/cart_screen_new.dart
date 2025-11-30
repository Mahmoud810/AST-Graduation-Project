import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/data/models/cart_item_model.dart';
import 'package:graduation_project/data/services/cart_service.dart';
import 'package:graduation_project/screens/BaseViews/BaseBackView.dart';
import 'package:graduation_project/screens/payment_summary_screen.dart';

class CartScreenNew extends StatefulWidget {
  const CartScreenNew({super.key});

  @override
  State<CartScreenNew> createState() => _CartScreenNewState();
}

class _CartScreenNewState extends State<CartScreenNew> {
  final CartService _cartService = CartService();

  Future<void> _increaseQuantity(CartItem item) async {
    await _cartService.increaseQuantity(item.id);
  }

  Future<void> _decreaseQuantity(CartItem item) async {
    await _cartService.decreaseQuantity(item.id);
  }

  Future<void> _removeItem(CartItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Remove ${item.productName} from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _cartService.removeFromCart(item.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.productName} removed from cart'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  double _calculateTotal(List<CartItem> cartItems) {
    return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackView(
      title: 'My Cart',
      onBackPressed: () => Navigator.pop(context),
      body: StreamBuilder<List<CartItem>>(
        stream: _cartService.getUserCart(),
        builder: (context, snapshot) {
          // Loading state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.appColor),
              ),
            );
          }

          // Error state
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading cart',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final cartItems = snapshot.data ?? [];
          final total = _calculateTotal(cartItems);
          final isCartEmpty = cartItems.isEmpty;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Cart item count
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    isCartEmpty
                        ? 'Your cart is empty'
                        : 'You have ${cartItems.length} item${cartItems.length > 1 ? 's' : ''} in cart',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Cart items list or empty state
                Expanded(
                  child: isCartEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 100,
                                color: AppColors.grey.withOpacity(0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Your cart is empty',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add some products to get started',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final item = cartItems[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    // Product Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: item.productImage.startsWith('http')
                                          ? Image.network(
                                              item.productImage,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Container(
                                                width: 80,
                                                height: 80,
                                                color: AppColors.grey.withOpacity(0.2),
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                            )
                                          : Image.asset(
                                              item.productImage,
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) =>
                                                  Container(
                                                width: 80,
                                                height: 80,
                                                color: AppColors.grey.withOpacity(0.2),
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  color: AppColors.grey,
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(width: 12),

                                    // Product Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.productName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'EGP ${item.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 8),

                                          // Quantity Controls
                                          Row(
                                            children: [
                                              // Decrease button
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: AppColors.appColor,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(Icons.remove),
                                                  iconSize: 18,
                                                  color: AppColors.appColor,
                                                  padding: const EdgeInsets.all(4),
                                                  constraints: const BoxConstraints(),
                                                  onPressed: () => _decreaseQuantity(item),
                                                ),
                                              ),
                                              const SizedBox(width: 8),

                                              // Quantity
                                              Text(
                                                item.quantity.toString(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 8),

                                              // Increase button
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.appColor,
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(Icons.add),
                                                  iconSize: 18,
                                                  color: AppColors.white,
                                                  padding: const EdgeInsets.all(4),
                                                  constraints: const BoxConstraints(),
                                                  onPressed: () => _increaseQuantity(item),
                                                ),
                                              ),
                                              const Spacer(),

                                              // Total price for item
                                              Flexible(
                                                child: Text(
                                                  'EGP ${item.totalPrice.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.appColor,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Delete button
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: AppColors.red,
                                      ),
                                      onPressed: () => _removeItem(item),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Bottom section with total and checkout
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL',
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
                const SizedBox(height: 16),

                // Checkout button
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
                    backgroundColor:
                        isCartEmpty ? AppColors.grey : AppColors.appColor,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: isCartEmpty ? 0 : 2,
                  ),
                  child: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
