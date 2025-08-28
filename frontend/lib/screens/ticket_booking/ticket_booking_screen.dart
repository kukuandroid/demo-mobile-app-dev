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
import '../../widgets/cinema_seat_layout.dart';

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
      appBar: const CustomAppBar(title: 'Ticket Booking'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Where would you like to see the movie? Kindly select as appropriate',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Location',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              const DropdownField(hint: 'Select Location'),
              const SizedBox(height: 16.0),
              const Text(
                'Cinema Location',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              const DropdownField(hint: 'Select Cinema Hall'),
              const SizedBox(height: 24.0),
              const Text(
                'Select a date',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              DateSelector(),
              const SizedBox(height: 24.0),
              const Text(
                'Available Time',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TimeSelector(),
              const SizedBox(height: 24.0),
              PriceCard(priceRange: 'RM 15.00 - RM 25.00'),
              const SizedBox(height: 16.0),
              const SeatingKey(),
              const SizedBox(height: 16.0),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: CinemaSeatLayout(
                  rows: 10,
                  seatsPerRow: 10,
                  vipRows: const [0, 1], // First two rows are VIP
                  selectedSeats: selectedSeats,
                  onSeatsSelected: _onSeatsSelected,
                  unavailableSeats: unavailableSeats,
                  seatSize: 26.0,
                  seatSpacing: 6.0,
                  rowSpacing: 12.0,
                  screenHeight: 50.0,
                  screenLabel: 'SCREEN',
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          const SizedBox(width: 16.0),
          Expanded(
            child: GradientButton(
              text: 'Proceed',
              onPressed: () {
                Get.toNamed(AppRoutes.foodBeverages);
              },
            ),
          ),
        ],
      ),
    );
  }
}
