import 'package:flutter/material.dart';
import 'package:haretna/core/assets/images/images.dart';

class LogoImageWidget extends StatelessWidget {
  final width;
  final height;
  final BoxFit? fit;
  const LogoImageWidget(
      {super.key, required this.width, required this.height, this.fit});

  @override
  Widget build(BuildContext context) {
    print('im $width,h $height');
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(AppImages.appLogo),
          fit: fit ?? BoxFit.contain,
        ),
      ),
    );
  }
}
