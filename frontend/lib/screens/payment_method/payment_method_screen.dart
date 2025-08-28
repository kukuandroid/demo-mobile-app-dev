import 'package:flutter/material.dart';
import 'package:frontend/config/strings.dart';
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
      appBar: const CustomAppBar(title: AppStrings.paymentMethodLabel),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.paymentMethod,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.paymentMethodSubtitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32.0),
            PaymentOptionCard(
              icon: Icons.credit_card_outlined,
              title: AppStrings.debitCard,
              subtitle: AppStrings.debitCardDescription,
              onTap: () {
                Get.toNamed(AppRoutes.orderAcknowledgement);
              },
            ),
            PaymentOptionCard(
              icon: Icons.account_balance_wallet_outlined,
              title: AppStrings.bankTransfer,
              subtitle: AppStrings.bankTransferDescription,
              onTap: () {
                Get.toNamed(AppRoutes.orderAcknowledgement);
              },
            ),
            PaymentOptionCard(
              icon: Icons.currency_bitcoin,
              title: AppStrings.cryptoWallets,
              subtitle: AppStrings.cryptoWalletsDescription,
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
