import 'package:flutter/material.dart';
import 'package:frontend/config/strings.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import '../../widgets/gradient_button.dart';
import '../../models/food_item.dart';

class BookingSummaryScreen extends StatelessWidget {
  final String movieTitle;
  final String imageUrl;
  final String cinema;
  final String date;
  final String time;
  final List<String> selectedSeats;
  final double ticketPrice;
  final List<FoodItem>? selectedFoodItems;
  final double? foodTotal;

  const BookingSummaryScreen({
    super.key,
    required this.movieTitle,
    required this.imageUrl,
    required this.cinema,
    required this.date,
    required this.time,
    required this.selectedSeats,
    required this.ticketPrice,
    this.selectedFoodItems,
    this.foodTotal,
  });

  @override
  Widget build(BuildContext context) {
    const double convenienceFee = 2.00;
    final double foodTotal = this.foodTotal ?? 0.0;
    final double totalPrice = ticketPrice + convenienceFee + foodTotal;

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.bookingSummaryLabel,
        actions: [
          TextButton(
            onPressed: () {
              // Handle skip action
              Get.toNamed(AppRoutes.bookingSummary);
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieDetailCard(),
            const SizedBox(height: 24),
            _buildBookingDetailsCard(),
            const SizedBox(height: 24),
            if (selectedFoodItems != null && selectedFoodItems!.isNotEmpty)
              _buildFoodItemsCard(selectedFoodItems!, foodTotal),
            if (selectedFoodItems != null && selectedFoodItems!.isNotEmpty)
              const SizedBox(height: 24),
            _buildPaymentSummaryCard(convenienceFee, foodTotal),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, totalPrice),
    );
  }

  Widget _buildMovieDetailCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 100,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.movie, size: 100),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movieTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fantasy, Sci-Fi', // Hardcoded genre
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetailsCard() {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(Icons.location_on_outlined, 'Cinema', cinema),
            const Divider(height: 32),
            _buildDetailRow(Icons.calendar_today_outlined, 'Date', date),
            const Divider(height: 32),
            _buildDetailRow(Icons.access_time_outlined, 'Time', time),
            const Divider(height: 32),
            _buildDetailRow(
              Icons.event_seat_outlined,
              'Seats',
              selectedSeats.join(', '),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 22),
        const SizedBox(width: 16),
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFoodItemsCard(List<FoodItem> foodItems, double foodTotal) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Food & Beverages',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...foodItems.where((item) => item.quantity > 0).map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.name} x${item.quantity}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    Text(
                      'RM ${(item.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            }).toList(),
            const Divider(height: 24, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Food & Beverages Total',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'RM ${foodTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSummaryCard(double convenienceFee, double foodTotal) {
    final double totalPrice = ticketPrice + convenienceFee + foodTotal;
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.paymentSummaryLabel,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentRow(
              AppStrings.ticketPriceLabel,
              'RM ${ticketPrice.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            if (foodTotal > 0)
              _buildPaymentRow(
                'Food & Beverages',
                'RM ${foodTotal.toStringAsFixed(2)}',
              ),
            if (foodTotal > 0)
              const SizedBox(height: 8),
            _buildPaymentRow(
              AppStrings.convenienceFeeLabel,
              'RM ${convenienceFee.toStringAsFixed(2)}',
            ),
            const Divider(height: 24, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppStrings.totalPayableLabel,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'RM ${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        Text(
          amount,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, double totalPrice) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: GradientButton(
        text: AppStrings.proceedToPaymentButton,
        onPressed: () {
          Get.toNamed(AppRoutes.paymentMethod);
        },
      ),
    );
  }
}
