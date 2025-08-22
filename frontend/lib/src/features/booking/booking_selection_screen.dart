import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_client.dart';
import '../movies/movie_models.dart';
import '../movies/movie_list_viewmodel.dart';
import 'booking_models.dart';
import 'booking_selection_service.dart';
import 'booking_service.dart';
import 'seat_models.dart';
import '../fnb/fnb_screen.dart';

class BookingSelectionScreen extends StatefulWidget {
  static const routeName = '/booking-selection';
  const BookingSelectionScreen({super.key});

  @override
  State<BookingSelectionScreen> createState() => _BookingSelectionScreenState();
}

class _BookingSelectionScreenState extends State<BookingSelectionScreen> {
  late final BookingSelectionService _service;

  Movie? _movie;
  List<Location> _locations = [];
  List<Cinema> _cinemas = [];
  List<String> _availableDates = [];
  List<ShowtimeSlot> _showtimes = [];

  Location? _selectedLocation;
  Cinema? _selectedCinema;
  String? _selectedDate;
  ShowtimeSlot? _selectedShowtime;
  
  // Seat selection state
  SeatMap? _seatMap;
  final Set<String> _selectedSeats = {};
  bool _loadingSeats = false;
  late final BookingService _bookingService;

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = BookingSelectionService(context.read<ApiClient>());
    _bookingService = BookingService(context.read<ApiClient>());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final movieId = args?['movieId'] as String?;

    if (movieId == null) {
      setState(() {
        _loading = false;
        _error = 'Missing movieId';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      // Get movie info
      final listVm = context.read<MovieListViewModel>();
      if (listVm.movies.isEmpty) {
        await listVm.load();
      }
      _movie = listVm.movies.firstWhere((m) => m.id == movieId);

      // Load locations
      _locations = await _service.fetchLocations();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _onLocationSelected(Location location) async {
    setState(() {
      _selectedLocation = location;
      _selectedCinema = null;
      _selectedDate = null;
      _selectedShowtime = null;
      _cinemas = [];
      _availableDates = [];
      _showtimes = [];
    });

    try {
      _cinemas = await _service.fetchCinemas(locationId: location.id);
    } catch (e) {
      _error = e.toString();
    }

    if (mounted) setState(() {});
  }

  Future<void> _onCinemaSelected(Cinema cinema) async {
    setState(() {
      _selectedCinema = cinema;
      _selectedDate = null;
      _selectedShowtime = null;
      _availableDates = [];
      _showtimes = [];
    });

    try {
      _availableDates = await _service.getAvailableDates(
        movieId: _movie!.id,
        cinemaId: cinema.id,
      );
    } catch (e) {
      _error = e.toString();
    }

    if (mounted) setState(() {});
  }

  Future<void> _onDateSelected(String date) async {
    setState(() {
      _selectedDate = date;
      _selectedShowtime = null;
      _showtimes = [];
    });

    try {
      _showtimes = await _service.fetchShowtimes(
        movieId: _movie!.id,
        cinemaId: _selectedCinema!.id,
        date: date,
      );
    } catch (e) {
      _error = e.toString();
    }

    if (mounted) setState(() {});
  }

  void _onShowtimeSelected(ShowtimeSlot showtime) async {
    setState(() {
      _selectedShowtime = showtime;
      _selectedSeats.clear();
      _seatMap = null;
      _loadingSeats = true;
    });

    try {
      _seatMap = await _bookingService.fetchSeatMap(showtime.hallId, showtime.id);
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _loadingSeats = false;
        });
      }
    }
  }

  void _toggleSeat(String seatId) {
    if (_seatMap == null) return;
    final status = _seatMap!.seats[seatId]?.status;
    if (status != SeatStatus.available && !_selectedSeats.contains(seatId)) return;
    
    setState(() {
      if (_selectedSeats.contains(seatId)) {
        _selectedSeats.remove(seatId);
      } else {
        _selectedSeats.add(seatId);
      }
    });
    
    // Debug print to verify seat selection
    print('Selected seats: $_selectedSeats');
    print('Subtotal: ${_subtotal}');
  }

  double get _subtotal {
    if (_selectedShowtime == null) return 0.0;
    return _selectedSeats.length * _selectedShowtime!.price;
  }

  void _proceedToFnB() {
    if (_selectedSeats.isEmpty) return;
    Navigator.pushNamed(context, FnbScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Booking'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Where would you like to see the move ? kindly select as approriate',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Location Selection
                      Text('Select Location',
                          style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _locations
                            .map((location) => ChoiceChip(
                                  label: Text(location.name),
                                  selected:
                                      _selectedLocation?.id == location.id,
                                  onSelected: (_) =>
                                      _onLocationSelected(location),
                                ))
                            .toList(),
                      ),

                      if (_selectedLocation != null) ...[
                        const SizedBox(height: 24),
                        Text('Select Cinema',
                            style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        ..._cinemas.map((cinema) => Card(
                              child: ListTile(
                                title: Text(cinema.name),
                                subtitle: Text(cinema.address),
                                selected: _selectedCinema?.id == cinema.id,
                                onTap: () => _onCinemaSelected(cinema),
                              ),
                            )),
                      ],

                      if (_selectedCinema != null) ...[
                        const SizedBox(height: 24),
                        Text('Select Date', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _availableDates
                              .map((date) => ChoiceChip(
                                    label: Text(date),
                                    selected: _selectedDate == date,
                                    onSelected: (_) => _onDateSelected(date),
                                  ))
                              .toList(),
                        ),
                      ],

                      if (_selectedDate != null) ...[
                        const SizedBox(height: 24),
                        Text('Available Time',
                            style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _showtimes
                              .map((showtime) => ChoiceChip(
                                    label: Text(
                                        '${showtime.startTime} - RM${showtime.price.toStringAsFixed(2)}'),
                                    selected:
                                        _selectedShowtime?.id == showtime.id,
                                    onSelected: (_) =>
                                        _onShowtimeSelected(showtime),
                                  ))
                              .toList(),
                        ),
                      ],

                      if (_selectedShowtime != null) ...[
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Select Your Seats',
                                style: theme.textTheme.titleLarge),
                            Text('${_selectedSeats.length} selected',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_loadingSeats)
                          const Center(child: CircularProgressIndicator())
                        else if (_seatMap != null)
                          _buildSeatLayout(theme),
                        const SizedBox(height: 16),
                        _buildSubtotalSection(theme),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildSeatLayout(ThemeData theme) {
    if (_seatMap == null) return const SizedBox();
    
    return Column(
      children: [
        // Screen indicator
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'SCREEN',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Seat grid
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: _seatMap!.rows,
            itemBuilder: (ctx, r) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Row label
                    SizedBox(
                      width: 20,
                      child: Text(
                        String.fromCharCode('A'.codeUnitAt(0) + r),
                        style: theme.textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Seats
                    for (int c = 0; c < _seatMap!.cols; c++)
                      _buildSeatButton(r, c, theme),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLegendItem('Available', Colors.green, theme),
            _buildLegendItem('Selected', Colors.amber, theme),
            _buildLegendItem('Booked', Colors.grey, theme),
            _buildLegendItem('Held', Colors.blueGrey, theme),
          ],
        ),
      ],
    );
  }

  Widget _buildSeatButton(int r, int c, ThemeData theme) {
    final id = String.fromCharCode('A'.codeUnitAt(0) + r) + (c + 1).toString();
    final info = _seatMap!.seats[id];
    Color bg;
    
    if (_selectedSeats.contains(id)) {
      bg = Colors.amber;
    } else if (info?.status == SeatStatus.booked) {
      bg = Colors.grey;
    } else if (info?.status == SeatStatus.held) {
      bg = Colors.blueGrey;
    } else {
      bg = Colors.green;
    }
    
    return Padding(
      padding: const EdgeInsets.all(1),
      child: GestureDetector(
        onTap: () => _toggleSeat(id),
        child: Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            (c + 1).toString(),
            style: const TextStyle(
              fontSize: 10,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildSubtotalSection(ThemeData theme) {
    if (_selectedSeats.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Select seats to see pricing and continue',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Seats:',
                style: theme.textTheme.titleMedium,
              ),
              Text(
                _selectedSeats.join(', '),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal:',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'RM${_subtotal.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _proceedToFnB,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Continue to F&B (${_selectedSeats.length} seat${_selectedSeats.length == 1 ? '' : 's'})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
