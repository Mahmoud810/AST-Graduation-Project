import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/data/models/product_model.dart';
import 'package:graduation_project/data/services/cart_service.dart';
import 'package:graduation_project/data/services/favourite_service.dart';
import 'package:graduation_project/data/services/product_service.dart';
import 'package:graduation_project/data/services/user_service.dart';
import 'package:graduation_project/screens/Authentication/signin_screen.dart';
import 'package:graduation_project/screens/cart_screen_new.dart';
import 'package:graduation_project/screens/ProductDetails/product_details_screen.dart';
import 'package:graduation_project/widgets/drawer/drawer.dart';

import '../BaseViews/BaseView.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
  final FavouriteService _favouriteService = FavouriteService();
  final UserService _userService = UserService();

  String _searchQuery = '';
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _loadCartCount();
  }

  Future<void> _initializeUser() async {
    // Ensure user document exists
    await _userService.initializeUserDocument();
  }

  Future<void> _loadCartCount() async {
    final count = await _cartService.getCartItemCount();
    if (mounted) {
      setState(() {
        _cartItemCount = count;
      });
    }
  }

  Future<void> _addToCart(Product product) async {
    final success = await _cartService.addToCart(product);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${product.name} added to cart"),
          duration: const Duration(seconds: 1),
          backgroundColor: AppColors.appColor,
        ),
      );
      _loadCartCount(); // Refresh cart count
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to add to cart"),
          duration: Duration(seconds: 1),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  Future<void> _toggleFavourite(Product product) async {
    final success = await _favouriteService.toggleFavourite(product);
    if (success && mounted) {
      final isFav = await _favouriteService.isProductInFavourites(product.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFav
                ? "${product.name} added to favourites"
                : "${product.name} removed from favourites",
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: AppColors.appColor,
        ),
      );
      setState(() {}); // Refresh to update heart icons
    }
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
        onSearchChanged: (query) {
          setState(() {
            _searchQuery = query.toLowerCase();
          });
        },
        onCartPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CartScreenNew()),
          ).then((_) => _loadCartCount()); // Refresh count when returning
        },
        onNotificationPressed: () => print("Notification pressed"),
        onMenuPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        body: StreamBuilder<List<Product>>(
          stream: _productService.getAllProducts(),
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
                      'Error loading products',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            // Empty state
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 80,
                      color: AppColors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No products available',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Filter products based on search query
            var products = snapshot.data!;
            if (_searchQuery.isNotEmpty) {
              products = products
                  .where((product) =>
                      product.name.toLowerCase().contains(_searchQuery) ||
                      product.description.toLowerCase().contains(_searchQuery))
                  .toList();
            }

            // Products grid
            return Padding(
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
                  return FutureBuilder<bool>(
                    future: _favouriteService.isProductInFavourites(product.id),
                    builder: (context, favSnapshot) {
                      final isFavourite = favSnapshot.data ?? false;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(product: product),
                            ),
                          ).then((_) {
                            // Refresh when returning from details
                            setState(() {});
                            _loadCartCount();
                          });
                        },
                        child: Container(
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
                                  // Product Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: product.imageUrl.startsWith('http')
                                        ? Image.network(
                                            product.imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Container(
                                              color: AppColors.grey.withOpacity(0.2),
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: AppColors.grey,
                                              ),
                                            ),
                                          )
                                        : Image.asset(
                                            product.imageUrl,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Container(
                                              color: AppColors.grey.withOpacity(0.2),
                                              child: const Icon(
                                                Icons.image_not_supported,
                                                size: 50,
                                                color: AppColors.grey,
                                              ),
                                            ),
                                          ),
                                  ),

                                  // Favourite button (top right)
                                  Positioned(
                                    top: 8,
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
                                        icon: Icon(
                                          isFavourite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFavourite
                                              ? AppColors.red
                                              : AppColors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () => _toggleFavourite(product),
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(6),
                                      ),
                                    ),
                                  ),

                                  // Add to cart button (bottom right)
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
                                        onPressed: () => _addToCart(product),
                                        constraints: const BoxConstraints(),
                                        padding: const EdgeInsets.all(6),
                                      ),
                                    ),
                                  ),

                                  // Stock badge
                                  if (product.stockQuantity < 10)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: product.stockQuantity == 0
                                              ? AppColors.red
                                              : Colors.orange,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          product.stockQuantity == 0
                                              ? 'Out of Stock'
                                              : 'Low Stock',
                                          style: const TextStyle(
                                            color: AppColors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                product.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "EGP ${product.price.toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.appColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
