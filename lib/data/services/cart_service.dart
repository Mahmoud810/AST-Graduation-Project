import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../../core/constants/firebase_paths.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // Get user's cart items
  Stream<List<CartItem>> getUserCart() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(FirebasePaths.userCart(_currentUserId!))
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartItem.fromFirestore(doc))
            .toList());
  }

  // Add product to cart
  Future<bool> addToCart(Product product, {int quantity = 1}) async {
    if (_currentUserId == null) {
      print('User not authenticated');
      return false;
    }

    try {
      final cartRef = _firestore.collection(FirebasePaths.userCart(_currentUserId!));
      
      // Check if product already exists in cart
      final existingQuery = await cartRef
          .where('productId', isEqualTo: product.id)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        // Update quantity if already exists
        final existingDoc = existingQuery.docs.first;
        final existingItem = CartItem.fromFirestore(existingDoc);
        await existingDoc.reference.update({
          'quantity': existingItem.quantity + quantity,
        });
      } else {
        // Add new cart item
        final cartItem = CartItem(
          id: '', // Will be set by Firestore
          productId: product.id,
          userId: _currentUserId!,
          productName: product.name,
          productImage: product.imageUrl,
          price: product.price,
          quantity: quantity,
          addedAt: DateTime.now(),
        );
        await cartRef.add(cartItem.toFirestore());
      }
      return true;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }

  // Update cart item quantity
  Future<bool> updateCartItemQuantity(String cartItemId, int newQuantity) async {
    if (_currentUserId == null) {
      print('User not authenticated');
      return false;
    }

    try {
      if (newQuantity <= 0) {
        return await removeFromCart(cartItemId);
      }

      await _firestore
          .collection(FirebasePaths.userCart(_currentUserId!))
          .doc(cartItemId)
          .update({'quantity': newQuantity});
      return true;
    } catch (e) {
      print('Error updating cart item: $e');
      return false;
    }
  }

  // Increase cart item quantity
  Future<bool> increaseQuantity(String cartItemId) async {
    if (_currentUserId == null) return false;

    try {
      final doc = await _firestore
          .collection(FirebasePaths.userCart(_currentUserId!))
          .doc(cartItemId)
          .get();

      if (doc.exists) {
        final item = CartItem.fromFirestore(doc);
        return await updateCartItemQuantity(cartItemId, item.quantity + 1);
      }
      return false;
    } catch (e) {
      print('Error increasing quantity: $e');
      return false;
    }
  }

  // Decrease cart item quantity
  Future<bool> decreaseQuantity(String cartItemId) async {
    if (_currentUserId == null) return false;

    try {
      final doc = await _firestore
          .collection(FirebasePaths.userCart(_currentUserId!))
          .doc(cartItemId)
          .get();

      if (doc.exists) {
        final item = CartItem.fromFirestore(doc);
        if (item.quantity > 1) {
          return await updateCartItemQuantity(cartItemId, item.quantity - 1);
        } else {
          return await removeFromCart(cartItemId);
        }
      }
      return false;
    } catch (e) {
      print('Error decreasing quantity: $e');
      return false;
    }
  }

  // Remove item from cart
  Future<bool> removeFromCart(String cartItemId) async {
    if (_currentUserId == null) {
      print('User not authenticated');
      return false;
    }

    try {
      await _firestore
          .collection(FirebasePaths.userCart(_currentUserId!))
          .doc(cartItemId)
          .delete();
      return true;
    } catch (e) {
      print('Error removing from cart: $e');
      return false;
    }
  }

  // Clear entire cart
  Future<bool> clearCart() async {
    if (_currentUserId == null) {
      print('User not authenticated');
      return false;
    }

    try {
      final cartItems = await _firestore
          .collection(FirebasePaths.userCart(_currentUserId!))
          .get();

      final batch = _firestore.batch();
      for (var doc in cartItems.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return true;
    } catch (e) {
      print('Error clearing cart: $e');
      return false;
    }
  }

  // Get cart total
  Future<double> getCartTotal() async {
    if (_currentUserId == null) return 0.0;

    try {
      final snapshot = await _firestore
          .collection(FirebasePaths.userCart(_currentUserId!))
          .get();

      double total = 0.0;
      for (var doc in snapshot.docs) {
        final item = CartItem.fromFirestore(doc);
        total += item.totalPrice;
      }
      return total;
    } catch (e) {
      print('Error calculating cart total: $e');
      return 0.0;
    }
  }

  // Get cart item count
  Future<int> getCartItemCount() async {
    if (_currentUserId == null) {
      print('No user signed in for cart count');
      return 0;
    }

    try {
      final snapshot = await _firestore
          .collection(FirebasePaths.userCart(_currentUserId!))
          .get();
      
      int count = 0;
      for (var doc in snapshot.docs) {
        final item = CartItem.fromFirestore(doc);
        count += item.quantity;
      }
      return count;
    } catch (e) {
      // Silently handle permission errors during development
      if (e.toString().contains('permission-denied')) {
        print('Cart access permission issue - user document may not exist yet');
      } else {
        print('Error getting cart count: $e');
      }
      return 0;
    }
  }

  // Check if product is in cart
  Future<bool> isProductInCart(String productId) async {
    if (_currentUserId == null) return false;

    try {
      final query = await _firestore
          .collection(FirebasePaths.userCart(_currentUserId!))
          .where('productId', isEqualTo: productId)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      print('Error checking cart: $e');
      return false;
    }
  }
}
