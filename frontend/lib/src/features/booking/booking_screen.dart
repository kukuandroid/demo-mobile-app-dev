import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'booking_viewmodel.dart';
import 'seat_models.dart';
import '../fnb/fnb_screen.dart';

class BookingScreen extends StatefulWidget {
  static const routeName = '/booking';
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      context.read<BookingViewModel>().init(
            movieId: args['movieId'],
            hallId: args['hallId'],
            showtimeId: args['showtimeId'],
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingViewModel>();
    final seatMap = vm.seatMap;
    return Scaffold(
      appBar: AppBar(title: const Text('Select Seats')),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : seatMap == null
              ? Center(child: Text(vm.error ?? 'No data'))
              : Column(
                  children: [
                    Expanded(child: _SeatGrid(seatMap: seatMap, onTap: vm.toggleSeat, selected: vm.selected)),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Text('Selected: ${vm.selected.join(', ')}'),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: vm.selected.isEmpty ? null : () async {
                              final ok = await vm.holdSelected();
                              if (!mounted) return;
                              if (ok) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seats held for 2 minutes')));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error ?? 'Hold failed')));
                              }
                            },
                            child: const Text('Hold'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: vm.currentReservation == null ? null : () async {
                              final ok = await vm.confirm();
                              if (!mounted) return;
                              if (ok) {
                                Navigator.pushNamed(context, FnbScreen.routeName);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error ?? 'Confirm failed')));
                              }
                            },
                            child: const Text('Confirm'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: vm.currentReservation == null ? null : vm.release,
                            child: const Text('Release'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
    );
  }
}

class _SeatGrid extends StatelessWidget {
  final SeatMap seatMap;
  final void Function(String) onTap;
  final Set<String> selected;
  const _SeatGrid({required this.seatMap, required this.onTap, required this.selected});

  @override
  Widget build(BuildContext context) {
    final rows = seatMap.rows;
    final cols = seatMap.cols;
    return ListView.builder(
      itemCount: rows,
      itemBuilder: (ctx, r) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int c = 0; c < cols; c++) _seatButton(r, c, context),
          ],
        );
      },
    );
  }

  Widget _seatButton(int r, int c, BuildContext context) {
    final id = String.fromCharCode('A'.codeUnitAt(0) + r) + (c + 1).toString();
    final info = seatMap.seats[id];
    Color bg;
    if (selected.contains(id)) {
      bg = Colors.amber;
    } else if (info?.status == SeatStatus.booked) {
      bg = Colors.grey;
    } else if (info?.status == SeatStatus.held) {
      bg = Colors.blueGrey;
    } else {
      bg = Colors.green;
    }
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () => onTap(id),
        child: Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
          child: Text((c + 1).toString(), style: const TextStyle(fontSize: 10, color: Colors.white)),
        ),
      ),
    );
  }
}
