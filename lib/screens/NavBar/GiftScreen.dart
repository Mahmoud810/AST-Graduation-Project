import 'package:flutter/material.dart';
import 'package:graduation_project/services/cart_service.dart';
import 'package:graduation_project/models/cart_item_model.dart';
import 'package:graduation_project/constants.dart';
import '../BaseViews/baseview.dart';

class GiftScreen extends StatelessWidget {
  const GiftScreen({super.key});

  final List<Map<String, dynamic>> _offers = const [
    {
      'title': 'Summer Promo - Vitamin C',
      'subtitle': '30% off',
      'image': 'assets/product.jpg',
      'price': 75.0,
    },
    {
      'title': 'Buy 1 Get 1 - Body Lotion',
      'subtitle': 'Limited offer',
      'image': 'assets/product.jpg',
      'price': 45.0,
    },
    {
      'title': 'Free Shipping over 50 JD',
      'subtitle': 'Auto applied',
      'image': 'assets/product.jpg',
      'price': 0.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Promotions & Offers',
      isContainSearch: false, // No search needed for promotions
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _offers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, idx) {
          final item = _offers[idx];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item['image'],
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.appColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.local_offer,
                            color: AppColors.appColor,
                            size: 32,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['subtitle'],
                          style: TextStyle(
                            color: AppColors.textHint,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['price'] > 0
                              ? 'EGP ${item['price'].toStringAsFixed(2)}'
                              : 'Free',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: item['price'] > 0
                                ? AppColors.appColor
                                : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      try {
                        CartService().addItem(
                          CartItem(
                            title: item['title'],
                            imageUrl: item['image'],
                            price: (item['price'] as num).toDouble(),
                            quantity: 1,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${item['title']} added to cart',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: AppColors.appColor,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Failed to add to cart',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
