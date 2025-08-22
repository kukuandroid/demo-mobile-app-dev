import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../booking/booking_selection_screen.dart';
import 'movie_models.dart';
import 'movie_list_viewmodel.dart';

class MovieDetailScreen extends StatefulWidget {
  static const routeName = '/movie';
  const MovieDetailScreen({super.key});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen>
    with SingleTickerProviderStateMixin {
  Movie? _movie;
  bool _loading = true;
  String? _error;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      final listVm = context.read<MovieListViewModel>();
      if (listVm.movies.isEmpty) {
        await listVm.load();
      }
      _movie = listVm.movies.firstWhere((m) => m.id == movieId);
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildDetailsTab(ThemeData theme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }
    if (_movie == null) {
      return const Center(child: Text('Movie not found'));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(_movie!.posterUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16),
          Text(_movie!.title,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
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
          // TabBar moved here below genre
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Details', icon: Icon(Icons.info_outline)),
              Tab(text: 'Review', icon: Icon(Icons.rate_review_outlined)),
            ],
          ),
          const SizedBox(height: 12),
          // The content for the selected tab
          SizedBox(
            height:
                800, // arbitrary large height for demonstration; adjust as needed
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDetailsTabContent(theme),
                _buildReviewTab(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsTabContent(ThemeData theme) {
    // All details except the TabBar, for the "Details" tab content
    if (_movie == null) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Synopsis',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(_movie!.synopsis),
        const SizedBox(height: 12),
        if (_movie!.cast.isNotEmpty) ...[
          Text('Cast',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(_movie!.cast.join(', ')),
          const SizedBox(height: 12),
        ],
        if (_movie!.director.isNotEmpty) ...[
          Text('Director',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(_movie!.director),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                BookingSelectionScreen.routeName,
                arguments: {
                  'movieId': _movie!.id,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Book Ticket',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewTab(ThemeData theme) {
    // Placeholder for reviews
    return const Center(
      child: Text('No reviews yet.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Only the poster, genre, title, and TabBar -- details are inside the tab
    return Scaffold(
      appBar: AppBar(
        title: Text(_movie?.title ?? 'Movie Details'),
      ),
      body: _buildDetailsTab(theme),
    );
  }
}
