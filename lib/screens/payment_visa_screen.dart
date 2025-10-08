import 'package:flutter/material.dart';

import 'payment_success_screen.dart';

class PaymentVisaScreen extends StatelessWidget {
  const PaymentVisaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController cardNumController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              'https://upload.wikimedia.org/wikipedia/commons/0/04/Visa.svg',
              width: 100,
              height: 60,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: cardNumController,
              decoration: const InputDecoration(
                labelText: 'Credit Card Number',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Card Holder Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentSuccessScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Pay EGP 57',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
