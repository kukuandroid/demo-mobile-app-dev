import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/custom_app_bar.dart';
import 'package:frontend/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../../widgets/price_card.dart';
import '../../widgets/dropdown_field.dart';
import '../../widgets/date_selector.dart';
import '../../widgets/time_selector.dart';
import '../../widgets/seating_key.dart';

class TicketBookingScreen extends StatefulWidget {
  const TicketBookingScreen({super.key});

  @override
  State<TicketBookingScreen> createState() => _TicketBookingScreenState();
}

class _TicketBookingScreenState extends State<TicketBookingScreen> {
  final List<String> selectedSeats = [];
  final Map<String, bool> unavailableSeats = {
    'A1': true,
    'A2': true,
    'B5': true,
    'C3': true,
    'D7': true,
    'E4': true,
    'F9': true,
    'G2': true,
    'H6': true,
    'J8': true,
  };

  void _onSeatsSelected(List<String> seats) {
    setState(() {
      selectedSeats.clear();
      selectedSeats.addAll(seats);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const CustomAppBar(title: 'Ticket Booking'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Location Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(Icons.location_on_outlined, 'Location'),
                    const SizedBox(height: 16),
                    const DropdownField(hint: 'Select Location'),
                    const SizedBox(height: 16),
                    const DropdownField(hint: 'Select Cinema Hall'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Date & Time Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(
                      Icons.calendar_today_outlined,
                      'Date & Time',
                    ),
                    const SizedBox(height: 16),
                    DateSelector(),
                    const SizedBox(height: 24),
                    TimeSelector(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            PriceCard(priceRange: 'RM 15.00 - RM 25.00'),
            const SizedBox(height: 24),

            _buildSectionHeader(Icons.event_seat_outlined, 'Select Seats'),
            const SizedBox(height: 16),
            const SeatingKey(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 55,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black87,
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 55,
              child: GradientButton(
                text: 'Proceed',
                onPressed: () {
                  Get.toNamed(AppRoutes.foodBeverages);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
