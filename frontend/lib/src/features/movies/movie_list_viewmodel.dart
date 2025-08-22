import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import 'movie_models.dart';
import 'movie_service.dart';

class MovieListViewModel extends ChangeNotifier {
  final MovieService _service;
  MovieListViewModel(ApiClient api) : _service = MovieService(api);

  List<Movie> movies = [];
  Map<String, List<Showtime>> showtimesByMovie = {};
  bool loading = false;
  String? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      movies = await _service.fetchMovies();
      for (final m in movies) {
        final sts = await _service.fetchShowtimes(movieId: m.id);
        showtimesByMovie[m.id] = sts;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
