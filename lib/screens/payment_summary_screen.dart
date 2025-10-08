import 'package:flutter/material.dart';
import 'package:graduation_project/constants.dart' show AppColors;

import 'add_address_screen.dart';
import 'payment_success_screen.dart';
import 'payment_visa_screen.dart';

class PaymentSummaryScreen extends StatefulWidget {
  final double subtotal;

  const PaymentSummaryScreen({super.key, required this.subtotal});

  @override
  State<PaymentSummaryScreen> createState() => _PaymentSummaryScreenState();
}

class _PaymentSummaryScreenState extends State<PaymentSummaryScreen> {
  String selectedPayment = 'card';
  String selectedAddressOption = 'same';

  @override
  Widget build(BuildContext context) {
    double deliveryFee = 20;
    double total = widget.subtotal + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: AppColors.appColor,
        foregroundColor: AppColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            const Text(
              'All transactions are secure and encrypted.',
              style: TextStyle(color: AppColors.grey),
            ),
            const SizedBox(height: 20),

            // 🔹 Payment Methods
            buildPaymentOption(
              title: 'Credit Card & Wallet Payments',
              subtitle: 'Powered by PayTabs',
              icons: const [
                SizedBox(width: 8),
                Icon(Icons.credit_card, size: 20),
              ],
              value: 'card',
            ),
            const SizedBox(height: 8),
            buildPaymentOption(title: 'Cash on Delivery', value: 'cash'),
            const SizedBox(height: 20),

            // 🔹 Address options
            buildAddressOption('same', 'Same as shipping address'),
            buildAddressOption('different', 'Use a different billing address'),

            const Spacer(),

            // 🔹 Totals
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal'),
                Text('EGP ${widget.subtotal.toStringAsFixed(2)}'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Delivery Fee'),
                Text('EGP ${deliveryFee.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'EGP ${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 🔹 Confirm Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                if (selectedAddressOption == 'different') {
                  final newAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddAddressScreen()),
                  );
                  if (newAddress == null) return;
                }

                if (selectedPayment == 'card') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaymentVisaScreen(),
                    ),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PaymentSuccessScreen(),
                    ),
                  );
                }
              },
              child: const Text(
                'Confirm Payment',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentOption({
    required String title,
    String? subtitle,
    String? value,
    List<Widget>? icons,
  }) {
    return GestureDetector(
      onTap: () => setState(() => selectedPayment = value!),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedPayment == value
                ? AppColors.appColor
                : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value!,
              groupValue: selectedPayment,
              onChanged: (val) => setState(() => selectedPayment = val!),
              activeColor: AppColors.appColor,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(color: AppColors.grey),
                    ),
                ],
              ),
            ),
            if (icons != null) Row(children: icons),
          ],
        ),
      ),
    );
  }

  Widget buildAddressOption(String value, String label) {
    return RadioListTile<String>(
      value: value,
      groupValue: selectedAddressOption,
      onChanged: (val) => setState(() => selectedAddressOption = val!),
      title: Text(label),
      activeColor: AppColors.appColor,
      contentPadding: EdgeInsets.zero,
    );
  }
}
