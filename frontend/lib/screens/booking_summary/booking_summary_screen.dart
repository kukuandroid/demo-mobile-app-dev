import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import '../../widgets/gradient_button.dart';

class BookingSummaryScreen extends StatelessWidget {
  const BookingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Using hardcoded data as requested
    const String movieTitle = 'The Creator';
    const String imageUrl =
        'https://image.tmdb.org/t/p/w500/vBZ0qvaRxqEhZ5sRxG2q7Amd9Tu.jpg';
    const String cinema = 'GSC, Mid Valley';
    const String date = 'Aug 28, 2025';
    const String time = '10:00 PM';
    final List<String> selectedSeats = ['E5', 'E6'];
    const double ticketPrice = 40.00;
    const double convenienceFee = 2.00;
    const double totalPrice = ticketPrice + convenienceFee;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Booking Summary',
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
            _buildMovieDetailCard(movieTitle, imageUrl),
            const SizedBox(height: 24),
            _buildBookingDetailsCard(cinema, date, time, selectedSeats),
            const SizedBox(height: 24),
            _buildPaymentSummaryCard(ticketPrice, convenienceFee),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, totalPrice),
    );
  }

  Widget _buildMovieDetailCard(String title, String imageUrl) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
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
                    title,
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

  Widget _buildBookingDetailsCard(
    String cinema,
    String date,
    String time,
    List<String> seats,
  ) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
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
              seats.join(', '),
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

  Widget _buildPaymentSummaryCard(double ticketPrice, double convenienceFee) {
    final double totalPrice = ticketPrice + convenienceFee;
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildPaymentRow(
              'Ticket Price',
              'RM ${ticketPrice.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            _buildPaymentRow(
              'Convenience Fee',
              'RM ${convenienceFee.toStringAsFixed(2)}',
            ),
            const Divider(height: 24, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Payable',
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
        text: 'Proceed to payment',
        onPressed: () {
          Get.snackbar(
            'Success',
            'Payment successful! Enjoy the movie.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            duration: const Duration(seconds: 3),
          );
        },
      ),
    );
  }
}
