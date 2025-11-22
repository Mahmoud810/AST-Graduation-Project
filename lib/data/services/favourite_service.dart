import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/favourite_item_model.dart';
import '../models/product_model.dart';
import '../../core/constants/firebase_paths.dart';

class FavouriteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get _currentUserId => _auth.currentUser?.uid;

  // Get user's favourite items
  Stream<List<FavouriteItem>> getUserFavourites() {
    if (_currentUserId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection(FirebasePaths.userFavourites(_currentUserId!))
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavouriteItem.fromFirestore(doc))
            .toList());
  }

  // Add product to favourites
  Future<bool> addToFavourites(Product product) async {
    if (_currentUserId == null) {
      print('User not authenticated');
      return false;
    }

    try {
      final favRef = _firestore.collection(FirebasePaths.userFavourites(_currentUserId!));
      
      // Check if product already exists in favourites
      final existingQuery = await favRef
          .where('productId', isEqualTo: product.id)
          .get();

      if (existingQuery.docs.isNotEmpty) {
        // Already in favourites, don't add again
        return false;
      }

      // Add new favourite item
      final favouriteItem = FavouriteItem(
        id: '', // Will be set by Firestore
        productId: product.id,
        userId: _currentUserId!,
        productName: product.name,
        productImage: product.imageUrl,
        price: product.price,
        productDescription: product.description,
        addedAt: DateTime.now(),
      );

      await favRef.add(favouriteItem.toFirestore());
      return true;
    } catch (e) {
      print('Error adding to favourites: $e');
      return false;
    }
  }

  // Remove item from favourites
  Future<bool> removeFromFavourites(String favouriteItemId) async {
    if (_currentUserId == null) {
      print('User not authenticated');
      return false;
    }

    try {
      await _firestore
          .collection(FirebasePaths.userFavourites(_currentUserId!))
          .doc(favouriteItemId)
          .delete();
      return true;
    } catch (e) {
      print('Error removing from favourites: $e');
      return false;
    }
  }

  // Remove by product ID
  Future<bool> removeProductFromFavourites(String productId) async {
    if (_currentUserId == null) {
      print('User not authenticated');
      return false;
    }

    try {
      final query = await _firestore
          .collection(FirebasePaths.userFavourites(_currentUserId!))
          .where('productId', isEqualTo: productId)
          .get();

      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error removing product from favourites: $e');
      return false;
    }
  }

  // Toggle favourite status
  Future<bool> toggleFavourite(Product product) async {
    if (_currentUserId == null) {
      print('User not authenticated');
      return false;
    }

    try {
      final isFav = await isProductInFavourites(product.id);
      
      if (isFav) {
        return await removeProductFromFavourites(product.id);
      } else {
        return await addToFavourites(product);
      }
    } catch (e) {
      print('Error toggling favourite: $e');
      return false;
    }
  }

  // Check if product is in favourites
  Future<bool> isProductInFavourites(String productId) async {
    if (_currentUserId == null) return false;

    try {
      final query = await _firestore
          .collection(FirebasePaths.userFavourites(_currentUserId!))
          .where('productId', isEqualTo: productId)
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      print('Error checking favourites: $e');
      return false;
    }
  }

  // Clear all favourites
  Future<bool> clearAllFavourites() async {
    if (_currentUserId == null) {
      print('User not authenticated');
      return false;
    }

    try {
      final favouriteItems = await _firestore
          .collection(FirebasePaths.userFavourites(_currentUserId!))
          .get();

      final batch = _firestore.batch();
      for (var doc in favouriteItems.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return true;
    } catch (e) {
      print('Error clearing favourites: $e');
      return false;
    }
  }

  // Get favourite count
  Future<int> getFavouriteCount() async {
    if (_currentUserId == null) return 0;

    try {
      final snapshot = await _firestore
          .collection(FirebasePaths.userFavourites(_currentUserId!))
          .get();
      
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting favourite count: $e');
      return 0;
    }
  }
}
