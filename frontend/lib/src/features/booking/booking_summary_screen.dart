import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../fnb/fnb_viewmodel.dart';
import '../payment/payment_screen.dart';

class BookingSummaryScreen extends StatefulWidget {
  static const routeName = '/booking-summary';
  const BookingSummaryScreen({super.key});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final TextEditingController _promoController = TextEditingController();
  double _promoDiscount = 0.0;
  String? _promoMessage;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromoCode() {
    final code = _promoController.text.trim().toUpperCase();
    setState(() {
      if (code == 'SAVE10') {
        _promoDiscount = 0.10; // 10% discount
        _promoMessage = '10% discount applied!';
      } else if (code == 'WELCOME5') {
        _promoDiscount = 0.05; // 5% discount
        _promoMessage = '5% discount applied!';
      } else if (code.isNotEmpty) {
        _promoDiscount = 0.0;
        _promoMessage = 'Invalid promo code';
      } else {
        _promoDiscount = 0.0;
        _promoMessage = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fnbVm = context.watch<FnbViewModel>();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    // Mock ticket data - in real app this would come from booking state
    final ticketData = args ?? {
      'movieTitle': 'Sample Movie',
      'cinema': 'GSC Pavilion KL',
      'date': '2025-08-23',
      'time': '19:30',
      'seats': ['A1', 'A2'],
      'ticketPrice': 15.0,
    };

    final ticketSubtotal = (ticketData['seats'] as List).length * (ticketData['ticketPrice'] as double);
    final fnbSubtotal = fnbVm.total;
    final subtotal = ticketSubtotal + fnbSubtotal;
    final discount = subtotal * _promoDiscount;
    final total = subtotal - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
        backgroundColor: theme.colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie & Ticket Details
            _buildSectionCard(
              theme,
              'Movie Ticket',
              Icons.movie,
              [
                _buildDetailRow('Movie', ticketData['movieTitle']),
                _buildDetailRow('Cinema', ticketData['cinema']),
                _buildDetailRow('Date', ticketData['date']),
                _buildDetailRow('Time', ticketData['time']),
                _buildDetailRow('Seats', (ticketData['seats'] as List).join(', ')),
                _buildDetailRow('Quantity', '${(ticketData['seats'] as List).length} ticket(s)'),
                _buildPriceRow('Ticket Subtotal', ticketSubtotal, theme),
              ],
            ),

            const SizedBox(height: 16),

            // F&B Details
            _buildSectionCard(
              theme,
              'Food & Beverages',
              Icons.restaurant,
              [
                if (fnbVm.items.where((item) => item.qty > 0).isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text('No F&B items selected'),
                  )
                else
                  ...fnbVm.items.where((item) => item.qty > 0).map((item) => 
                    _buildFnbRow(item.name, item.qty, item.price * item.qty, theme)
                  ),
                if (fnbSubtotal > 0)
                  _buildPriceRow('F&B Subtotal', fnbSubtotal, theme),
              ],
            ),

            const SizedBox(height: 16),

            // Charges & Fees
            _buildSectionCard(
              theme,
              'Charges & Fees',
              Icons.receipt,
              [
                _buildDetailRow('Service Charge', 'RM 0.00'),
                _buildDetailRow('Processing Fee', 'RM 0.00'),
                _buildDetailRow('Convenience Fee', 'RM 0.00'),
              ],
            ),

            const SizedBox(height: 16),

            // Promo Code
            _buildPromoCodeSection(theme),

            const SizedBox(height: 24),

            // Total Summary
            _buildTotalSummary(theme, subtotal, discount, total),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(theme, total),
    );
  }

  Widget _buildSectionCard(ThemeData theme, String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            'RM ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFnbRow(String name, int qty, double total, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('$name x$qty')),
          Text(
            'RM ${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection(ThemeData theme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_offer, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Promo Code',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    decoration: const InputDecoration(
                      hintText: 'Enter promo code (try SAVE10 or WELCOME5)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _applyPromoCode,
                  child: const Text('Apply'),
                ),
              ],
            ),
            if (_promoMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _promoMessage!,
                style: TextStyle(
                  color: _promoDiscount > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSummary(ThemeData theme, double subtotal, double discount, double total) {
    return Card(
      elevation: 4,
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow('Subtotal', subtotal, theme),
            if (discount > 0) ...[
              const SizedBox(height: 4),
              _buildSummaryRow('Discount', -discount, theme, isDiscount: true),
            ],
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount Payable',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'RM ${total.toStringAsFixed(2)}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, ThemeData theme, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          '${isDiscount ? '-' : ''}RM ${amount.abs().toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDiscount ? Colors.green : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(ThemeData theme, double total) {
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
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: theme.textTheme.labelMedium,
                  ),
                  Text(
                    'RM ${total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  PaymentScreen.routeName,
                  arguments: {
                    'amount': total,
                    'bookingSummary': 'Movie tickets and F&B',
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Proceed to Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
