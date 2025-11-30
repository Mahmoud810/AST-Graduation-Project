import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/prescription_model.dart';
import '../../../data/services/prescription_service.dart';
import '../../widgets/prescription_upload_cell.dart';
import '../../widgets/prescription_grid_cell.dart';
import '../../constants.dart';
import 'prescription_preview_screen.dart';
import '../../core/core/widgets/stream_loading_widget.dart';
import '../BaseViews/baseview.dart';

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
  String? _lastErrorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    return BaseView(
      title: 'Upload Prescription',
      isContainSearch: false,
      body: Column(
        children: [
          // upload controls
          _buildUploadTab(),

          // prescriptions stream with error handling & retry
          Expanded(
            child: StreamLoadingWidget<List<Prescription>>(
              stream: _prescriptionService.getPrescriptionsStream(),
              loadingMessage: 'Loading prescriptions...',
              builder: (prescriptions) {
                if (prescriptions.isEmpty) {
                  return Center(
                    child: Text(
                      'No prescriptions uploaded yet',
                      style: TextStyle(color: AppColors.textHint),
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: prescriptions.length,
                  itemBuilder: (context, index) {
                    final p = prescriptions[index];
                    return PrescriptionGridCell(
                      prescription: p,
                      onTap: () => _navigateToPrescriptionPreview(p),
                      onDelete: () => _deletePrescription(p),
                    );
                  },
                );
              },
              errorBuilder: (error) {
                // store last error for potential debugging
                _lastErrorMessage = error?.toString();
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Failed to load prescriptions',
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error?.toString() ?? 'Unknown error',
                          style: TextStyle(color: AppColors.textHint),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              // trigger rebuild - StreamBuilder will re-subscribe
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.appColor,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              emptyBuilder: () => Center(
                child: Text(
                  'No prescriptions found',
                  style: TextStyle(color: AppColors.textHint),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadTab() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          PrescriptionUploadCell(
            isLoading: _isLoading,
            onUploadPressed: _pickAndUploadImages,
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImages() async {
    // Prevent multiple simultaneous uploads
    if (_isLoading) return;

    try {
      if (!mounted) return;
      setState(() => _isLoading = true);

      // Check permissions with timeout
      PermissionStatus permissionStatus;
      try {
        permissionStatus = await Permission.photos.request().timeout(
          const Duration(seconds: 10),
          onTimeout: () => PermissionStatus.denied,
        );
      } catch (e) {
        debugPrint('Permission request error: $e');
        _showErrorSnackBar('Failed to request permissions. Please try again.');
        return;
      }

      if (!permissionStatus.isGranted) {
        _showErrorSnackBar('Photo permission is required to upload prescriptions');
        return;
      }

      // Pick images with error handling
      List<XFile> picked;
      try {
        picked = await _prescriptionService.pickImages(
          source: ImageSource.gallery,
        ).timeout(
          const Duration(minutes: 2),
          onTimeout: () => <XFile>[],
        );
      } catch (e) {
        debugPrint('Image picker error: $e');
        _showErrorSnackBar('Failed to open image picker. Please try again.');
        return;
      }

      if (picked.isEmpty) {
        // User cancelled - not an error, just return silently
        return;
      }

      // Validate image count
      if (picked.length > 5) {
        _showErrorSnackBar('Maximum 5 images allowed. Please select fewer images.');
        return;
      }

      // Upload images with error handling
      List<Prescription> uploaded;
      try {
        uploaded = await _prescriptionService.uploadMultipleImages(picked).timeout(
          const Duration(minutes: 5),
          onTimeout: () => <Prescription>[],
        );
      } catch (e) {
        debugPrint('Upload error: $e');
        if (e.toString().contains('permission-denied')) {
          _showErrorSnackBar('Permission denied. Please check your account.');
        } else if (e.toString().contains('network')) {
          _showErrorSnackBar('Network error. Please check your connection.');
        } else if (e.toString().contains('storage')) {
          _showErrorSnackBar('Storage error. Please try again later.');
        } else {
          _showErrorSnackBar('Upload failed. Please try again.');
        }
        return;
      }

      if (uploaded.isEmpty) {
        _showErrorSnackBar('Failed to upload images. Please try again.');
        return;
      }

      // Success
      _showSuccessSnackBar(
        'Uploaded ${uploaded.length} prescription(s) successfully',
      );

    } on FirebaseException catch (fe) {
      debugPrint('FirebaseException: ${fe.code} - ${fe.message}');
      String errorMessage = 'Upload error';
      switch (fe.code) {
        case 'permission-denied':
          errorMessage = 'Permission denied. Please login again.';
          break;
        case 'unauthenticated':
          errorMessage = 'Please login to upload prescriptions.';
          break;
        case 'storage/unauthorized':
          errorMessage = 'Storage access denied. Please try again.';
          break;
        case 'storage/canceled':
          errorMessage = 'Upload was cancelled.';
          break;
        case 'storage/unknown':
          errorMessage = 'Unknown storage error. Please try again.';
          break;
        default:
          errorMessage = fe.message ?? 'Upload failed. Please try again.';
      }
      _showErrorSnackBar(errorMessage);
    } on SocketException catch (_) {
      _showErrorSnackBar('No internet connection. Please check your network.');
    } on TimeoutException catch (_) {
      _showErrorSnackBar('Upload timed out. Please try again.');
    } catch (e, st) {
      debugPrint('Unexpected upload error: $e\n$st');
      _showErrorSnackBar('Something went wrong. Please try again.');
    } finally {
      // Always reset loading state
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    if (!mounted) return;
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

  /// Safe navigation to prescription preview with error handling
  void _navigateToPrescriptionPreview(Prescription prescription) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PrescriptionPreviewScreen(prescription: prescription),
        ),
      );
    } catch (e) {
      debugPrint('Navigation error: $e');
      _showErrorSnackBar('Failed to open prescription');
    }
  }

  /// Delete prescription with confirmation dialog
  Future<void> _deletePrescription(Prescription prescription) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
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
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final success = await _prescriptionService.deletePrescription(prescription.id);
      
      if (success) {
        _showSuccessSnackBar('Prescription deleted successfully');
      } else {
        _showErrorSnackBar('Failed to delete prescription');
      }
    } catch (e) {
      debugPrint('Delete error: $e');
      _showErrorSnackBar('Error deleting prescription: ${e.toString()}');
    }
  }
}
