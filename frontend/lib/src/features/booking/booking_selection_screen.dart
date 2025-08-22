import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_client.dart';
import '../movies/movie_models.dart';
import '../movies/movie_list_viewmodel.dart';
import 'booking_models.dart';
import 'booking_selection_service.dart';
import 'booking_screen.dart';

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

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = BookingSelectionService(context.read<ApiClient>());
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

  void _onShowtimeSelected(ShowtimeSlot showtime) {
    setState(() {
      _selectedShowtime = showtime;
    });
  }

  void _proceedToSeatSelection() {
    if (_selectedShowtime == null) return;

    Navigator.pushNamed(
      context,
      BookingScreen.routeName,
      arguments: {
        'movieId': _selectedShowtime!.movieId,
        'showtimeId': _selectedShowtime!.id,
        'hallId': _selectedShowtime!.hallId,
      },
    );
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
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _proceedToSeatSelection,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Select Seats',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}
