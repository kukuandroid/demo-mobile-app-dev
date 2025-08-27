import 'package:flutter/material.dart';

/// A reusable time chip widget for displaying individual time slots
class TimeChip extends StatefulWidget {
  final String time;
  final bool isSelected;
  final VoidCallback? onTap;

  const TimeChip({
    super.key,
    required this.time,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<TimeChip> createState() => _TimeChipState();
}

class _TimeChipState extends State<TimeChip> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.grey[700] : Colors.grey[850],
          borderRadius: BorderRadius.circular(8.0),
          border: widget.isSelected 
              ? Border.all(color: Colors.white, width: 1)
              : null,
        ),
        child: Text(
          widget.time,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

/// A reusable time selector widget for selecting movie showtimes
class TimeSelector extends StatefulWidget {
  final List<String>? times;
  final ValueChanged<String>? onTimeSelected;

  const TimeSelector({
    super.key,
    this.times,
    this.onTimeSelected,
  });

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  String? selectedTime;

  List<String> get defaultTimes => [
    '9:20AM',
    '11:40AM',
    '1:20PM',
    '3:30PM',
    '5:40PM',
    '7:30PM',
    '9:20PM',
  ];

  @override
  Widget build(BuildContext context) {
    final times = widget.times ?? defaultTimes;

    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      children: times.map((time) {
        return TimeChip(
          time: time,
          isSelected: selectedTime == time,
          onTap: () {
            setState(() {
              selectedTime = time;
            });
            widget.onTimeSelected?.call(time);
          },
        );
      }).toList(),
    );
  }
}
