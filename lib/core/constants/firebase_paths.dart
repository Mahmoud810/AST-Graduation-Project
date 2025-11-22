/// Firebase Firestore collection paths
class FirebasePaths {
  // Collections
  static const String products = 'products';
  static const String users = 'users';
  static const String cart = 'cart';
  static const String favourites = 'favourites';
  static const String orders = 'orders';
  
  // Subcollections
  static String userCart(String userId) => 'users/$userId/cart';
  static String userFavourites(String userId) => 'users/$userId/favourites';
  static String userOrders(String userId) => 'users/$userId/orders';
  
  // Helper methods
  static String productDoc(String productId) => 'products/$productId';
  static String cartDoc(String userId, String cartItemId) => 
      'users/$userId/cart/$cartItemId';
  static String favouriteDoc(String userId, String favouriteId) => 
      'users/$userId/favourites/$favouriteId';
}
