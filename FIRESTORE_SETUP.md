# Firestore Backend Setup Guide

## 📋 Overview

This document outlines the complete Firestore backend implementation for the e-commerce application, including products, cart, and favourites functionality.

---

## 🗂️ Database Structure

### Collections

#### 1. **products** (Root Collection)
Stores all available products in the system.

```
products/
  ├── {productId}/
      ├── name: string
      ├── description: string
      ├── price: number
      ├── imageUrl: string
      ├── category: string
      ├── stockQuantity: number
      ├── createdAt: timestamp
      └── isAvailable: boolean
```

#### 2. **users** (Root Collection)
User data and subcollections for cart and favourites.

```
users/
  ├── {userId}/
      ├── email: string
      ├── displayName: string
      ├── role: string (optional: 'admin' or 'user')
      │
      ├── cart/ (Subcollection)
      │   └── {cartItemId}/
      │       ├── productId: string
      │       ├── userId: string
      │       ├── productName: string
      │       ├── productImage: string
      │       ├── price: number
      │       ├── quantity: number
      │       └── addedAt: timestamp
      │
      └── favourites/ (Subcollection)
          └── {favouriteId}/
              ├── productId: string
              ├── userId: string
              ├── productName: string
              ├── productImage: string
              ├── price: number
              ├── productDescription: string
              └── addedAt: timestamp
```

---

## 🔐 Security Rules

The Firestore security rules are defined in `firestore.rules`:

### Key Rules:
- **Products**: Read access for all authenticated users, write access for admins only
- **Cart**: Read/write access only for the cart owner
- **Favourites**: Read/write access only for the favourites owner
- **Authentication Required**: All operations require user authentication

### Deploying Rules:
```bash
firebase deploy --only firestore:rules
```

---

## 🏗️ Project Architecture

### Folder Structure
```
lib/
├── core/
│   ├── constants/
│   │   └── firebase_paths.dart          # Firebase collection paths
│   └── utils/
│       └── sample_data.dart              # Sample data helper
│
├── data/
│   ├── models/
│   │   ├── product_model.dart            # Product data model
│   │   ├── cart_item_model.dart          # Cart item data model
│   │   └── favourite_item_model.dart     # Favourite item data model
│   │
│   └── services/
│       ├── product_service.dart          # Product CRUD operations
│       ├── cart_service.dart             # Cart management
│       └── favourite_service.dart        # Favourites management
│
├── screens/
│   ├── NavBar/
│   │   ├── HomeScreen_new.dart           # Updated home with Firestore
│   │   └── Favourite/
│   │       └── FavouriteScreen_new.dart  # Updated favourites with Firestore
│   └── cart_screen_new.dart              # Updated cart with Firestore
│
└── widgets/
    └── product_card_widget.dart          # Reusable product card
```

---

## 🚀 Getting Started

### Step 1: Initialize Sample Data
To populate your Firestore database with sample products:

```dart
import 'package:graduation_project/core/utils/sample_data.dart';

// In your admin screen or initial setup:
final sampleDataHelper = SampleDataHelper();
await sampleDataHelper.addSampleProducts();
```

### Step 2: Update Navigation
Replace the old screen references in your navigation:

```dart
// In NavBar.dart
import 'screens/NavBar/HomeScreen_new.dart';
import 'screens/NavBar/Favourite/FavouriteScreen_new.dart';

final List<Widget> _screens = const [
  HomeScreen(),  // Now uses HomeScreen_new.dart
  GiftScreen(),
  FavouriteScreenNew(),  // Now uses FavouriteScreen_new.dart
  UploadScreen(),
];
```

### Step 3: Update Cart Navigation
In any screen that navigates to the cart:

```dart
import 'package:graduation_project/screens/cart_screen_new.dart';

// Navigate to cart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const CartScreenNew()),
);
```

---

## 📊 Service Classes

### ProductService
Handles all product-related operations:
- `getAllProducts()` - Stream of all products
- `getProductsByCategory(category)` - Filter by category
- `getProductById(id)` - Get single product
- `searchProducts(query)` - Search products
- `addProduct(product)` - Add new product (admin)
- `updateProduct(id, updates)` - Update product (admin)
- `deleteProduct(id)` - Delete product (admin)

### CartService
Manages user cart operations:
- `getUserCart()` - Stream of user's cart items
- `addToCart(product, quantity)` - Add product to cart
- `updateCartItemQuantity(itemId, quantity)` - Update quantity
- `increaseQuantity(itemId)` - Increase by 1
- `decreaseQuantity(itemId)` - Decrease by 1
- `removeFromCart(itemId)` - Remove item
- `clearCart()` - Empty entire cart
- `getCartTotal()` - Calculate total price
- `getCartItemCount()` - Total items in cart
- `isProductInCart(productId)` - Check if product exists

### FavouriteService
Manages user favourites:
- `getUserFavourites()` - Stream of user's favourites
- `addToFavourites(product)` - Add to favourites
- `removeFromFavourites(itemId)` - Remove by ID
- `removeProductFromFavourites(productId)` - Remove by product ID
- `toggleFavourite(product)` - Toggle favourite status
- `isProductInFavourites(productId)` - Check favourite status
- `clearAllFavourites()` - Clear all favourites
- `getFavouriteCount()` - Count favourites

---

## 🎨 Features Implemented

### Home Screen
✅ Real-time product fetching from Firestore  
✅ Search functionality  
✅ Add to cart with feedback  
✅ Add/remove from favourites  
✅ Loading and error states  
✅ Empty state handling  
✅ Stock quantity badges  
✅ Dynamic cart count badge  

### Cart Screen
✅ Real-time cart updates  
✅ Increase/decrease quantity  
✅ Remove items with confirmation  
✅ Live total calculation  
✅ Empty cart state  
✅ Loading and error handling  
✅ Navigate to checkout  

### Favourites Screen
✅ Real-time favourites list  
✅ Add to cart from favourites  
✅ Remove from favourites with confirmation  
✅ Empty favourites state  
✅ Loading and error handling  

---

## 🔧 Error Handling

All services include comprehensive error handling:
- Try-catch blocks for all Firestore operations
- User-friendly error messages
- Loading states for async operations
- Empty state displays
- Network error handling

---

## 📱 Usage Examples

### Add Product to Cart
```dart
final cartService = CartService();
final product = /* your product */;

final success = await cartService.addToCart(product, quantity: 2);
if (success) {
  // Show success message
}
```

### Toggle Favourite
```dart
final favouriteService = FavouriteService();
final product = /* your product */;

await favouriteService.toggleFavourite(product);
```

### Listen to Cart Updates
```dart
final cartService = CartService();

StreamBuilder<List<CartItem>>(
  stream: cartService.getUserCart(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final cartItems = snapshot.data!;
      // Build your UI
    }
  },
);
```

---

## 🔄 Migration Guide

### From Old to New Screens

1. **Replace HomeScreen imports:**
   ```dart
   // Old
   import 'package:graduation_project/screens/NavBar/HomeScreen.dart';
   
   // New - use the new implementation
   // The new version is in HomeScreen_new.dart
   ```

2. **Replace CartScreen:**
   ```dart
   // Old
   import 'package:graduation_project/screens/cart_screen.dart';
   
   // New
   import 'package:graduation_project/screens/cart_screen_new.dart';
   ```

3. **Replace FavouriteScreen:**
   ```dart
   // Old
   import 'package:graduation_project/screens/NavBar/Favourite/FavouriteScreen.dart';
   
   // New
   import 'package:graduation_project/screens/NavBar/Favourite/FavouriteScreen_new.dart';
   ```

---

## 🧪 Testing

### Manual Testing Checklist
- [ ] Products load from Firestore
- [ ] Search filters products correctly
- [ ] Add to cart creates Firestore document
- [ ] Cart quantity updates in real-time
- [ ] Remove from cart deletes document
- [ ] Add to favourites creates document
- [ ] Remove from favourites deletes document
- [ ] Cart total calculates correctly
- [ ] Stock badges display correctly
- [ ] Empty states show properly

---

## 🚨 Important Notes

1. **Authentication Required**: All Firestore operations require user authentication
2. **Security Rules**: Deploy security rules before testing
3. **Sample Data**: Run sample data script to populate products
4. **Real-time Updates**: All screens use StreamBuilder for live updates
5. **Error Handling**: All services include comprehensive error handling

---

## 📞 Support

For issues or questions, refer to:
- Firebase Documentation: https://firebase.google.com/docs/firestore
- Flutter Fire Documentation: https://firebase.flutter.dev/

---

## 🎉 Next Steps

1. Deploy Firestore security rules
2. Add sample products to database
3. Test all features thoroughly
4. Implement order management (optional)
5. Add product categories filter (optional)
6. Implement admin panel for product management (optional)

---

**Created with ❤️ for Production Use**
