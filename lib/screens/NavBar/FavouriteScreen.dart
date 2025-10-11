import 'package:flutter/material.dart';
import 'package:graduation_project/screens/BaseViews/BaseView.dart';
import '../BaseViews/BaseBackView.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Favourite Screen',
      body: const Center(child: Text('This is the Favourite Screen')),
    );
  }
}
