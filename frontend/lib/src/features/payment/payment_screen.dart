import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'payment_viewmodel.dart';

class PaymentScreen extends StatelessWidget {
  static const routeName = '/payment';
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PaymentViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: Center(
        child: vm.success
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 64),
                  SizedBox(height: 8),
                  Text('Payment successful! Booking confirmed'),
                ],
              )
            : vm.paying
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => context.read<PaymentViewModel>().pay(),
                    child: const Text('Pay Now'),
                  ),
      ),
    );
  }
}
