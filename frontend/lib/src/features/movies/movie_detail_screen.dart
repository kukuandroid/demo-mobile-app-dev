import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_client.dart';
import '../booking/booking_screen.dart';
import 'movie_models.dart';
import 'movie_list_viewmodel.dart';
import 'movie_service.dart';

class MovieDetailScreen extends StatefulWidget {
  static const routeName = '/movie';
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late final MovieService _service;
  Movie? _movie;
  List<Showtime> _showtimes = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = MovieService(context.read<ApiClient>());
    // Defer to ensure ModalRoute is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _load();
    });
  }

  Future<void> _load() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
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
      final listVm = context.read<MovieListViewModel>();
      // Ensure movies are loaded
      if (listVm.movies.isEmpty) {
        await listVm.load();
      }
      _movie = listVm.movies.firstWhere((m) => m.id == movieId);
      // Prefer already-fetched showtimes, else fetch
      _showtimes = listVm.showtimesByMovie[movieId] ?? await _service.fetchShowtimes(movieId: movieId);
    } catch (e) {
      _error = e.toString();
    } finally {
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(_movie?.title ?? 'Movie Details')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _movie == null
                  ? const Center(child: Text('Movie not found'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: AspectRatio(
                              aspectRatio: 16/9,
                              child: Image.network(_movie!.posterUrl, fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(_movie!.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: [
                              Chip(label: Text(_movie!.rating)),
                              Chip(label: Text('${_movie!.durationMins} min')),
                              ..._movie!.genre.map((g) => Chip(label: Text(g))),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text('Synopsis', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text(_movie!.synopsis),
                          const SizedBox(height: 12),
                          if (_movie!.cast.isNotEmpty) ...[
                            Text('Cast', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(_movie!.cast.join(', ')),
                            const SizedBox(height: 12),
                          ],
                          if (_movie!.director.isNotEmpty) ...[
                            Text('Director', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text(_movie!.director),
                            const SizedBox(height: 12),
                          ],
                          const Divider(height: 24),
                          Text('Showtimes', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          if (_showtimes.isEmpty)
                            const Text('No showtimes available')
                          else
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _showtimes.map((s) => ActionChip(
                                label: Text(s.startTime),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    BookingScreen.routeName,
                                    arguments: {
                                      'movieId': s.movieId,
                                      'showtimeId': s.id,
                                      'hallId': s.hallId,
                                    },
                                  );
                                },
                              )).toList(),
                            ),
                        ],
                      ),
                    ),
    );
  }
}
