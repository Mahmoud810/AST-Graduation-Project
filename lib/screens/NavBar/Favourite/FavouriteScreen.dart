import 'package:flutter/material.dart';
import 'package:graduation_project/screens/BaseViews/BaseView.dart';
import '../../BaseViews/BaseBackView.dart';
import 'favouriteCell.dart'; // renamed properly

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Product Name',
        'subtitle': 'product description goes here',
        'image': 'assets/product.jpg',
        'quantity': 1,
      },
      {
        'title': 'Product Name',
        'subtitle': 'product description goes here',
        'image': 'assets/product.jpg',
        'quantity': 2,
      },
      {
        'title': 'Product Name',
        'subtitle': 'product description goes here',
        'image': 'assets/product.jpg',
        'quantity': 3,
      },
    ];

    return BaseView(
      title: 'Favourite Screen',
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return CustomCell(
            title: item['title'],
            subtitle: item['subtitle'],
            image: item['image'],
          );
        },
      ),
    );
  }
}
