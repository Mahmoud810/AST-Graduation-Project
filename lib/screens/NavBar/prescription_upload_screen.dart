import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/prescription_model.dart';
import '../../../data/services/prescription_service.dart';
import '../../widgets/prescription_upload_cell.dart';
import '../../widgets/prescription_grid_cell.dart';
import '../../constants.dart';
import 'prescription_preview_screen.dart';
import '../../core/core/services/loading_service.dart';
import '../../core/core/widgets/stream_loading_widget.dart';

class PrescriptionUploadScreen extends StatefulWidget {
  const PrescriptionUploadScreen({super.key});

  @override
  State<PrescriptionUploadScreen> createState() =>
      _PrescriptionUploadScreenState();
}

class _PrescriptionUploadScreenState extends State<PrescriptionUploadScreen>
    with SingleTickerProviderStateMixin {
  final PrescriptionService _prescriptionService = PrescriptionService();
  bool _isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _checkPermissions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final storagePermission = await Permission.storage.request();
      final photosPermission = await Permission.photos.request();

      if (!storagePermission.isGranted && !photosPermission.isGranted) {
        _showErrorDialog(
          'Permissions Required',
          'Storage and photo permissions are required to upload prescriptions.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.appColor,
        elevation: 0,
        title: const Text(
          'Upload Prescription',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.white),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.white,
          labelColor: AppColors.white,
          unselectedLabelColor: AppColors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: 'Upload'),
            Tab(text: 'My Prescriptions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildUploadTab(), _buildPrescriptionsGrid()],
      ),
    );
  }

  Widget _buildUploadTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Debug Section (remove in production)
          if (kDebugMode) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Debug Tools',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await _prescriptionService.testFirebaseConnection();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Test Firebase'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print(
                              '👤 Current User ID: ${_prescriptionService.currentUserId}',
                            );
                            print(
                              '📧 User Email: ${FirebaseAuth.instance.currentUser?.email}',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Check User'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Upload Card
          PrescriptionUploadCell(
            onUploadPressed: _pickAndUploadImages,
            isLoading: _isLoading,
          ),

          const SizedBox(height: 24),

          // Instructions Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.appColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.appColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.appColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'How to upload:',
                      style: TextStyle(
                        color: AppColors.appColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildInstructionItem(
                  icon: Icons.photo_library,
                  text: 'Select multiple images from gallery',
                ),
                const SizedBox(height: 8),
                _buildInstructionItem(
                  icon: Icons.camera_alt,
                  text: 'Take photos with your camera',
                ),
                const SizedBox(height: 8),
                _buildInstructionItem(
                  icon: Icons.cloud_upload,
                  text: 'Upload up to 5 images at once',
                ),
                const SizedBox(height: 8),
                _buildInstructionItem(
                  icon: Icons.security,
                  text: 'All images are securely stored',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionItem({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textHint, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: AppColors.textDark, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsGrid() {
    return StreamLoadingWidget<List<Prescription>>(
      stream: _prescriptionService.getPrescriptionsStream(),
      loadingMessage: 'Loading prescriptions...',
      emptyBuilder: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: 16),
            Text(
              'No prescriptions uploaded',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Switch to the Upload tab to add your first prescription',
              style: TextStyle(color: AppColors.textHint, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _tabController.animateTo(0); // Switch to upload tab
              },
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Upload First Prescription'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
      errorBuilder: (error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading prescriptions',
              style: TextStyle(color: AppColors.textDark, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Unknown error',
              style: TextStyle(color: AppColors.textHint, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => setState(() {}),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      builder: (prescriptions) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemCount: prescriptions.length,
            itemBuilder: (context, index) {
              final prescription = prescriptions[index];
              return PrescriptionGridCell(
                prescription: prescription,
                onTap: () => _viewPrescription(prescription),
                onDelete: () => _deletePrescription(prescription),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _pickAndUploadImages() async {
    try {
      print('🚀 Starting prescription upload process...');

      // Check if user is authenticated
      if (_prescriptionService.currentUserId == null) {
        print('❌ User not authenticated');
        _showErrorSnackBar('Please login to upload prescriptions');
        return;
      }

      print('✅ User authenticated: ${_prescriptionService.currentUserId}');

      // Show source selection dialog
      final ImageSource? source = await _showImageSourceDialog();
      if (source == null) {
        print('❌ User cancelled image source selection');
        return;
      }

      print('📸 Selected source: $source');

      // Pick images with loading
      final images = await context.withLoading(
        () => _prescriptionService.pickImages(source: source),
        message: 'Selecting images...',
      );

      if (images.isEmpty) {
        print('❌ No images selected');
        _showErrorSnackBar('No images selected');
        return;
      }

      print('📸 Picked ${images.length} images');

      if (images.length > 5) {
        print('⚠️ Too many images selected: ${images.length}');
        _showErrorSnackBar('Maximum 5 images can be uploaded at once');
        return;
      }

      // Upload images with loading
      final uploadedPrescriptions = await context.withLoading(
        () => _prescriptionService.uploadMultipleImages(images),
        message: 'Uploading prescriptions...\n${images.length} image(s)',
      );

      print('📊 Upload result: ${uploadedPrescriptions.length} successful');

      if (uploadedPrescriptions.isNotEmpty) {
        _showSuccessSnackBar(
          'Successfully uploaded ${uploadedPrescriptions.length} prescription(s)',
        );

        // Switch to prescriptions tab to show results
        _tabController.animateTo(1);
      } else {
        _showErrorSnackBar('Failed to upload prescriptions');
      }
    } catch (e) {
      print('❌ Upload error: $e');
      print('❌ Error type: ${e.runtimeType}');

      String errorMsg = "Error uploading prescriptions";

      // Provide specific error messages based on the error
      if (e.toString().contains('Please login')) {
        errorMsg = "Please login to upload prescriptions";
      } else if (e.toString().contains('permission-denied')) {
        errorMsg = "Permission denied. Please check your account settings.";
      } else if (e.toString().contains('unauthorized')) {
        errorMsg = "Authentication error. Please login again.";
      } else if (e.toString().contains('network')) {
        errorMsg = "Network error. Please check your internet connection.";
      } else if (e.toString().contains('timeout')) {
        errorMsg = "Upload timeout. Please try again with smaller images.";
      } else if (e.toString().contains('too large')) {
        errorMsg =
            "Images are too large. Please select smaller images (max 10MB each).";
      } else if (e.toString().contains('Firebase configuration')) {
        errorMsg = "Configuration error. Please restart the app.";
      } else if (e.toString().contains('Failed to upload any images')) {
        errorMsg =
            "Upload failed. Please check your internet connection and try again.";
      } else {
        errorMsg = "Upload failed: ${e.toString()}";
      }

      _showErrorSnackBar(errorMsg);
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () => _pickAndUploadImages(),
        ),
      ),
    );
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    // Check camera availability
    bool cameraAvailable = false;
    try {
      final cameras = await availableCameras();
      cameraAvailable = cameras.isNotEmpty;
    } catch (e) {
      cameraAvailable = false;
    }

    return showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Image Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              subtitle: const Text('Choose multiple images from gallery'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
            if (cameraAvailable)
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                subtitle: const Text('Take a photo with camera'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _viewPrescription(Prescription prescription) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PrescriptionPreviewScreen(prescription: prescription),
      ),
    );
  }

  Future<void> _deletePrescription(Prescription prescription) async {
    final confirmed = await _showDeleteConfirmationDialog();
    if (!confirmed) return;

    try {
      final success = await _prescriptionService.deletePrescription(
        prescription.id,
      );

      if (success) {
        Fluttertoast.showToast(
          msg: "Prescription deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to delete prescription",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error deleting prescription: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Prescription'),
        content: const Text(
          'Are you sure you want to delete this prescription? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
