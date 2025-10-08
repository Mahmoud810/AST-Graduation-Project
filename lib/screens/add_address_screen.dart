import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  bool isButtonEnabled = false;

  void _checkFields() {
    setState(() {
      isButtonEnabled =
          _addressController.text.isNotEmpty &&
          _cityController.text.isNotEmpty &&
          _zipController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _addressController.addListener(_checkFields);
    _cityController.addListener(_checkFields);
    _zipController.addListener(_checkFields);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Billing Address'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (val) => val!.isEmpty ? 'Enter address' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (val) => val!.isEmpty ? 'Enter city' : null,
              ),
              TextFormField(
                controller: _zipController,
                decoration: const InputDecoration(labelText: 'ZIP Code'),
                validator: (val) => val!.isEmpty ? 'Enter ZIP code' : null,
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isButtonEnabled ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: isButtonEnabled
                    ? () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context, {
                            'address': _addressController.text,
                            'city': _cityController.text,
                            'zip': _zipController.text,
                          });
                        }
                      }
                    : null,
                child: const Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
