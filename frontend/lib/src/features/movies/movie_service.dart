import '../../core/network/api_client.dart';
import 'movie_models.dart';

class MovieService {
  final ApiClient api;
  MovieService(this.api);

  Future<List<Movie>> fetchMovies() async {
    final data = await api.getJson('/api/movies');
    return (data as List).map((e) => Movie.fromJson(e)).toList();
  }

  Future<List<Showtime>> fetchShowtimes({String? movieId}) async {
    final data = await api.getJson('/api/showtimes', query: movieId != null ? {'movieId': movieId} : null);
    return (data as List).map((e) => Showtime.fromJson(e)).toList();
  }
}
