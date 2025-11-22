import 'package:cloud_firestore/cloud_firestore.dart';

class CartItem {
  final String id;
  final String productId;
  final String userId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.productId,
    required this.userId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.addedAt,
  });

  // From Firestore
  factory CartItem.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartItem(
      id: doc.id,
      productId: data['productId'] ?? '',
      userId: data['userId'] ?? '',
      productName: data['productName'] ?? '',
      productImage: data['productImage'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      quantity: data['quantity'] ?? 1,
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
      'quantity': quantity,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  // Copy with method
  CartItem copyWith({
    String? id,
    String? productId,
    String? userId,
    String? productName,
    String? productImage,
    double? price,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // Calculate total for this item
  double get totalPrice => price * quantity;
}
