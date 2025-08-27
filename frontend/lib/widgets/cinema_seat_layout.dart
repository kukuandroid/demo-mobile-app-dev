import 'package:flutter/material.dart';
import 'seat.dart';

class CinemaSeatLayout extends StatefulWidget {
  final int rows;
  final int seatsPerRow;
  final List<int> vipRows;
  final List<String> selectedSeats;
  final ValueChanged<List<String>> onSeatsSelected;
  final Map<String, bool>? unavailableSeats;
  final double seatSize;
  final double seatSpacing;
  final double rowSpacing;
  final double screenHeight;
  final String screenLabel;

  const CinemaSeatLayout({
    super.key,
    this.rows = 10,
    this.seatsPerRow = 10,
    this.vipRows = const [0, 1],
    required this.selectedSeats,
    required this.onSeatsSelected,
    this.unavailableSeats,
    this.seatSize = 28.0,
    this.seatSpacing = 8.0,
    this.rowSpacing = 16.0,
    this.screenHeight = 60.0,
    this.screenLabel = 'SCREEN',
  });

  @override
  State<CinemaSeatLayout> createState() => _CinemaSeatLayoutState();
}

class _CinemaSeatLayoutState extends State<CinemaSeatLayout> {
  late List<String> _selectedSeats;

  @override
  void initState() {
    super.initState();
    _selectedSeats = List.from(widget.selectedSeats);
  }

  @override
  void didUpdateWidget(CinemaSeatLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedSeats != widget.selectedSeats) {
      setState(() {
        _selectedSeats = List.from(widget.selectedSeats);
      });
    }
  }

  void _onSeatTapped(String seatLabel) {
    setState(() {
      if (_selectedSeats.contains(seatLabel)) {
        _selectedSeats.remove(seatLabel);
      } else {
        _selectedSeats.add(seatLabel);
      }
      widget.onSeatsSelected(_selectedSeats);
    });
  }

  bool _isSeatUnavailable(String seatLabel) {
    return widget.unavailableSeats?.containsKey(seatLabel) ?? false;
  }

  SeatStatus _getSeatStatus(int row, int seat) {
    final seatLabel = '${String.fromCharCode(65 + row)}${seat + 1}';

    if (_isSeatUnavailable(seatLabel)) {
      return SeatStatus.unavailable;
    }

    if (_selectedSeats.contains(seatLabel)) {
      return SeatStatus.selected;
    }

    if (widget.vipRows.contains(row)) {
      return SeatStatus.vip;
    }

    return SeatStatus.available;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth - 48.0;
    final seatWidth =
        (availableWidth / widget.seatsPerRow) - widget.seatSpacing;
    final seatSize = seatWidth < widget.seatSize ? seatWidth : widget.seatSize;

    return Column(
      children: [
        // Screen
        Container(
          width: double.infinity,
          height: widget.screenHeight,
          margin: const EdgeInsets.only(bottom: 24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey.shade800,
                Colors.grey.shade700,
                Colors.grey.shade800,
              ],
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: Text(
              widget.screenLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
          ),
        ),

        // Seating layout
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: widget.rows,
            itemBuilder: (context, rowIndex) {
              return Padding(
                padding: EdgeInsets.only(bottom: widget.rowSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Row label (A, B, C, ...)
                    SizedBox(
                      width: 24.0,
                      child: Text(
                        String.fromCharCode(65 + rowIndex),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),

                    // Seats in the row
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(widget.seatsPerRow, (
                          seatIndex,
                        ) {
                          final seatLabel =
                              '${String.fromCharCode(65 + rowIndex)}${seatIndex + 1}';
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: widget.seatSpacing / 2,
                            ),
                            child: Seat(
                              label: '${seatIndex + 1}',
                              status: _getSeatStatus(rowIndex, seatIndex),
                              onTap: () => _onSeatTapped(seatLabel),
                              size: seatSize,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
