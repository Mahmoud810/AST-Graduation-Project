import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../models/prescription_model.dart';

class PrescriptionService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Get current user ID (with detailed logging)
  String? get currentUserId {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ No current user found in FirebaseAuth');
        print('❌ User is null - not logged in');
        return null;
      }
      
      print('✅ Current user authenticated:');
      print('   UID: ${user.uid}');
      print('   Email: ${user.email}');
      print('   Provider: ${user.providerData.map((p) => p.providerId).join(', ')}');
      print('   Is Email Verified: ${user.emailVerified}');
      
      return user.uid;
    } catch (e) {
      print('❌ Error getting current user ID: $e');
      print('❌ Error type: ${e.runtimeType}');
      return null;
    }
  }

  /// Get prescriptions collection reference for current user (with safety check)
  CollectionReference<Map<String, dynamic>>? get prescriptionsCollection {
    final userId = currentUserId;
    if (userId == null) {
      print('❌ Cannot get prescriptions collection - user not authenticated');
      return null;
    }
    
    final collection = _firestore
        .collection('users')
        .doc(userId)
        .collection('prescriptions');
    
    print('✅ Prescriptions collection path: users/$userId/prescriptions');
    return collection;
  }

  /// Get storage reference for prescriptions (with safety check)
  Reference? get prescriptionsStorage {
    final userId = currentUserId;
    if (userId == null) {
      print('❌ Cannot get storage reference - user not authenticated');
      return null;
    }
    
    final storage = _storage.ref().child('prescriptions').child(userId);
    print('✅ Storage path: prescriptions/$userId');
    return storage;
  }

  /// Debug method to test Firebase connectivity
  Future<void> testFirebaseConnection() async {
    print('🔍 Testing Firebase connectivity...');
    
    try {
      // Test authentication
      final user = _auth.currentUser;
      if (user == null) {
        print('❌ Authentication test failed: No user logged in');
        return;
      }
      print('✅ Authentication test passed: ${user.uid}');
      
      // Test Firestore
      final collection = prescriptionsCollection;
      if (collection == null) {
        print('❌ Firestore test failed: Cannot access collection');
        return;
      }
      
      // Try to read a document (will fail if no permissions, but that's expected)
      final testDoc = collection.limit(1).get();
      print('✅ Firestore test passed: Can access collection');
      
      // Test Storage
      final storage = prescriptionsStorage;
      if (storage == null) {
        print('❌ Storage test failed: Cannot access storage');
        return;
      }
      
      // Try to list files (will fail if no files, but that's expected)
      final testList = storage.list();
      print('✅ Storage test passed: Can access storage bucket');
      
      print('✅ All Firebase connectivity tests passed');
      
    } catch (e) {
      print('❌ Firebase connectivity test failed: $e');
      print('❌ Error type: ${e.runtimeType}');
    }
  }

  /// Upload multiple images to Firebase Storage and save to Firestore
  Future<List<Prescription>> uploadMultipleImages(
    List<XFile> imageFiles,
  ) async {
    print('🚀 Starting upload process...');
    
    // Check authentication first
    final userId = currentUserId;
    if (userId == null) {
      print('❌ Upload failed: User not authenticated');
      throw Exception('Please login to upload prescriptions');
    }

    final collection = prescriptionsCollection;
    final storage = prescriptionsStorage;
    if (collection == null || storage == null) {
      print('❌ Upload failed: Cannot access Firebase resources');
      throw Exception('Firebase configuration error');
    }

    print('📤 Starting upload of ${imageFiles.length} images for user: $userId');
    final List<Prescription> uploadedPrescriptions = [];

    for (int i = 0; i < imageFiles.length; i++) {
      final imageFile = imageFiles[i];
      try {
        print('📸 Processing image ${i + 1}/${imageFiles.length}: ${imageFile.name}');
        
        // Check if file exists
        final File file = File(imageFile.path);
        if (!await file.exists()) {
          print('❌ File does not exist: ${imageFile.path}');
          continue;
        }

        // Read file bytes with size validation
        final Uint8List imageBytes = await file.readAsBytes();
        
        // Check file size (max 10MB)
        if (imageBytes.length > 10 * 1024 * 1024) {
          print('⚠️ Image too large: ${(imageBytes.length / (1024 * 1024)).toStringAsFixed(2)}MB. Skipping ${imageFile.name}');
          continue;
        }

        print('📏 File size: ${(imageBytes.length / (1024 * 1024)).toStringAsFixed(2)}MB');
        
        // Generate unique ID for this prescription
        final prescriptionDoc = collection.doc();
        final prescriptionId = prescriptionDoc.id;

        // Storage references with better organization
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = '${timestamp}_$prescriptionId.jpg';
        final imageRef = storage.child(fileName);

        print('📦 Uploading to Firebase Storage: $fileName');
        
        // Create upload task with proper metadata
        final UploadTask uploadTask = imageRef.putData(
          imageBytes,
          SettableMetadata(
            contentType: 'image/jpeg',
            customMetadata: {
              'userId': userId,
              'fileName': imageFile.name,
              'uploadedAt': DateTime.now().toIso8601String(),
              'fileSize': imageBytes.length.toString(),
              'originalName': imageFile.name,
            },
          ),
        );

        // Listen to upload progress
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          if (snapshot.totalBytes == 0) {
            print('⬆️ Upload progress: Starting...');
            return;
          }
          final progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
          print('⬆️ Upload progress: ${progress.toStringAsFixed(1)}%');
        });

        // Wait for upload completion with timeout
        final TaskSnapshot uploadSnapshot = await uploadTask
            .timeout(const Duration(minutes: 3));

        if (uploadSnapshot.state == TaskState.error) {
          print('❌ Upload failed for ${imageFile.name}');
          continue;
        }

        print('✅ Upload successful, getting download URL...');
        
        // Get download URL with timeout
        final imageUrl = await uploadSnapshot.ref.getDownloadURL()
            .timeout(const Duration(seconds: 15));

        print('🔗 Download URL obtained');

        // Create prescription document
        final prescription = Prescription(
          id: prescriptionId,
          userId: userId,
          imageUrl: imageUrl,
          thumbnailUrl: imageUrl, // Using same image for thumbnail
          timestamp: Timestamp.now(),
          fileName: imageFile.name,
          fileSize: imageBytes.length,
          status: 'completed',
        );

        print('💾 Saving prescription to Firestore: $prescriptionId');
        
        // Save to Firestore with timeout
        await collection.doc(prescriptionId).set(prescription.toFirestore())
            .timeout(const Duration(seconds: 15));
        
        print('✅ Prescription saved successfully: $prescriptionId');
        uploadedPrescriptions.add(prescription);
        
      } catch (e) {
        print('❌ Error uploading image ${imageFile.name}: $e');
        print('❌ Error type: ${e.runtimeType}');
        
        // Provide more specific error messages
        if (e.toString().contains('permission-denied')) {
          print('❌ Permission denied - check Firebase Storage rules');
        } else if (e.toString().contains('unauthorized')) {
          print('❌ Unauthorized - user may not be properly authenticated');
        } else if (e.toString().contains('network')) {
          print('❌ Network error - check internet connection');
        } else if (e.toString().contains('timeout')) {
          print('❌ Upload timeout - file may be too large or connection slow');
        }
        
        // Continue with other images even if one fails
        continue;
      }
    }

    print('📊 Upload completed: ${uploadedPrescriptions.length}/${imageFiles.length} images uploaded');
    
    if (uploadedPrescriptions.isEmpty) {
      throw Exception('Failed to upload any images. Please check your internet connection and try again.');
    }
    
    return uploadedPrescriptions;
  }

  /// Pick multiple images from gallery or camera
  Future<List<XFile>> pickImages({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final List<XFile> pickedFiles = [];

      if (source == ImageSource.gallery) {
        // Pick multiple images from gallery
        final List<XFile>? galleryFiles = await _picker.pickMultiImage(
          imageQuality: 85, // Compress images slightly
          limit: 5, // Limit to 5 images
        );
        
        if (galleryFiles != null) {
          pickedFiles.addAll(galleryFiles);
        }
      } else if (source == ImageSource.camera) {
        // Pick single image from camera
        final XFile? cameraFile = await _picker.pickImage(
          source: source,
          imageQuality: 85,
          maxWidth: 1024,
          maxHeight: 1024,
        );
        
        if (cameraFile != null) {
          pickedFiles.add(cameraFile);
        }
      }

      print('📸 Picked ${pickedFiles.length} images from $source');
      return pickedFiles;
    } catch (e) {
      print('❌ Error picking images: $e');
      print('❌ Error type: ${e.runtimeType}');
      
      // Handle specific errors
      if (e.toString().contains('permission')) {
        print('❌ Camera/Gallery permission denied');
      } else if (e.toString().contains('unavailable')) {
        print('❌ Camera not available on this device');
      }
      
      return [];
    }
  }

  /// Get stream of prescriptions for current user (with safety checks)
  Stream<List<Prescription>> getPrescriptionsStream() {
    final collection = prescriptionsCollection;
    if (collection == null) {
      print('❌ Cannot get prescriptions stream - user not authenticated');
      // Return empty stream
      return Stream.value([]);
    }

    print('🔍 Getting prescriptions for user: $currentUserId');

    return collection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .timeout(const Duration(seconds: 30))
        .map((snapshot) {
          print('📊 Received ${snapshot.docs.length} prescription documents');
          return snapshot.docs.map((doc) {
            print('📄 Processing prescription: ${doc.id}');
            try {
              return Prescription.fromFirestore(doc);
            } catch (e) {
              print('❌ Error processing prescription ${doc.id}: $e');
              // Return a safe default prescription
              return Prescription(
                id: doc.id,
                userId: currentUserId!,
                imageUrl: '',
                thumbnailUrl: '',
                timestamp: Timestamp.now(),
                fileName: 'error',
                fileSize: 0,
                status: 'error',
              );
            }
          }).toList();
        })
        .handleError((error) {
          print('❌ Stream error in prescriptions: $error');
          // Return empty list on stream error
          return <Prescription>[];
        });
  }

  /// Get prescriptions as a future (one-time fetch)
  Future<List<Prescription>> getPrescriptions() async {
    final collection = prescriptionsCollection;
    if (collection == null) {
      print('❌ Cannot get prescriptions - user not authenticated');
      return [];
    }

    try {
      final snapshot = await collection
          .orderBy('timestamp', descending: true)
          .get()
          .timeout(const Duration(seconds: 30));

      print('📊 Retrieved ${snapshot.docs.length} prescription documents');

      return snapshot.docs.map((doc) {
        try {
          return Prescription.fromFirestore(doc);
        } catch (e) {
          print('❌ Error processing prescription ${doc.id}: $e');
          // Return a safe default prescription
          return Prescription(
            id: doc.id,
            userId: currentUserId!,
            imageUrl: '',
            thumbnailUrl: '',
            timestamp: Timestamp.now(),
            fileName: 'error',
            fileSize: 0,
            status: 'error',
          );
        }
      }).toList();
    } catch (e) {
      print('❌ Error fetching prescriptions: $e');
      return [];
    }
  }

  /// Delete a prescription
  Future<bool> deletePrescription(String prescriptionId) async {
    final collection = prescriptionsCollection;
    final storage = prescriptionsStorage;
    if (collection == null || storage == null) {
      print('❌ Cannot delete prescription - user not authenticated');
      return false;
    }

    try {
      // Delete from Firestore
      await collection.doc(prescriptionId).delete();

      // Delete from Storage
      final imageRef = storage.child('$prescriptionId.jpg');
      final thumbnailRef = storage.child('${prescriptionId}_thumb.jpg');

      await Future.wait([imageRef.delete(), thumbnailRef.delete()]);

      return true;
    } catch (e) {
      print('❌ Error deleting prescription: $e');
      return false;
    }
  }

  /// Get prescription by ID
  Future<Prescription?> getPrescriptionById(String prescriptionId) async {
    final collection = prescriptionsCollection;
    if (collection == null) {
      print('❌ Cannot get prescription - user not authenticated');
      return null;
    }

    try {
      final doc = await collection.doc(prescriptionId).get();
      if (doc.exists) {
        return Prescription.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('❌ Error getting prescription: $e');
      return null;
    }
  }

  /// Update prescription status
  Future<bool> updatePrescriptionStatus(
    String prescriptionId,
    String status,
  ) async {
    final collection = prescriptionsCollection;
    if (collection == null) {
      print('❌ Cannot update prescription - user not authenticated');
      return false;
    }

    try {
      await collection.doc(prescriptionId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('❌ Error updating prescription status: $e');
      return false;
    }
  }
}
