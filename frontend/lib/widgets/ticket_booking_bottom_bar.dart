import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ticket_booking_controller.dart';
import '../models/movie.dart';
import '../screens/food_beverages/food_beverages_screen.dart';
import 'gradient_button.dart';

class TicketBookingBottomBar extends StatelessWidget {
  final Movie? movie;

  const TicketBookingBottomBar({super.key, this.movie});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketBookingController>(
      builder: (controller) {
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
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
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
                    onPressed: controller.canProceed
                        ? () => _handleProceed(controller)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleProceed(TicketBookingController controller) {
    controller.validateAndProceed(movie, () {
      Get.to(
        () => FoodBeveragesScreen(
          movie: movie,
          cinema: controller.selectedCinemaDisplayName,
          date: controller.selectedDate.value!,
          time: controller.selectedTime.value,
          selectedSeats: controller.selectedSeats,
          ticketPrice: controller.totalPrice.value,
        ),
      );
    });
  }
}
