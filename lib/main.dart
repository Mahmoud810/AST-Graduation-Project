import 'package:flutter/material.dart';
import 'screens/home.dart'; // Create this file
import 'navBar.dart'; // Create this file
import 'package:supabase_auth_ui/supabase_auth_ui.dart'; // Example of another import

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Graduation Project",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NavBar(),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:graduation_project/screens/home.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:supabase_auth_ui/supabase_auth_ui.dart';
// import 'package:flutter/foundation.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Supabase.initialize(
//     url: 'https://pmhehvwzzorccrvresov.supabase.co',
//     anonKey:
//         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBtaGVodnd6em9yY2NydnJlc292Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0OTk1NTUsImV4cCI6MjA3NTA3NTU1NX0.Yb2qbfZfXi2BaT4lNxC6PCHf39AOr-YLgg8Hkzlfzws',
//   );

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Supabase Auth Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const AuthPage(),
//     );
//   }
// }

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Supabase Email Auth")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SupaEmailAuth(
//           redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
//           onSignInComplete: (response) {
//             if (response.session != null) {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => const HomeScreen()),
//               );
//             }
//           },
//           onSignUpComplete: (response) {
//             final user = Supabase.instance.client.auth.currentUser;
//             print(user?.userMetadata?['username']);
//             print(user?.userMetadata?['full_name']);
//             if (response.user != null) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text("Signup successful!")),
//               );
//             }
//           },
//           metadataFields: [
//             MetaDataField(
//               prefixIcon: const Icon(Icons.person),
//               label: 'Username',
//               key: 'username',
//               validator: (val) {
//                 if (val == null || val.isEmpty) {
//                   return 'Please enter something';
//                 }
//                 return null;
//               },
//             ),
//             MetaDataField(
//               prefixIcon: const Icon(Icons.badge),
//               label: "Name",
//               key: "Name",
//               validator: (val) {
//                 if (val == null || val.isEmpty) {
//                   return 'Please enter your name';
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
