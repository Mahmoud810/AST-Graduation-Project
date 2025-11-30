import 'package:flutter/material.dart';
import '../constants.dart';

class PrescriptionUploadCell extends StatelessWidget {
  final VoidCallback onUploadPressed;
  final bool isLoading;

  const PrescriptionUploadCell({
    super.key,
    required this.onUploadPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.appColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.appColor.withOpacity(0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isLoading ? null : onUploadPressed,
          child: Center(
            child: isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.appColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Uploading...',
                        style: TextStyle(
                          color: AppColors.appColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.appColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 32,
                          color: AppColors.appColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Upload Prescriptions',
                        style: TextStyle(
                          color: AppColors.appColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to add multiple images',
                        style: TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
