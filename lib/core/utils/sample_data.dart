import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/product_model.dart';

/// Helper class to populate Firestore with sample products
/// Run this once to add sample data to your Firestore database
class SampleDataHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add sample products to Firestore
  Future<void> addSampleProducts() async {
    final sampleProducts = [
      Product(
        id: '',
        name: 'Panadol Extra 500mg',
        description: 'Panadol Extra with Optizorb provides fast and effective relief from pain and fever. Contains paracetamol 500mg and caffeine 65mg for enhanced pain relief.',
        price: 45.0,
        imageUrl: 'assets/product.jpg',
        images: ['assets/product.jpg', 'assets/product.jpg'],
        category: 'Pain Relief',
        stockQuantity: 50,
        createdAt: DateTime.now(),
        isAvailable: true,
        manufacturer: 'GSK - GlaxoSmithKline',
        dosage: 'Adults: 1-2 tablets every 4-6 hours as needed. Do not exceed 8 tablets in 24 hours.',
        sideEffects: 'Rare side effects may include allergic reactions, nausea, or stomach discomfort. Stop use and consult a doctor if symptoms worsen.',
      ),
      Product(
        id: '',
        name: 'Vitamin C 1000mg',
        description: 'High-potency Vitamin C supplement for immune support, antioxidant protection, and overall wellness. Helps boost immunity and promote healthy skin.',
        price: 75.0,
        imageUrl: 'assets/product.jpg',
        images: ['assets/product.jpg'],
        category: 'Vitamins & Supplements',
        stockQuantity: 100,
        createdAt: DateTime.now(),
        isAvailable: true,
        manufacturer: 'Pharco Pharmaceuticals',
        dosage: 'Take 1 tablet daily with food or as directed by healthcare professional.',
        sideEffects: 'May cause mild stomach upset in some individuals. High doses may lead to diarrhea.',
      ),
      Product(
        id: '',
        name: 'Omega-3 Fish Oil 1000mg',
        description: 'Premium quality Omega-3 fish oil capsules rich in EPA and DHA. Supports heart health, brain function, and reduces inflammation.',
        price: 120.0,
        imageUrl: 'assets/product.jpg',
        images: ['assets/product.jpg', 'assets/product.jpg'],
        category: 'Vitamins & Supplements',
        stockQuantity: 45,
        createdAt: DateTime.now(),
        isAvailable: true,
        manufacturer: 'Egyptian International Pharmaceutical Industries Company (EIPICO)',
        dosage: 'Take 1-2 capsules daily with meals.',
        sideEffects: 'May cause fishy aftertaste, mild indigestion. Do not exceed recommended dose.',
      ),
      Product(
        id: '',
        name: 'Antinal 200mg',
        description: 'Antinal (Nifuroxazide) is an intestinal antiseptic used to treat acute and chronic diarrhea. Effective against bacterial infections of the digestive system.',
        price: 35.0,
        imageUrl: 'assets/product.jpg',
        images: ['assets/product.jpg'],
        category: 'Gastrointestinal',
        stockQuantity: 80,
        createdAt: DateTime.now(),
        isAvailable: true,
        manufacturer: 'Amoun Pharmaceutical Company',
        dosage: 'Adults: 1 capsule 4 times daily. Children: As prescribed by physician.',
        sideEffects: 'Rarely: allergic reactions, nausea. Discontinue if symptoms persist.',
      ),
      Product(
        id: '',
        name: 'Cataflam 50mg',
        description: 'Cataflam (Diclofenac Potassium) is a non-steroidal anti-inflammatory drug (NSAID) for pain and inflammation relief in various conditions.',
        price: 55.0,
        imageUrl: 'assets/product.jpg',
        images: ['assets/product.jpg', 'assets/product.jpg'],
        category: 'Pain Relief',
        stockQuantity: 60,
        createdAt: DateTime.now(),
        isAvailable: true,
        manufacturer: 'Novartis Pharma',
        dosage: 'Adults: 50mg 2-3 times daily. Take with food to reduce stomach irritation.',
        sideEffects: 'May cause stomach upset, headache, dizziness. Seek medical attention for severe side effects.',
      ),
      Product(
        id: '',
        name: 'Strepsils Honey & Lemon',
        description: 'Strepsils lozenges provide fast, soothing relief from sore throat pain. Contains antiseptic ingredients to help kill bacteria.',
        price: 30.0,
        imageUrl: 'assets/product.jpg',
        images: ['assets/product.jpg'],
        category: 'Cold & Flu',
        stockQuantity: 120,
        createdAt: DateTime.now(),
        isAvailable: true,
        manufacturer: 'Reckitt Benckiser',
        dosage: 'Adults and children over 6 years: Dissolve 1 lozenge slowly in the mouth every 2-3 hours.',
        sideEffects: 'Generally well tolerated. Rarely may cause mild irritation.',
      ),
      Product(
        id: '',
        name: 'Concor 5mg',
        description: 'Concor (Bisoprolol) is a beta-blocker used to treat high blood pressure and heart failure. Helps reduce heart rate and blood pressure.',
        price: 85.0,
        imageUrl: 'assets/product.jpg',
        images: ['assets/product.jpg', 'assets/product.jpg'],
        category: 'Cardiovascular',
        stockQuantity: 40,
        createdAt: DateTime.now(),
        isAvailable: true,
        manufacturer: 'Merck KGaA',
        dosage: 'Usually 5mg once daily or as prescribed by your doctor. Do not stop suddenly without consulting physician.',
        sideEffects: 'May cause fatigue, dizziness, slow heart rate, cold hands/feet. Report any unusual symptoms.',
      ),
      Product(
        id: '',
        name: 'Cetaphil Gentle Skin Cleanser',
        description: 'Cetaphil Gentle Skin Cleanser is a mild, non-irritating formula for all skin types. Cleans without stripping natural oils.',
        price: 150.0,
        imageUrl: 'assets/product.jpg',
        images: ['assets/product.jpg'],
        category: 'Skincare',
        stockQuantity: 35,
        createdAt: DateTime.now(),
        isAvailable: true,
        manufacturer: 'Galderma',
        dosage: 'Apply to skin and gently massage. Rinse with water or wipe off. Use twice daily.',
        sideEffects: 'Very rare allergic reactions. Suitable for sensitive skin.',
      ),
      Product(
        id: '',
        name: 'Augmentin 1g',
        description: 'Augmentin (Amoxicillin + Clavulanic Acid) is a broad-spectrum antibiotic for bacterial infections. Effective against respiratory, urinary tract, and skin infections.',
        price: 95.0,
        imageUrl: 'assets/product.jpg',
        images: ['assets/product.jpg', 'assets/product.jpg'],
        category: 'Antibiotics',
        stockQuantity: 55,
        createdAt: DateTime.now(),
        isAvailable: true,
        manufacturer: 'GlaxoSmithKline (GSK)',
        dosage: 'Adults: 1 tablet twice daily. Complete the full course even if symptoms improve.',
        sideEffects: 'Common: diarrhea, nausea. Stop and seek medical help if severe allergic reaction occurs.',
      ),
      Product(
        id: '',
        name: 'Nexium 40mg',
        description: 'Nexium (Esomeprazole) is a proton pump inhibitor (PPI) that reduces stomach acid. Used to treat GERD, ulcers, and acid reflux.',
        price: 110.0,
        imageUrl: 'assets/product.jpg',
        images: ['assets/product.jpg'],
        category: 'Gastrointestinal',
        stockQuantity: 70,
        createdAt: DateTime.now(),
        isAvailable: true,
        manufacturer: 'AstraZeneca',
        dosage: 'Adults: 1 tablet once daily before a meal, preferably in the morning.',
        sideEffects: 'May cause headache, nausea, diarrhea, or abdominal pain. Long-term use requires medical supervision.',
      ),
    ];

    try {
      for (var product in sampleProducts) {
        await _firestore.collection('products').add(product.toFirestore());
      }
      print('✅ Successfully added ${sampleProducts.length} sample products!');
    } catch (e) {
      print('❌ Error adding sample products: $e');
    }
  }

  /// Clear all products from Firestore (use with caution!)
  Future<void> clearAllProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('✅ All products cleared from Firestore');
    } catch (e) {
      print('❌ Error clearing products: $e');
    }
  }
}
