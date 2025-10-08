import 'package:flutter/material.dart';

import '../constants.dart';

class BaseView extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onFilterPressed;
  final ValueChanged<String>? onSearchChanged;

  const BaseView({
    super.key,
    required this.title,
    required this.body,
    this.onFilterPressed,
    this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Body background
      body: Column(
        children: [
          // 🟩 Green Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50, // for status bar space
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: const BoxDecoration(
              color: Colors.blue, // Green background like in the image
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () {},
                        ),
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: const [
                        Icon(Icons.notifications_none, color: Colors.white),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Search + Filter
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: const TextStyle(color: Color(0xFF888888)),
                          filled: true,
                          fillColor: AppColors.white,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.white,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: onSearchChanged,
                        style: const TextStyle(color: AppColors.textDark),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Image.asset(
                          "assets/filterIcon.png",
                          color: AppColors.white,
                        ),
                        onPressed: onFilterPressed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🧱 Body content
          Expanded(child: body),
        ],
      ),
    );
  }
}
