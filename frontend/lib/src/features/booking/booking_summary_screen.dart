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
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final ticketData = args ??
        {
          'movieTitle': 'Sample Movie',
          'cinema': 'GSC Pavilion KL',
          'date': '2025-08-23',
          'time': '19:30',
          'seats': ['A1', 'A2'],
          'ticketPrice': 15.0,
        };

    final ticketSubtotal = (ticketData['seats'] as List).length *
        (ticketData['ticketPrice'] as double);
    final fnbSubtotal = fnbVm.total;
    final subtotal = ticketSubtotal + fnbSubtotal;
    final discount = subtotal * _promoDiscount;
    final total = subtotal - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Summary'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildMovieHeader(ticketData, theme),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Order Details',
              icon: Icons.receipt_long,
              children: [
                _buildOrderRow(
                  'Tickets',
                  '${(ticketData['seats'] as List).length}',
                ),
                _buildOrderRow(
                  'Seats',
                  (ticketData['seats'] as List).join(', '),
                ),
                _buildOrderRow('Cinema', ticketData['cinema']),
                _buildOrderRow(
                  'Date & Time',
                  '${ticketData['date']} at ${ticketData['time']}',
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: 'Food & Beverages',
              icon: Icons.local_dining,
              children: [
                if (fnbVm.items.where((item) => item.qty > 0).isEmpty)
                  _buildEmptyState('No F&B items selected')
                else
                  ...fnbVm.items.where((item) => item.qty > 0).map(
                        (item) => _buildFnbItem(
                          item.name,
                          item.qty,
                          item.price * item.qty,
                          theme,
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 24),
            _buildPromoCodeSection(theme),
            const SizedBox(height: 24),
            _buildPriceSummary(
              theme: theme,
              ticketSubtotal: ticketSubtotal,
              fnbSubtotal: fnbSubtotal,
              discount: discount,
              total: total,
            ),
            const SizedBox(height: 100), // Space for bottom bar
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(theme, total),
    );
  }

  Widget _buildMovieHeader(Map<String, dynamic> ticketData, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.theaters, size: 48, color: Colors.black54),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticketData['movieTitle'],
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${ticketData['cinema']}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildOrderRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFnbItem(String name, int qty, double total, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$name x$qty',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
          Text(
            total.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        message,
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildPromoCodeSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.local_offer, color: Colors.grey[700]),
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promoController,
                      decoration: const InputDecoration(
                        hintText: 'Enter promo code (e.g., SAVE10)',
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        filled: true,
                        fillColor: Color(0xFFF0F0F0),
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _applyPromoCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Apply'),
                    ),
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
      ],
    );
  }

  Widget _buildPriceSummary({
    required ThemeData theme,
    required double ticketSubtotal,
    required double fnbSubtotal,
    required double discount,
    required double total,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.payments, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Text(
              'Price Summary',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            children: [
              _buildPriceRow('Ticket Subtotal', ticketSubtotal),
              if (fnbSubtotal > 0) _buildPriceRow('F&B Subtotal', fnbSubtotal),
              _buildPriceRow('Service & Processing Fees', 0.00),
              if (discount > 0)
                _buildPriceRow('Promo Discount', -discount, isDiscount: true),
              const Divider(height: 24, thickness: 1, color: Colors.black12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    total.toString(),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount, {
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87)),
          Text(
            amount.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDiscount ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme, double total) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
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
                  Text('Total Amount', style: theme.textTheme.labelMedium),
                  Text(
                    total.toString(),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Proceed to Payment',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
