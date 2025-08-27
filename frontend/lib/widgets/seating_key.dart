import 'package:flutter/material.dart';

/// A reusable seating key widget that shows seat availability legend
class SeatingKey extends StatelessWidget {
  const SeatingKey({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _buildKeyItem(Colors.white, 'Available'),
        _buildKeyItem(Colors.red, 'Unavailable'),
        _buildKeyItem(Colors.green, 'Selected'),
      ],
    );
  }

  Widget _buildKeyItem(Color color, String text) {
    return Row(
      children: <Widget>[
        Container(
          width: 16.0,
          height: 16.0,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: Colors.white, width: 1.0),
          ),
        ),
        const SizedBox(width: 8.0),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
