import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../../core/constants/firebase_paths.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all products from Firestore
  Stream<List<Product>> getAllProducts() {
    try {
      // Simplified query - no orderBy to avoid index requirement
      return _firestore
          .collection(FirebasePaths.products)
          .snapshots()
          .map((snapshot) {
        final products = snapshot.docs
            .map((doc) => Product.fromFirestore(doc))
            .where((product) => product.isAvailable)
            .toList();
        
        // Sort in memory instead of in query
        products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return products;
      });
    } catch (e) {
      print('Error fetching products: $e');
      return Stream.value([]);
    }
  }

  // Get products by category
  Stream<List<Product>> getProductsByCategory(String category) {
    return _firestore
        .collection(FirebasePaths.products)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
      final products = snapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .where((product) => product.isAvailable)
          .toList();
      
      // Sort in memory
      products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return products;
    });
  }

  // Get single product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      final doc = await _firestore
          .collection(FirebasePaths.products)
          .doc(productId)
          .get();
      
      if (doc.exists) {
        return Product.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting product: $e');
      return null;
    }
  }

  // Search products
  Stream<List<Product>> searchProducts(String query) {
    return _firestore
        .collection(FirebasePaths.products)
        .snapshots()
        .map((snapshot) {
      final products = snapshot.docs
          .map((doc) => Product.fromFirestore(doc))
          .where((product) =>
              product.isAvailable &&
              (product.name.toLowerCase().contains(query.toLowerCase()) ||
               product.description.toLowerCase().contains(query.toLowerCase()) ||
               product.category.toLowerCase().contains(query.toLowerCase())))
          .toList();
      
      // Sort by relevance (exact matches first)
      products.sort((a, b) {
        final aExact = a.name.toLowerCase() == query.toLowerCase();
        final bExact = b.name.toLowerCase() == query.toLowerCase();
        if (aExact && !bExact) return -1;
        if (!aExact && bExact) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });
      
      return products;
    });
  }

  // Add product (Admin only)
  Future<String?> addProduct(Product product) async {
    try {
      final docRef = await _firestore
          .collection(FirebasePaths.products)
          .add(product.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error adding product: $e');
      return null;
    }
  }

  // Update product (Admin only)
  Future<bool> updateProduct(String productId, Map<String, dynamic> updates) async {
    try {
      await _firestore
          .collection(FirebasePaths.products)
          .doc(productId)
          .update(updates);
      return true;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }

  // Delete product (Admin only)
  Future<bool> deleteProduct(String productId) async {
    try {
      await _firestore
          .collection(FirebasePaths.products)
          .doc(productId)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // Update stock quantity
  Future<bool> updateStockQuantity(String productId, int newQuantity) async {
    try {
      await _firestore
          .collection(FirebasePaths.products)
          .doc(productId)
          .update({'stockQuantity': newQuantity});
      return true;
    } catch (e) {
      print('Error updating stock: $e');
      return false;
    }
  }
}
