import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/models/cart_item_model.dart';
import 'package:graduation_project/screens/Authentication/signin_screen.dart';
import 'package:graduation_project/screens/cart_screen.dart';
import 'package:graduation_project/widgets/drawer/drawer.dart';

import '../BaseViews/BaseView.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CartItem> cartItems = [];
  List<CartItem> products = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  // Fetch products from Firestore
  Future<void> fetchProducts() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();

      products = snapshot.docs.map((doc) {
        return CartItem(
          title: doc['title'],
          imageUrl: doc['imageUrl'],
          price: (doc['price'] as num).toDouble(),
          quantity: 1,
        );
      }).toList();

      setState(() => isLoading = false);
    } catch (e) {
      print("Error fetching products: $e");
      setState(() => isLoading = false);
    }
  }

  // Add to cart
  void addToCart(CartItem item) {
    setState(() {
      final existingIndex = cartItems.indexWhere((e) => e.title == item.title);
      if (existingIndex != -1) {
        cartItems[existingIndex].quantity += 1;
      } else {
        cartItems.add(item);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item.title} added to cart"),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),

      body: BaseView(
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
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },

        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : products.isEmpty
            ? const Center(
                child: Text(
                  "No products available",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
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
                                  child: Image.network(
                                    product.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
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
              ),
      ),
    );
  }
}
