import 'package:flutter/material.dart';
import 'package:graduation_project/screens/BaseViews/BaseBackView.dart';
import '../../../constants.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const ProductDetailsScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseBackView(
      body: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 32.0,
          ), // to add some space at bottom
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),

              // 🖼️ Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(125),
                child: Image.asset(
                  image,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // 🏷️ Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // 📝 Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  description,
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),

              const SizedBox(height: 32),

              // 🛒 Add to Cart Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to cart!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
              Text("only for test"),
            ],
          ),
        ),
      ),
      title: 'Product Details',
    );
  }
}
