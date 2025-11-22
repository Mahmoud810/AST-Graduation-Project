import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/data/models/favourite_item_model.dart';
import 'package:graduation_project/data/services/cart_service.dart';
import 'package:graduation_project/data/services/favourite_service.dart';
import 'package:graduation_project/data/services/product_service.dart';
import '../../BaseViews/BaseView.dart';

class FavouriteScreenNew extends StatefulWidget {
  const FavouriteScreenNew({super.key});

  @override
  State<FavouriteScreenNew> createState() => _FavouriteScreenNewState();
}

class _FavouriteScreenNewState extends State<FavouriteScreenNew> {
  final FavouriteService _favouriteService = FavouriteService();
  final CartService _cartService = CartService();
  final ProductService _productService = ProductService();

  Future<void> _removeFromFavourites(FavouriteItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Favourite'),
        content: Text('Remove ${item.productName} from favourites?'),
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
      await _favouriteService.removeFromFavourites(item.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.productName} removed from favourites'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }

  Future<void> _addToCart(FavouriteItem item) async {
    // Get the full product details
    final product = await _productService.getProductById(item.productId);
    if (product != null) {
      final success = await _cartService.addToCart(product);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.productName} added to cart'),
            duration: const Duration(seconds: 1),
            backgroundColor: AppColors.appColor,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add to cart'),
            duration: Duration(seconds: 1),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Favourites',
      isContainSearch: false,
      onMenuPressed: () {},
      onNotificationPressed: () {},
      body: StreamBuilder<List<FavouriteItem>>(
        stream: _favouriteService.getUserFavourites(),
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
                    'Error loading favourites',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final favouriteItems = snapshot.data ?? [];
          final isFavouritesEmpty = favouriteItems.isEmpty;

          // Empty state
          if (isFavouritesEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: AppColors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favourites yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start adding products to your favourites',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          // Favourites list
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favouriteItems.length,
            itemBuilder: (context, index) {
              final item = favouriteItems[index];
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
                              item.productDescription,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'EGP ${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.appColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Action buttons
                      Column(
                        children: [
                          // Add to cart button
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.appColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.add_shopping_cart,
                                color: AppColors.white,
                              ),
                              onPressed: () => _addToCart(item),
                              tooltip: 'Add to cart',
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Remove from favourites button
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.favorite,
                                color: AppColors.red,
                              ),
                              onPressed: () => _removeFromFavourites(item),
                              tooltip: 'Remove from favourites',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
