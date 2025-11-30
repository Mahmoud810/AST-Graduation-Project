import 'package:cloud_firestore/cloud_firestore.dart';

class Prescription {
  final String id;
  final String userId;
  final String imageUrl;
  final String thumbnailUrl;
  final Timestamp timestamp;
  final String fileName;
  final int fileSize;
  final String status; // 'uploading', 'completed', 'failed'

  Prescription({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.thumbnailUrl,
    required this.timestamp,
    required this.fileName,
    required this.fileSize,
    this.status = 'completed',
  });

  factory Prescription.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data() as Map<String, dynamic>;
      
      // Handle timestamp conversion safely
      Timestamp timestamp;
      if (data['timestamp'] is Timestamp) {
        timestamp = data['timestamp'] as Timestamp;
      } else if (data['timestamp'] != null) {
        // Convert to timestamp if it's not already one
        timestamp = Timestamp.now();
        print('⚠️ Invalid timestamp format for document ${doc.id}, using current time');
      } else {
        timestamp = Timestamp.now();
        print('⚠️ Missing timestamp for document ${doc.id}, using current time');
      }
      
      return Prescription(
        id: doc.id,
        userId: data['userId'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        thumbnailUrl: data['thumbnailUrl'] ?? data['imageUrl'] ?? '',
        timestamp: timestamp,
        fileName: data['fileName'] ?? '',
        fileSize: data['fileSize'] ?? 0,
        status: data['status'] ?? 'completed',
      );
    } catch (e) {
      print('❌ Error parsing prescription document ${doc.id}: $e');
      print('❌ Document data: ${doc.data()}');
      
      // Return a default prescription if parsing fails
      return Prescription(
        id: doc.id,
        userId: '',
        imageUrl: '',
        thumbnailUrl: '',
        timestamp: Timestamp.now(),
        fileName: 'error',
        fileSize: 0,
        status: 'error',
      );
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'thumbnailUrl': thumbnailUrl,
      'timestamp': timestamp,
      'fileName': fileName,
      'fileSize': fileSize,
      'status': status,
    };
  }

  Prescription copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? thumbnailUrl,
    Timestamp? timestamp,
    String? fileName,
    int? fileSize,
    String? status,
  }) {
    return Prescription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      timestamp: timestamp ?? this.timestamp,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Prescription(id: $id, fileName: $fileName, status: $status)';
  }
}
