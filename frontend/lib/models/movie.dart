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
}
