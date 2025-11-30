import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'constants.dart';
import 'screens/Authentication/splash_screen.dart';
import 'screens/Authentication/signin_screen.dart';
import 'screens/Authentication/signup_screen.dart';
import 'NavBar.dart';
import 'screens/Authentication/Get_Started.dart';
import 'screens/Admin/add_sample_data_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // === COLOR SCHEME ===
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.appColor,
          brightness: Brightness.light,
          primary: AppColors.appColor,
          secondary: AppColors.surface,
          surface: AppColors.surface,
          background: AppColors.background,
          error: AppColors.error,
          onPrimary: AppColors.white,
          onSecondary: AppColors.textDark,
          onSurface: AppColors.textDark,
          onBackground: AppColors.textDark,
          onError: AppColors.white,
        ),
        
        // === APP BAR THEME ===
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.appColor,
          foregroundColor: AppColors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(
            color: AppColors.white,
          ),
        ),
        
        // === TEXT THEME ===
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: AppColors.textDark,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: TextStyle(
            color: AppColors.textDark,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textDark,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          bodySmall: TextStyle(
            color: AppColors.grey,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
          labelLarge: TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        
        // === BUTTON THEME ===
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.appColor,
            foregroundColor: AppColors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // === INPUT DECORATION THEME ===
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            borderSide: BorderSide(color: AppColors.greyLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            borderSide: const BorderSide(color: AppColors.appColor, width: 2),
          ),
          hintStyle: TextStyle(
            color: AppColors.textHint,
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        
        // === CARD THEME ===
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
        ),
        
        // === SCAFFOLD THEME ===
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const SplashScreen(),
      routes: {
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const NavBar(),
        '/navbar': (context) => const NavBar(),
        '/getstarted': (context) => const GetStarted(),
        '/admin-add-data': (context) => const AddSampleDataScreen(),
      },
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
