import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/custom_app_bar.dart';
import 'package:frontend/widgets/payment_option_card.dart';
import 'package:get/get.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Payment Method'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How would you like to make the payment?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kindly select your preferred option',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32.0),
            PaymentOptionCard(
              icon: Icons.credit_card_outlined,
              title: 'Debit Card',
              subtitle: 'Pay with your Visa or Mastercard',
              onTap: () {
                Get.toNamed(AppRoutes.orderAcknowledgement);
              },
            ),
            PaymentOptionCard(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Bank Transfer',
              subtitle: 'FPX, direct bank-in',
              onTap: () {
                Get.toNamed(AppRoutes.orderAcknowledgement);
              },
            ),
            PaymentOptionCard(
              icon: Icons.currency_bitcoin,
              title: 'Crypto Wallets',
              subtitle: 'Pay with Bitcoin, Ethereum, etc.',
              onTap: () {
                Get.toNamed(AppRoutes.orderAcknowledgement);
              },
            ),
          ],
        ),
      ),
    );
  }

}
