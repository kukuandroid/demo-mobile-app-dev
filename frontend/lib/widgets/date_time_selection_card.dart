import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ticket_booking_controller.dart';
import 'date_selector.dart';
import 'time_selector.dart';

class DateTimeSelectionCard extends StatelessWidget {
  const DateTimeSelectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketBookingController>(
      builder: (controller) {
        return Card(
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
                DateSelector(
                  onDateSelected: (dateData) {
                    // Create a DateTime object from the selected date
                    final selectedDate = DateTime(
                      2025, // Using current year as default
                      controller.getMonthFromDateString(dateData['day']!),
                      int.parse(dateData['date']!),
                    );
                    controller.onDateSelected(selectedDate);
                  },
                ),
                const SizedBox(height: 24),
                TimeSelector(
                  onTimeSelected: (time) => controller.onTimeSelected(time),
                ),
              ],
            ),
          ),
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
