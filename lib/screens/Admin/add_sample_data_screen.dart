import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart';
import 'package:graduation_project/core/utils/sample_data.dart';
import 'package:graduation_project/screens/BaseViews/BaseBackView.dart';

/// Simple admin screen to populate Firestore with sample data
/// Access this screen once to add products to your database
class AddSampleDataScreen extends StatefulWidget {
  const AddSampleDataScreen({super.key});

  @override
  State<AddSampleDataScreen> createState() => _AddSampleDataScreenState();
}

class _AddSampleDataScreenState extends State<AddSampleDataScreen> {
  final SampleDataHelper _sampleDataHelper = SampleDataHelper();
  bool _isLoading = false;
  String _message = '';

  Future<void> _addSampleProducts() async {
    setState(() {
      _isLoading = true;
      _message = 'Adding sample products to Firestore...';
    });

    try {
      await _sampleDataHelper.addSampleProducts();
      setState(() {
        _isLoading = false;
        _message = '✅ Successfully added 10 sample products!\n\n'
            'You can now:\n'
            '• View products in the Home screen\n'
            '• Add products to cart\n'
            '• Add products to favourites\n\n'
            'Go back and enjoy the app!';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _message = '❌ Error adding products:\n$e\n\n'
            'Please check:\n'
            '• Firebase is configured\n'
            '• Firestore rules are deployed\n'
            '• Internet connection is active';
      });
    }
  }

  Future<void> _clearAllProducts() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Products'),
        content: const Text(
          'Are you sure you want to delete ALL products from Firestore?\n\n'
          'This action cannot be undone!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.red,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
        _message = 'Clearing all products...';
      });

      try {
        await _sampleDataHelper.clearAllProducts();
        setState(() {
          _isLoading = false;
          _message = '✅ All products have been deleted from Firestore.';
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _message = '❌ Error clearing products:\n$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseBackView(
      title: 'Admin - Sample Data',
      onBackPressed: () => Navigator.pop(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            // Info Card
            Card(
              color: AppColors.appColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.appColor,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Database Setup',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.appColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Click "Add Sample Products" to populate your Firestore database with 10 medicine products.\n\n'
                      'This includes:\n'
                      '• Panadol, Vitamin C, Omega-3\n'
                      '• Antinal, Cataflam, Strepsils\n'
                      '• Concor, Cetaphil, Augmentin\n'
                      '• Nexium\n\n'
                      'Each product has detailed information including dosage, manufacturer, and side effects.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Add Sample Products Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _addSampleProducts,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: AppColors.grey,
              ),
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  : const Icon(Icons.add_shopping_cart),
              label: Text(
                _isLoading ? 'Adding Products...' : 'Add Sample Products',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Clear All Products Button
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _clearAllProducts,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: _isLoading ? AppColors.grey : AppColors.red,
                ),
              ),
              icon: const Icon(Icons.delete_outline),
              label: const Text(
                'Clear All Products',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Message Display
            if (_message.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    color: _message.startsWith('✅')
                        ? Colors.green.withOpacity(0.1)
                        : _message.startsWith('❌')
                            ? Colors.red.withOpacity(0.1)
                            : AppColors.grey.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _message,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
