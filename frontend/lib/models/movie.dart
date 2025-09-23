class Movie {
  final String title;
  final String imageUrl;
  final String year;
  final String rating;
  final String synopsis;
  final List<String> cast;
  final List<String> directors;
  final List<String> writers;
  final String runtime;
  final List<String> genres;

  const Movie({
    required this.title,
    required this.imageUrl,
    required this.year,
    required this.rating,
    required this.synopsis,
    required this.cast,
    required this.directors,
    required this.writers,
    required this.runtime,
    required this.genres,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      year: json['year'] as String,
      rating: json['rating'] as String,
      synopsis: json['synopsis'] as String,
      cast: List<String>.from(json['cast'] as List),
      directors: List<String>.from(json['directors'] as List),
      writers: List<String>.from(json['writers'] as List),
      runtime: json['runtime'] as String,
      genres: List<String>.from(json['genres'] as List),
    );
  }
}
