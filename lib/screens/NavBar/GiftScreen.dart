import 'package:flutter/material.dart';
import 'package:graduation_project/screens/BaseViews/BaseView.dart'
    show BaseView;
import '../BaseViews/BaseBackView.dart';

class GiftScreen extends StatelessWidget {
  const GiftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: "Gift Screen",
      body: const Center(child: Text('This is the Upload Screen')),
    );
  }
}
