// HomeScreen.dart

import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import '../BaseViews/BaseView.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: "Body Care",
      isContainSearch: true, 
      onSearchChanged: (query) => print("Searching: $query"),
      onFilterPressed: () => print("Filter pressed"),
      onNotificationPressed: () => print("Notifications pressed"),
      onMenuPressed: () => print("Menu pressed"),

      // body: keep it simple — BaseView already draws the top rounded header,
      // so don't duplicate the top radii here. Use padding to separate content.
      body: Padding(
        padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 10,
          itemBuilder: (context, index) => Container(
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
                  child: Image.asset("assets/product.jpg", fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
                const Text("Vitamin C 500 mg"),
                const Text(
                  "JD 75.000",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
