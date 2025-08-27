import 'package:flutter/material.dart';

/// A reusable price card widget that displays ticket price ranges
class PriceCard extends StatelessWidget {
  final String priceRange;

  const PriceCard({
    super.key,
    required this.priceRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Center(
        child: Text(
          'Tickets from\n$priceRange',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14.0),
        ),
      ),
    );
  }
}
