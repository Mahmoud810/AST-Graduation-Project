import 'package:flutter/material.dart';
// import 'package:graduation_project/core/core/theme/colors.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/core/core/assets/genImages/imageAssets.dart';
import 'screens/NavBar/HomeScreen.dart';
import 'screens/NavBar/GiftScreen.dart';
import 'screens/NavBar/FavouriteScreen.dart';
import 'screens/NavBar/UploadScreen.dart';
// const Color AppColors.appbarColor = Colors.blue; // Define your app color here

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    GiftScreen(), // Temporary - replace with your actual screens
    FavouriteScreen(),
    UploadScreen(),
    // SearchScreen(),
    // ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem buildNavItem(
    String assetPath,
    String label,
    int index,
  ) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        assetPath,
        width: 24,
        height: 24,
        color: _selectedIndex == index ? AppColors.appColor : AppColors.grey,
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.appColor,
        unselectedItemColor: AppColors.grey,
        // items: [
        //   buildNavItem(Icons.home, "", 0),
        //   buildNavItem(Icons.search, "", 1), // Added second item
        //   // buildNavItem(Icons.person, "Profile", 2), // Optional third item
        // ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          buildNavItem(Assets.resourceScreensHome, "", 0),
          buildNavItem(Assets.resourceScreensGift, "", 1), // Added second item
          buildNavItem(Assets.resourceScreensHeart, "", 2),
          buildNavItem(Assets.resourceScreensSheetPlastic, "", 3),
          // buildNavItem(Icons.person, "Profile", 2), // Optional third item
        ],
      ),
    );
  }
}
