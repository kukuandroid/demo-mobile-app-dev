import 'package:flutter/material.dart';

enum SeatStatus { available, selected, unavailable, vip }

class Seat extends StatelessWidget {
  final String label;
  final SeatStatus status;
  final VoidCallback? onTap;
  final double size;
  final double borderRadius;

  const Seat({
    super.key,
    required this.label,
    this.status = SeatStatus.available,
    this.onTap,
    this.size = 32.0,
    this.borderRadius = 8.0,
  });

  Color _getSeatColor() {
    switch (status) {
      case SeatStatus.available:
        return Colors.white;
      case SeatStatus.selected:
        return const Color(0xFF4F3BA6);
      case SeatStatus.unavailable:
        return Colors.grey.shade800;
      case SeatStatus.vip:
        return const Color(0xFFFFD700);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: status == SeatStatus.unavailable ? null : onTap,
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          color: _getSeatColor(),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: status == SeatStatus.unavailable
                ? Colors.grey.shade700
                : Colors.grey.shade400,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: status == SeatStatus.available
                  ? Colors.black
                  : Colors.white,
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
