import 'package:flutter/material.dart';
import 'screens/home.dart';

const Color appColor = Color(0xFF006A3D); // Define your app color here

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HomeScreen(), // Temporary - replace with your actual screens
    // SearchScreen(),
    // ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem buildNavItem(IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(icon, color: _selectedIndex == index ? appColor : Colors.grey),
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
        selectedItemColor: appColor,
        unselectedItemColor: Colors.grey,
        items: [
          buildNavItem(Icons.home, "", 0),
          buildNavItem(Icons.search, "", 1), // Added second item
          // buildNavItem(Icons.person, "Profile", 2), // Optional third item
        ],
      ),
    );
  }
}
