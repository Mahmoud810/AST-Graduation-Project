import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/data/services/user_service.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final _auth = FirebaseAuth.instance;
  final _userService = UserService();

  String userName = '';
  String userEmail = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Initialize user document if it doesn't exist
        await _userService.initializeUserDocument();
        
        // Get user data safely
        final userData = await _userService.getCurrentUserData();
        
        if (mounted) {
          setState(() {
            userName = userData?['displayName'] ?? user.displayName ?? 'User';
            userEmail = userData?['email'] ?? user.email ?? '';
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error loading user data: $e');
        // Fallback to Firebase Auth data
        if (mounted) {
          setState(() {
            userName = user.displayName ?? 'User';
            userEmail = user.email ?? '';
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await _auth.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/getstarted', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAccountsDrawerHeader(
              accountName: _isLoading
                  ? const Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text("Loading..."),
                      ],
                    )
                  : Text(userName.isEmpty ? "User" : userName),
              accountEmail: Text(userEmail.isEmpty ? "..." : userEmail),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              decoration: const BoxDecoration(
                color: AppColors.appColor,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  final items = [
                    {'icon': Icons.home, 'title': 'Home', 'route': '/navbar'},
                    {'icon': Icons.history, 'title': 'My Orders', 'route': null},
                    {'icon': Icons.settings, 'title': 'Settings', 'route': null},
                    {'icon': Icons.admin_panel_settings, 'title': 'Add Sample Data', 'route': '/admin-add-data'},
                  ];
                  return ListTile(
                    leading: Icon(
                      items[index]['icon'] as IconData,
                      color: items[index]['title'] == 'Add Sample Data' 
                          ? AppColors.appColor 
                          : null,
                    ),
                    title: Text(
                      items[index]['title'] as String,
                      style: TextStyle(
                        color: items[index]['title'] == 'Add Sample Data'
                            ? AppColors.appColor
                            : null,
                        fontWeight: items[index]['title'] == 'Add Sample Data'
                            ? FontWeight.w600
                            : null,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      final route = items[index]['route'] as String?;
                      if (route != null) {
                        Navigator.pushNamed(context, route);
                      }
                    },
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
