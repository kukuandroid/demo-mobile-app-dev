import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/food_beverages_controller.dart';
import '../config/strings.dart';
import 'gradient_button.dart';

class FoodBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onSkip;

  const FoodBottomSheet({
    super.key,
    required this.onConfirm,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FoodBeveragesController>(
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Total price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.totalPriceLabel,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'RM ${controller.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    // Skip button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onSkip,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFF6C63FF)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          AppStrings.skipButton,
                          style: TextStyle(
                            color: Color(0xFF6C63FF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Confirm button
                    Expanded(
                      flex: 2,
                      child: GradientButton(
                        text: AppStrings.confirmButton,
                        onPressed: controller.hasSelectedItems
                            ? onConfirm
                            : null,
                        height: 48,
                        borderRadius: BorderRadius.circular(12),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
