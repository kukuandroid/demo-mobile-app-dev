import 'package:flutter/material.dart';

class CinemaSeatLayout extends StatefulWidget {
  final int rows;
  final int seatsPerRow;
  final Function(List<String>) onSeatsSelected;
  final List<String> selectedSeats;
  final Map<String, bool> unavailableSeats;
  final List<int> vipRows;
  final double seatSize;
  final double seatSpacing;
  final double rowSpacing;
  final double screenHeight;
  final String screenLabel;
  final double regularSeatPrice;
  final double vipSeatPrice;

  const CinemaSeatLayout({
    super.key,
    required this.rows,
    required this.seatsPerRow,
    required this.onSeatsSelected,
    required this.selectedSeats,
    required this.unavailableSeats,
    this.vipRows = const [],
    this.seatSize = 30.0,
    this.seatSpacing = 8.0,
    this.rowSpacing = 16.0,
    this.screenHeight = 40.0,
    this.screenLabel = 'SCREEN',
    this.regularSeatPrice = 15.00,
    this.vipSeatPrice = 25.00,
  });

  @override
  State<CinemaSeatLayout> createState() => _CinemaSeatLayoutState();
}

class _CinemaSeatLayoutState extends State<CinemaSeatLayout> {
  late List<String> _selectedSeats;
  String? _lastTappedSeat;
  double _lastTappedSeatPrice = 0.0;
  OverlayEntry? _seatInfoOverlay;

  @override
  void initState() {
    super.initState();
    _selectedSeats = List.from(widget.selectedSeats);
  }

  @override
  void didUpdateWidget(covariant CinemaSeatLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSeats != oldWidget.selectedSeats) {
      _selectedSeats = List.from(widget.selectedSeats);
    }
  }

  @override
  void dispose() {
    _seatInfoOverlay?.remove();
    super.dispose();
  }

  String getSeatId(int row, int seat) {
    return '${String.fromCharCode(65 + row)}${seat + 1}';
  }

  void _toggleSeat(String seatId) {
    if (widget.unavailableSeats.containsKey(seatId)) {
      return;
    }

    setState(() {
      if (_selectedSeats.contains(seatId)) {
        _selectedSeats.remove(seatId);
        _lastTappedSeat = null;
      } else {
        _selectedSeats.add(seatId);
        _lastTappedSeat = seatId;
        _lastTappedSeatPrice = _getSeatPrice(seatId);
      }
    });

    widget.onSeatsSelected(_selectedSeats);
    _showSeatInfo(seatId);
  }

  double _getSeatPrice(String seatId) {
    int row = seatId.codeUnitAt(0) - 65;
    return widget.vipRows.contains(row) ? widget.vipSeatPrice : widget.regularSeatPrice;
  }

  void _showSeatInfo(String seatId) {
    _seatInfoOverlay?.remove();

    _seatInfoOverlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.4,
        left: 0,
        right: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    seatId,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'RM ${_getSeatPrice(seatId).toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_seatInfoOverlay!);

    Future.delayed(const Duration(seconds: 2), () {
      _seatInfoOverlay?.remove();
      _seatInfoOverlay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildScreen(),
        const SizedBox(height: 24),
        _buildSeatGrid(),
      ],
    );
  }

  Widget _buildScreen() {
    return Container(
      height: widget.screenHeight,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Text(
          widget.screenLabel,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
        ),
      ),
    );
  }

  Widget _buildSeatGrid() {
    return Column(
      children: List.generate(widget.rows, (row) {
        return Padding(
          padding: EdgeInsets.only(bottom: widget.rowSpacing),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.seatsPerRow, (seat) {
              final seatId = getSeatId(row, seat);
              final isSelected = _selectedSeats.contains(seatId);
              final isUnavailable = widget.unavailableSeats.containsKey(seatId);
              final isVip = widget.vipRows.contains(row);

              return GestureDetector(
                onTap: () => _toggleSeat(seatId),
                child: Container(
                  width: widget.seatSize,
                  height: widget.seatSize,
                  margin: EdgeInsets.symmetric(horizontal: widget.seatSpacing / 2),
                  decoration: BoxDecoration(
                    color: _getSeatColor(isSelected, isUnavailable, isVip),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isVip ? Colors.amber.shade700 : Colors.grey.shade700,
                      width: 1.5,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Color _getSeatColor(bool isSelected, bool isUnavailable, bool isVip) {
    if (isUnavailable) {
      return Colors.grey.shade800;
    }
    if (isSelected) {
      return Colors.deepPurple;
    }
    if (isVip) {
      return Colors.amber.shade300;
    }
    return Colors.white;
  }
}
