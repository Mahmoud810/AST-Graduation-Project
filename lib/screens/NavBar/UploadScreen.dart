import 'package:flutter/material.dart';
import 'package:graduation_project/screens/BaseViews/BaseBackView.dart';
import 'package:graduation_project/screens/BaseViews/baseview.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: "Upload Screen",
      isContainSearch: false,
      body: const Center(child: Text('This is the Upload Screen')),
    );
  }
}
