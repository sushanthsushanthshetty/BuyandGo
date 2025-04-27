import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final double total;

  const CheckoutPage({
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Step tracking
  int _currentStep = 0;

  // Form keys for validation
  final _addressFormKey = GlobalKey<FormState>();
  final _paymentFormKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  // Payment method selection
  String _selectedPaymentMethod = 'Credit Card';
  final List<String> _paymentMethods = [
    'Credit Card',
    'Debit Card',
    'UPI',
    'Net Banking',
    'Cash on Delivery',
  ];

  // Delivery options
  String _selectedDeliveryOption = 'Standard';
  final Map<String, Map<String, dynamic>> _deliveryOptions = {
    'Standard': {
      'price': 200,
      'description': '3-5 business days',
    },
    'Express': {
      'price': 400,
      'description': '1-2 business days',
    },
    'Same Day': {
      'price': 600,
      'description': 'Delivered today',
    },
  };

  // Get delivery charge based on selected option
  double get _deliveryCharge {
    return _deliveryOptions[_selectedDeliveryOption]!['price'];
  }

  // Calculate final total with delivery charge
  double get _finalTotal {
    return widget.total + _deliveryCharge;
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // Process order
  void _placeOrder() {
    // Validate the current form before proceeding
    if (_currentStep == 0 && !_addressFormKey.currentState!.validate()) {
      return;
    } else if (_currentStep == 1 &&
        _selectedPaymentMethod == 'Credit Card' &&
        !_paymentFormKey.currentState!.validate()) {
      return;
    }

    // In a real app, you would:
    // 1. Process payment
    // 2. Create order in database
    // 3. Clear cart
    // 4. Navigate to order confirmation

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Processing your order..."),
            ],
          ),
        );
      },
    );

    // Simulate API call delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog

      // Navigate to order success page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderSuccessPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep == 0) {
                  if (_addressFormKey.currentState!.validate()) {
                    setState(() {
                      _currentStep += 1;
                    });
                  }
                } else if (_currentStep == 1) {
                  if (_selectedPaymentMethod == 'Credit Card') {
                    if (_paymentFormKey.currentState!.validate()) {
                      _placeOrder();
                    }
                  } else {
                    _placeOrder();
                  }
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                }
              },
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightBlueAccent,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            _currentStep == 1 ? 'Place Order' : 'Continue',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      if (_currentStep > 0) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: details.onStepCancel,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Back',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
              steps: [
                // Shipping Information
                Step(
                  title: const Text('Shipping Information'),
                  content: Form(
                    key: _addressFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            } else if (value.length != 10) {
                              return 'Phone number should be 10 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _addressLine1Controller,
                          decoration: const InputDecoration(
                            labelText: 'Address Line 1',
                            prefixIcon: Icon(Icons.home),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _addressLine2Controller,
                          decoration: const InputDecoration(
                            labelText: 'Address Line 2 (Optional)',
                            prefixIcon: Icon(Icons.home),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _cityController,
                                decoration: const InputDecoration(
                                  labelText: 'City',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _stateController,
                                decoration: const InputDecoration(
                                  labelText: 'State',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _pincodeController,
                          decoration: const InputDecoration(
                            labelText: 'Pincode',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter pincode';
                            } else if (value.length != 6) {
                              return 'Pincode should be 6 digits';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Delivery options
                        const Text(
                          'Delivery Options',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...(_deliveryOptions.entries.map((option) {
                          return RadioListTile<String>(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(option.key),
                                    Text(
                                      option.value['description'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '₹${option.value['price']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            value: option.key,
                            groupValue: _selectedDeliveryOption,
                            onChanged: (value) {
                              setState(() {
                                _selectedDeliveryOption = value!;
                              });
                            },
                            activeColor: Colors.lightBlueAccent,
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList()),
                      ],
                    ),
                  ),
                  isActive: _currentStep >= 0,
                  state:
                      _currentStep > 0 ? StepState.complete : StepState.indexed,
                ),

                // Payment Information
                Step(
                  title: const Text('Payment Information'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Payment method selector
                      const Text(
                        'Select Payment Method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      ...(_paymentMethods.map((method) {
                        return RadioListTile<String>(
                          title: Text(method),
                          value: method,
                          groupValue: _selectedPaymentMethod,
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value!;
                            });
                          },
                          activeColor: Colors.lightBlueAccent,
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList()),

                      const SizedBox(height: 16),

                      // Credit Card form (show only if Credit Card is selected)
                      if (_selectedPaymentMethod == 'Credit Card')
                        Form(
                          key: _paymentFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const SizedBox(height: 16),

                              const Text(
                                'Card Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Card Number
                              TextFormField(
                                controller: _cardNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'Card Number',
                                  prefixIcon: Icon(Icons.credit_card),
                                  hintText: 'XXXX XXXX XXXX XXXX',
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter card number';
                                  } else if (value.replaceAll(' ', '').length !=
                                      16) {
                                    return 'Card number should be 16 digits';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Card Holder
                              TextFormField(
                                controller: _cardHolderController,
                                decoration: const InputDecoration(
                                  labelText: 'Card Holder Name',
                                  prefixIcon: Icon(Icons.person),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter card holder name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // Expiry and CVV
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _expiryController,
                                      decoration: const InputDecoration(
                                        labelText: 'Expiry (MM/YY)',
                                        hintText: 'MM/YY',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required';
                                        } else if (!RegExp(r'^\d{2}/\d{2}$')
                                            .hasMatch(value)) {
                                          return 'Use MM/YY format';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _cvvController,
                                      decoration: const InputDecoration(
                                        labelText: 'CVV',
                                        hintText: 'XXX',
                                      ),
                                      obscureText: true,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Required';
                                        } else if (value.length != 3) {
                                          return 'Invalid CVV';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      // UPI Payment (show only if UPI is selected)
                      if (_selectedPaymentMethod == 'UPI')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'UPI ID',
                                hintText: 'example@upi',
                                prefixIcon: Icon(Icons.account_balance),
                              ),
                            ),
                          ],
                        ),

                      // Order summary
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Order summary
                      const Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Price details
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            // Subtotal
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Subtotal',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  '₹${widget.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Delivery
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Delivery ($_selectedDeliveryOption)',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                Text(
                                  '₹${_deliveryCharge.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24),

                            // Total
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '₹${_finalTotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  isActive: _currentStep >= 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Order Success Page
class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Placed'),
        backgroundColor: Colors.lightBlueAccent,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 80,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                'Your order has been placed and is being processed. You will receive a confirmation email shortly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Order ID: ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(5, 13)}',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate back to home page
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Continue Shopping',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
