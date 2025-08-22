class Movie {
  final String id;
  final String title;
  final List<String> genre;
  final int durationMins;
  final String rating;
  final String posterUrl;
  final String synopsis;
  final List<String> cast;
  final String director;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.durationMins,
    required this.rating,
    required this.posterUrl,
    required this.synopsis,
    required this.cast,
    required this.director,
  });

  factory Movie.fromJson(Map<String, dynamic> j) => Movie(
        id: j['id'],
        title: j['title'],
        genre: (j['genre'] as List).cast<String>(),
        durationMins: j['durationMins'],
        rating: j['rating'],
        posterUrl: j['posterUrl'],
        synopsis: j['synopsis'] ?? '',
        cast: (j['cast'] as List?)?.cast<String>() ?? const [],
        director: j['director'] ?? '',
      );
}

class Showtime {
  final String id;
  final String movieId;
  final String hallId;
  final String startTime;
  final double price;
  Showtime({required this.id, required this.movieId, required this.hallId, required this.startTime, required this.price});
  factory Showtime.fromJson(Map<String, dynamic> j) => Showtime(
        id: j['id'],
        movieId: j['movieId'],
        hallId: j['hallId'],
        startTime: j['startTime'],
        price: (j['price'] as num).toDouble(),
      );
}
