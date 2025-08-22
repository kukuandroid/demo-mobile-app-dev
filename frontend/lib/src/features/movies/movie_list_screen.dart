import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'movie_list_viewmodel.dart';
import 'movie_detail_screen.dart';
import 'widgets/movie_card.dart';

class MovieListScreen extends StatefulWidget {
  static const routeName = '/';
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<MovieListViewModel>().load());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MovieListViewModel>();
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(32),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🎬 Welcome, User!',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your next movie experience.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimary.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.error != null
              ? Center(child: Text('Error: ${vm.error}'))
              : GridView.builder(
                  padding: const EdgeInsets.only(
                      top: 18, left: 16, right: 16, bottom: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 16,
                  ),
                  itemCount: vm.movies.length,
                  itemBuilder: (ctx, i) {
                    final m = vm.movies[i];
                    final sts = vm.showtimesByMovie[m.id] ?? const [];
                    return MovieCard(
                      movie: m,
                      enabled: sts.isNotEmpty,
                      onTap: sts.isEmpty
                          ? null
                          : () {
                              Navigator.pushNamed(
                                context,
                                MovieDetailScreen.routeName,
                                arguments: {
                                  'movieId': m.id,
                                },
                              );
                            },
                    );
                  },
                ),
    );
  }
}
