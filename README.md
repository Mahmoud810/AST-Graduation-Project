# 🏥 Pharmacy Application - Graduation Project

A comprehensive Flutter-based mobile application for digital pharmacy services, including product browsing, cart management, prescription uploads, and secure checkout.

## 📋 Project Overview

This pharmacy application provides users with a modern, intuitive platform to:
- Browse and search pharmacy products
- Manage shopping cart with real-time updates
- Upload and manage medical prescriptions
- Complete secure checkout process
- Track order history and status

## 🛠️ Technology Stack

### Frontend
- **Flutter 3.8.1+** - Cross-platform mobile framework
- **Dart** - Programming language
- **GetX** - State management and navigation
- **Glassmorphism UI** - Modern design system

### Backend
- **Firebase Authentication** - Secure user management
- **Cloud Firestore** - NoSQL database
- **Firebase Storage** - Image and file storage
- **Firebase Analytics** - User behavior tracking
- **Firebase Crashlytics** - Error reporting

### Key Dependencies
- `dio` - HTTP client for API requests
- `cached_network_image` - Image optimization
- `firebase_auth` - Authentication service
- `cloud_firestore` - Database service
- `firebase_storage` - File storage
- `geolocator` - Location services
- `shared_preferences` - Local storage

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── constants.dart            # App constants
├── firebase_options.dart     # Firebase configuration
├── core/                     # Core utilities and themes
│   ├── constants/            # App constants
│   ├── themes/               # App themes
│   ├── utils/                # Utility functions
│   └── widgets/              # Reusable widgets
├── data/                     # Data layer
│   ├── models/               # Data models
│   ├── repositories/         # Repository pattern
│   └── services/             # Service classes
├── screens/                  # UI screens
│   ├── Authentication/       # Login/Register screens
│   ├── Home/                 # Home and product screens
│   ├── ProductDetails/       # Product detail screens
│   ├── Cart/                 # Cart management screens
│   ├── Checkout/             # Checkout process screens
│   └── BaseViews/            # Base view controllers
├── widgets/                  # Custom widgets
│   ├── custom/               # Custom UI components
│   ├── forms/                # Form widgets
│   └── common/               # Common widgets
└── models/                   # Data models
    ├── user.dart             # User model
    ├── product.dart          # Product model
    ├── cart.dart             # Cart model
    └── order.dart            # Order model
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK compatible with Flutter version
- Firebase project configured
- Android Studio / VS Code
- Physical device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pharmacy-app-graduation.git
   cd pharmacy-app-graduation
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android and iOS apps to your Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`

4. **Configure Firebase**
   - Enable Authentication (Email/Password)
   - Set up Firestore Database
   - Configure Firebase Storage
   - Set up security rules (see documentation)

5. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Features

### 🔐 Authentication
- User registration and login
- Email/password authentication
- Password recovery
- Session management

### 🛍️ Product Management
- Browse pharmacy products by category
- Search products with filters
- Product detail views with images
- Product ratings and reviews
- Favorites system

### 🛒 Shopping Cart
- Add/remove items from cart
- Real-time quantity updates
- Price calculation
- Cart persistence across sessions

### 💊 Prescription Management
- Upload prescription images
- Camera and gallery integration
- Prescription status tracking
- Link prescriptions to orders

### 📦 Checkout Process
- Order summary and confirmation
- Address management
- Payment method selection
- Order tracking

### 📊 User Profile
- Order history
- Account management
- Address book
- Preferences settings

## 🔧 Configuration

### Firebase Configuration
Update `firebase_options.dart` with your Firebase project configuration:

```dart
const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "your-api-key",
  authDomain: "your-project.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project.appspot.com",
  messagingSenderId: "your-sender-id",
  appId: "your-app-id",
);
```

### Environment Variables
Create a `.env` file in the root directory:

```env
FIREBASE_API_KEY=your-api-key
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project.appspot.com
```

## 📚 Documentation

Comprehensive documentation is available in the `/docs` directory:

- **[PHARMACY_APPLICATION_DOCUMENTATION.md](docs/PHARMACY_APPLICATION_DOCUMENTATION.md)** - Complete project documentation
- **[DATABASE_DESIGN.md](docs/DATABASE_DESIGN.md)** - Database schema and design
- **[FIREBASE_STRUCTURE.md](docs/FIREBASE_STRUCTURE.md)** - Firebase configuration and structure
- **[SEQUENCE_DIAGRAMS.md](docs/SEQUENCE_DIAGRAMS.md)** - Workflow sequence diagrams
- **[GRADUATION_PRESENTATION.md](docs/GRADUATION_PRESENTATION.md)** - Presentation materials

## 🎨 UI/UX Design

### Design System
- **Colors**: Medical Blue (#2196F3), Health Green (#4CAF50), Alert Orange (#FF9800)
- **Typography**: Roboto font family
- **Components**: Glassmorphism effects, modern cards, smooth animations
- **Layout**: Responsive design for various screen sizes

### Key Screens
1. **Welcome & Authentication** - Clean onboarding experience
2. **Home Screen** - Product browsing with categories
3. **Product Details** - Comprehensive product information
4. **Shopping Cart** - Real-time cart management
5. **Checkout** - Streamlined order process
6. **Order History** - Purchase tracking

## 🔒 Security

### Authentication
- Firebase Authentication with email/password
- Secure password storage
- Session management
- Account verification

### Data Protection
- Firestore security rules
- Firebase Storage security rules
- Input validation and sanitization
- Data encryption in transit

### Privacy
- User consent for data collection
- Prescription image privacy
- GDPR compliance considerations
- Data deletion capabilities

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run tests with coverage
flutter test --coverage
```

### Test Coverage
- Unit tests for business logic
- Widget tests for UI components
- Integration tests for end-to-end workflows
- Performance tests for optimization

## 📈 Performance

### Optimization Features
- Lazy loading for product lists
- Image caching and compression
- Efficient state management
- Network request optimization
- Memory management

### Performance Metrics
- App launch time < 3 seconds
- Screen load time < 1 second
- Image load time < 2 seconds
- API response time < 500ms

## 🚀 Deployment

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS
```bash
# Build iOS app
flutter build ios --release
```

### Web
```bash
# Build web app
flutter build web --release
```

## 🔮 Future Enhancements

### Phase 2 (3-6 months)
- Payment gateway integration (Stripe/PayPal)
- Real-time order tracking
- Push notifications
- Multi-language support
- Rating and review system

### Phase 3 (6-12 months)
- AI product recommendations
- Video consultations with pharmacists
- Subscription services
- Admin dashboard
- Analytics and reporting

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:
- **Email**: your.email@example.com
- **GitHub Issues**: [Create an issue](https://github.com/yourusername/pharmacy-app-graduation/issues)
- **Documentation**: See `/docs` directory

## 🎓 Graduation Project

This project was developed as a graduation project demonstrating:
- Modern mobile app development with Flutter
- Firebase backend integration
- Clean architecture and design patterns
- Professional UI/UX implementation
- Comprehensive documentation and testing

---

**Project Status**: ✅ Complete Core Features  
**Version**: 1.0.0  
**Last Updated**: November 2025  
**Framework**: Flutter 3.8.1+  
**Backend**: Firebase (Firestore, Auth, Storage)
