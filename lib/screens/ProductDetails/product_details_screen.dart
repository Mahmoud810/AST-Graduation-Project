import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/data/models/product_model.dart';
import 'package:graduation_project/data/services/cart_service.dart';
import 'package:graduation_project/data/services/favourite_service.dart';
import 'package:graduation_project/screens/BaseViews/BaseBackView.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final CartService _cartService = CartService();
  final FavouriteService _favouriteService = FavouriteService();
  
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();
  bool _isFavourite = false;
  int _quantity = 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavouriteStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _checkFavouriteStatus() async {
    final isFav = await _favouriteService.isProductInFavourites(widget.product.id);
    if (mounted) {
      setState(() {
        _isFavourite = isFav;
      });
    }
  }

  Future<void> _toggleFavourite() async {
    setState(() {
      _isFavourite = !_isFavourite;
    });

    final success = await _favouriteService.toggleFavourite(widget.product);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isFavourite
                ? 'Added to favourites'
                : 'Removed from favourites',
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: AppColors.appColor,
        ),
      );

      if (!success) {
        // Revert if failed
        setState(() {
          _isFavourite = !_isFavourite;
        });
      }
    }
  }

  Future<void> _addToCart() async {
    setState(() {
      _isLoading = true;
    });

    final success = await _cartService.addToCart(widget.product, quantity: _quantity);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Added $_quantity item(s) to cart'
                : 'Failed to add to cart',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: success ? AppColors.appColor : AppColors.red,
        ),
      );
    }
  }

  Widget _buildImageSlider() {
    final images = widget.product.images;
    
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final imageUrl = images[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.1),
                ),
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildPlaceholder(),
                      )
                    : imageUrl.isNotEmpty && !imageUrl.startsWith('http')
                        ? Image.asset(
                            imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
              );
            },
          ),
        ),
        if (images.length > 1) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              images.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentImageIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentImageIndex == index
                      ? AppColors.appColor
                      : AppColors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/pharmacy_logo.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.medical_services,
              size: 80,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'No image available',
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.appColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackView(
      title: 'Product Details',
      onBackPressed: () => Navigator.pop(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Slider
                _buildImageSlider(),
                const SizedBox(height: 24),

                // Product Name & Favourite Button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isFavourite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavourite ? AppColors.red : AppColors.grey,
                        size: 28,
                      ),
                      onPressed: _toggleFavourite,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Category
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.appColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.product.category,
                    style: const TextStyle(
                      color: AppColors.appColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Price
                Text(
                  'EGP ${widget.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.appColor,
                  ),
                ),
                const SizedBox(height: 8),

                // Stock Status
                Row(
                  children: [
                    Icon(
                      widget.product.stockQuantity > 0
                          ? Icons.check_circle
                          : Icons.cancel,
                      color: widget.product.stockQuantity > 0
                          ? Colors.green
                          : AppColors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.product.stockQuantity > 0
                          ? 'In Stock (${widget.product.stockQuantity} remaining)'
                          : 'Out of Stock',
                      style: TextStyle(
                        fontSize: 16,
                        color: widget.product.stockQuantity > 0
                            ? Colors.green
                            : AppColors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description
                _buildInfoSection('Description', widget.product.description),

                // Manufacturer
                if (widget.product.manufacturer != null)
                  _buildInfoSection('Manufacturer', widget.product.manufacturer!),

                // Dosage
                if (widget.product.dosage != null)
                  _buildInfoSection('Dosage', widget.product.dosage!),

                // Side Effects
                if (widget.product.sideEffects != null)
                  _buildInfoSection('Side Effects', widget.product.sideEffects!),

                const SizedBox(height: 100), // Space for bottom buttons
              ],
            ),
          ),

          // Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Quantity Selector
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.appColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _quantity > 1
                              ? () {
                                  setState(() {
                                    _quantity--;
                                  });
                                }
                              : null,
                          color: AppColors.appColor,
                        ),
                        Text(
                          _quantity.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _quantity < widget.product.stockQuantity
                              ? () {
                                  setState(() {
                                    _quantity++;
                                  });
                                }
                              : null,
                          color: AppColors.appColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Add to Cart Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.product.stockQuantity > 0 && !_isLoading
                          ? _addToCart
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appColor,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: AppColors.grey,
                      ),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.shopping_cart),
                      label: Text(
                        _isLoading ? 'Adding...' : 'Add to Cart',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
