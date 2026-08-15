import 'package:movie_notes/models/movie.dart';

class MediaPageResult {
  const MediaPageResult({required this.movies, required this.totalPages});

  final List<Movie> movies;
  final int totalPages;
}
