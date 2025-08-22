import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  static const routeName = '/payment-method';
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedMethod = '';
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final amount = args?['amount'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Summary
            Card(
              elevation: 2,
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Amount to Pay',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'RM ${amount.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Select Payment Method',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Debit/Credit Card
            _buildPaymentOption(
              theme,
              'card',
              'Debit/Credit Card',
              'Visa, Mastercard, American Express',
              Icons.credit_card,
              Colors.blue,
            ),

            const SizedBox(height: 12),

            // Bank Transfer
            _buildPaymentOption(
              theme,
              'bank',
              'Online Banking',
              'Maybank, CIMB, Public Bank, RHB',
              Icons.account_balance,
              Colors.green,
            ),

            const SizedBox(height: 12),

            // Digital Wallets
            _buildPaymentOption(
              theme,
              'ewallet',
              'Digital Wallets',
              'Touch \'n Go eWallet, GrabPay, Boost',
              Icons.phone_android,
              Colors.orange,
            ),

            const SizedBox(height: 12),

            // Crypto Wallets
            _buildPaymentOption(
              theme,
              'crypto',
              'Cryptocurrency',
              'Bitcoin, Ethereum, USDT',
              Icons.currency_bitcoin,
              Colors.amber,
            ),

            const SizedBox(height: 32),

            // Payment Details Form
            if (_selectedMethod.isNotEmpty) ...[
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildPaymentForm(theme, _selectedMethod),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(theme, amount),
    );
  }

  Widget _buildPaymentOption(
    ThemeData theme,
    String value,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
  ) {
    final isSelected = _selectedMethod == value;
    
    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMethod = value;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Radio<String>(
                value: value,
                groupValue: _selectedMethod,
                onChanged: (val) {
                  setState(() {
                    _selectedMethod = val ?? '';
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentForm(ThemeData theme, String method) {
    switch (method) {
      case 'card':
        return _buildCardForm(theme);
      case 'bank':
        return _buildBankForm(theme);
      case 'ewallet':
        return _buildEWalletForm(theme);
      case 'crypto':
        return _buildCryptoForm(theme);
      default:
        return const SizedBox();
    }
  }

  Widget _buildCardForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Card Details',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Card Number',
            hintText: '1234 5678 9012 3456',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  hintText: 'MM/YY',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: const TextField(
                decoration: InputDecoration(
                  labelText: 'CVV',
                  hintText: '123',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Cardholder Name',
            hintText: 'John Doe',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildBankForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Bank',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...['Maybank', 'CIMB Bank', 'Public Bank', 'RHB Bank', 'Hong Leong Bank']
            .map((bank) => ListTile(
                  leading: const Icon(Icons.account_balance),
                  title: Text(bank),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                )),
      ],
    );
  }

  Widget _buildEWalletForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Digital Wallet',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...['Touch \'n Go eWallet', 'GrabPay', 'Boost', 'ShopeePay']
            .map((wallet) => ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: Text(wallet),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                )),
      ],
    );
  }

  Widget _buildCryptoForm(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Cryptocurrency',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...['Bitcoin (BTC)', 'Ethereum (ETH)', 'Tether (USDT)', 'Binance Coin (BNB)']
            .map((crypto) => ListTile(
                  leading: const Icon(Icons.currency_bitcoin),
                  title: Text(crypto),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                )),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.amber),
          ),
          child: Row(
            children: [
              const Icon(Icons.info, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'You will be redirected to complete payment in your crypto wallet app.',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(ThemeData theme, double amount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: _selectedMethod.isEmpty ? null : () {
            _processPayment(context, amount);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            _selectedMethod.isEmpty 
                ? 'Select Payment Method'
                : 'Pay RM ${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void _processPayment(BuildContext context, double amount) {
    // Show processing dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Processing payment of RM ${amount.toStringAsFixed(2)}...'),
          ],
        ),
      ),
    );

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close dialog
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/payment-success',
        (route) => route.isFirst,
        arguments: {'amount': amount},
      );
    });
  }
}
