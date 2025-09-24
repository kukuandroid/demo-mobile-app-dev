import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ticket_booking_controller.dart';
import 'seating_key.dart';
import 'cinema_seat_layout.dart';

class SeatSelectionSection extends StatelessWidget {
  const SeatSelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketBookingController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(Icons.event_seat_outlined, 'Select Seats'),
            const SizedBox(height: 16),
            const SeatingKey(),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: CinemaSeatLayout(
                rows: 10,
                seatsPerRow: 10,
                vipRows: TicketBookingController.vipRows,
                selectedSeats: controller.selectedSeats,
                onSeatsSelected: controller.onSeatsSelected,
                unavailableSeats: controller.unavailableSeats,
                seatSize: 26.0,
                seatSpacing: 6.0,
                rowSpacing: 12.0,
                screenHeight: 50.0,
                screenLabel: 'SCREEN',
                regularSeatPrice: TicketBookingController.regularSeatPrice,
                vipSeatPrice: TicketBookingController.vipSeatPrice,
              ),
            ),
          ],
        );
      },
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
}
