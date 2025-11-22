import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl; // Primary image
  final List<String> images; // Multiple images for slider
  final String category;
  final int stockQuantity;
  final DateTime createdAt;
  final bool isAvailable;
  final String? manufacturer;
  final String? dosage;
  final String? sideEffects;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    List<String>? images,
    required this.category,
    required this.stockQuantity,
    required this.createdAt,
    this.isAvailable = true,
    this.manufacturer,
    this.dosage,
    this.sideEffects,
  }) : images = images ?? [imageUrl];

  // From Firestore
  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final imagesList = data['images'] as List<dynamic>?;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      images: imagesList?.map((e) => e.toString()).toList() ?? [data['imageUrl'] ?? ''],
      category: data['category'] ?? '',
      stockQuantity: data['stockQuantity'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isAvailable: data['isAvailable'] ?? true,
      manufacturer: data['manufacturer'],
      dosage: data['dosage'],
      sideEffects: data['sideEffects'],
    );
  }

  // To Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'images': images,
      'category': category,
      'stockQuantity': stockQuantity,
      'createdAt': Timestamp.fromDate(createdAt),
      'isAvailable': isAvailable,
      'manufacturer': manufacturer,
      'dosage': dosage,
      'sideEffects': sideEffects,
    };
  }

  // Copy with method
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? images,
    String? category,
    int? stockQuantity,
    DateTime? createdAt,
    bool? isAvailable,
    String? manufacturer,
    String? dosage,
    String? sideEffects,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      category: category ?? this.category,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      createdAt: createdAt ?? this.createdAt,
      isAvailable: isAvailable ?? this.isAvailable,
      manufacturer: manufacturer ?? this.manufacturer,
      dosage: dosage ?? this.dosage,
      sideEffects: sideEffects ?? this.sideEffects,
    );
  }
}
