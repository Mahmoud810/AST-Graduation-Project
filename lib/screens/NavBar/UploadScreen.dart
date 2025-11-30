import 'package:flutter/material.dart';
import 'prescription_upload_screen.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // PrescriptionUploadScreen already has its own Scaffold and AppBar
    // No need to wrap it in BaseView
    return const PrescriptionUploadScreen();
  }
}
