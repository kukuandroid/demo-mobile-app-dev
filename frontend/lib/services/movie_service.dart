import '../models/movie.dart';
import '../utils/http_service.dart';

class MovieService {
  static const String _moviesEndpoint = 'movies';

  static Future<List<Movie>> getMovies() async {
    try {
      final response = await HttpService.get(_moviesEndpoint);

      // The HttpService already extracts the 'data' field, so we get:
      // { movies: [...] } structure directly
      if (response is Map && response.containsKey('movies')) {
        // Handle { movies: [...] } structure
        final moviesData = response['movies'] as List;
        return moviesData.map((movieData) => Movie.fromJson(movieData)).toList();
      } else if (response is List) {
        // Handle direct array response
        return response.map((movieData) => Movie.fromJson(movieData)).toList();
      }

      throw Exception('Invalid response format: $response');
    } catch (e) {
      throw Exception('Failed to load movies: $e');
    }
  }
}
