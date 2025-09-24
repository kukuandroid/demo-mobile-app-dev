import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/price_card.dart';
import '../../widgets/location_selection_card.dart';
import '../../widgets/date_time_selection_card.dart';
import '../../widgets/seat_selection_section.dart';
import '../../widgets/booking_summary_card.dart';
import '../../widgets/ticket_booking_bottom_bar.dart';
import '../../controllers/ticket_booking_controller.dart';
import '../../models/movie.dart';

class TicketBookingScreen extends StatefulWidget {
  final Movie? movie;

  const TicketBookingScreen({super.key, this.movie});

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  @override
  void initState() {
    super.initState();
    Get.put(TicketBookingController());
  }

  @override
  void dispose() {
    // Controller will be automatically disposed by GetX
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const CustomAppBar(title: 'Ticket Booking'),
      body: GetBuilder<TicketBookingController>(
        builder: (controller) {
          if (controller.errorMessage.value.isNotEmpty &&
              !controller.isLoadingCinemas.value) {
            return _buildErrorState(controller);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Location Selection Card
                const LocationSelectionCard(),
                const SizedBox(height: 24),

                // Date & Time Selection Card
                const DateTimeSelectionCard(),
                const SizedBox(height: 24),

                // Price Information
                const PriceCard(priceRange: 'RM 15.00 - RM 25.00'),
                const SizedBox(height: 24),

                // Seat Selection Section
                const SeatSelectionSection(),
                const SizedBox(height: 24),

                // Booking Summary
                const BookingSummaryCard(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: TicketBookingBottomBar(movie: widget.movie),
    );
  }

  Widget _buildErrorState(TicketBookingController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
