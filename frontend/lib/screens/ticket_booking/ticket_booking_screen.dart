import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4F3BA6), Color(0xFF5433FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Ticket Booking',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
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
              const SizedBox(height: 16.0),

              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement booking confirmation
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Proceed',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
