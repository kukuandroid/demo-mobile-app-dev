import 'package:flutter/material.dart';

/// A reusable chip widget for displaying small pieces of information
class InfoChip extends StatelessWidget {
  final String text;

  const InfoChip({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}

/// A reusable row widget for displaying labeled information with various value types
class InfoRow extends StatelessWidget {
  final String label;
  final dynamic value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    Widget valueWidget;
    if (value is List<String>) {
      valueWidget = Wrap(
        spacing: 10,
        runSpacing: 4,
        children: value.map<Widget>((v) => InfoChip(text: v)).toList(),
      );
    } else if (value is String) {
      valueWidget = Text(
        value,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      );
    } else {
      valueWidget = const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          subtitle: valueWidget,
          horizontalTitleGap: 12,
          minLeadingWidth: 0,
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}
