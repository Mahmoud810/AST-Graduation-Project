import 'package:cloud_firestore/cloud_firestore.dart';

class FavouriteItem {
  final String id;
  final String productId;
  final String userId;
  final String productName;
  final String productImage;
  final double price;
  final String productDescription;
  final DateTime addedAt;

  FavouriteItem({
    required this.id,
    required this.productId,
    required this.userId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.productDescription,
    required this.addedAt,
  });

  // From Firestore
  factory FavouriteItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FavouriteItem(
      id: doc.id,
      productId: data['productId'] ?? '',
      userId: data['userId'] ?? '',
      productName: data['productName'] ?? '',
      productImage: data['productImage'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      productDescription: data['productDescription'] ?? '',
      addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'userId': userId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'productDescription': productDescription,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  // Copy with method
  FavouriteItem copyWith({
    String? id,
    String? productId,
    String? userId,
    String? productName,
    String? productImage,
    double? price,
    String? productDescription,
    DateTime? addedAt,
  }) {
    return FavouriteItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      productDescription: productDescription ?? this.productDescription,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}
