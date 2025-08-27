import 'package:flutter/material.dart';

/// A reusable date selector widget for selecting dates in a horizontal scroll
class DateSelector extends StatefulWidget {
  final List<Map<String, String>>? dates;
  final ValueChanged<Map<String, String>>? onDateSelected;

  const DateSelector({
    super.key,
    this.dates,
    this.onDateSelected,
  });

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int selectedIndex = 0;

  List<Map<String, String>> get defaultDates => [
    {'day': 'Wed', 'date': '17'},
    {'day': 'Thur', 'date': '18'},
    {'day': 'Fri', 'date': '19'},
    {'day': 'Sat', 'date': '20'},
    {'day': 'Sun', 'date': '21'},
    {'day': 'Mon', 'date': '22'},
    {'day': 'Tue', 'date': '23'},
  ];

  @override
  Widget build(BuildContext context) {
    final dates = widget.dates ?? defaultDates;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dates.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onDateSelected?.call(day);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: isSelected ? Colors.grey[700] : Colors.grey[850],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Text(
                    day['day']!,
                    style: const TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                  Text(
                    day['date']!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
