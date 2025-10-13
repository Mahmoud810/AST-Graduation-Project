import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/models/cart_item_model.dart';
import 'package:graduation_project/screens/cart_screen.dart';

import '../BaseViews/BaseView.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CartItem> cartItems = [];

  // Example list of DIFFERENT products
  final List<CartItem> availableProducts = [
    CartItem(
      title: 'Vitamin C 500 mg',
      imageUrl: 'assets/product.jpg',
      price: 75.0,
      quantity: 1,
    ),
    CartItem(
      title: 'Aloe Vera Gel',
      imageUrl: 'assets/product.jpg',
      price: 60.0,
      quantity: 1,
    ),
    CartItem(
      title: 'Hair Serum',
      imageUrl: 'assets/product.jpg',
      price: 90.0,
      quantity: 1,
    ),
    CartItem(
      title: 'Binta Shampoo',
      imageUrl: 'assets/product.jpg',
      price: 45.0,
      quantity: 1,
    ),
    CartItem(
      title: 'Coconut Oil',
      imageUrl: 'assets/product.jpg',
      price: 50.0,
      quantity: 1,
    ),
  ];

  void addToCart(CartItem item) {
    setState(() {
      final existingIndex = cartItems.indexWhere((e) => e.title == item.title);
      if (existingIndex != -1) {
        cartItems[existingIndex].quantity += 1;
      } else {
        cartItems.add(
          CartItem(
            title: item.title,
            imageUrl: item.imageUrl,
            price: item.price,
            quantity: 1,
          ),
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item.title} added to cart"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: "Body Care",
      isContainSearch: true,
      onSearchChanged: (query) => print("Searching: $query"),
      onCartPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CartScreen(cartItems: cartItems)),
        );
      },
      onNotificationPressed: () => print("Notification pressed"),
      onMenuPressed: () => print("Menu pressed"),

      // Main product grid
      body: Padding(
        padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
        child: Stack(
          children: [
            GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: availableProducts.length,
              itemBuilder: (context, index) {
                final product = availableProducts[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.asset(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                            //position for cart icon
                            Positioned(
                              bottom: 10,
                              right: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add_shopping_cart,
                                    color: AppColors.appColor,
                                    size: 20,
                                  ),
                                  onPressed: () => addToCart(product),
                                  constraints: const BoxConstraints(),
                                  padding: const EdgeInsets.all(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "EGP ${product.price.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
