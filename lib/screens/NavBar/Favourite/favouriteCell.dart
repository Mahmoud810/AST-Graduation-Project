import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../ProductDetails/ProductDetails.dart';

class CustomCell extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const CustomCell({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(image, width: 56, height: 56, fit: BoxFit.cover),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.favorite,
          color: AppColors.appColor,
          size: 20,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(
                title: title,
                description: subtitle,
                image: image,
              ),
            ),
          );
        },
      ),
    );
  }
}
