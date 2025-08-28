import 'package:flutter/material.dart';
import 'package:frontend/config/strings.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/widgets/gradient_button.dart';
import 'package:get/get.dart';

class OrderAcknowledgementScreen extends StatelessWidget {
  const OrderAcknowledgementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success Icon
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(scale: scale, child: child);
                },
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Title
              const Text(
                AppStrings.congratulationsLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                AppStrings.orderAcknowledgementLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 64),

              // Action Button
              SizedBox(
                height: 55,
                child: GradientButton(
                  text: AppStrings.mainMenuButton,
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.home);
                  },
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // TODO: Implement "View E-tickets" functionality
                },
                child: Text(
                  AppStrings.viewTicketButton,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
