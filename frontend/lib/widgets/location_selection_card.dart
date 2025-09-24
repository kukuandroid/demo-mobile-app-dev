import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ticket_booking_controller.dart';
import 'dropdown_field.dart';

class LocationSelectionCard extends StatelessWidget {
  const LocationSelectionCard({super.key});

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
                _buildSectionHeader(Icons.location_on_outlined, 'Location'),
                const SizedBox(height: 16),
                Obx(() {
                  print(
                    'Obx triggered - isLoadingCinemas: ${controller.isLoadingCinemas.value}',
                  );
                  if (controller.isLoadingCinemas.value) {
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  } else {
                    return Obx(
                      () => DropdownField(
                        hint: 'Select Location',
                        items: controller.availableLocations,
                        value: controller.selectedLocation.value.isNotEmpty
                            ? controller.selectedLocation.value
                            : null,
                        onChanged: controller.onLocationSelected,
                      ),
                    );
                  }
                }),
                const SizedBox(height: 16),
                Obx(
                  () => DropdownField(
                    hint: 'Select Cinema Hall',
                    items: controller.availableCinemas,
                    value: controller.selectedCinema.value.isNotEmpty
                        ? controller.selectedCinema.value
                        : null,
                    onChanged: controller.onCinemaSelected,
                  ),
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
