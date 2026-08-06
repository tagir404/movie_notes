import 'package:movie_notes/enums/media_content_type.dart';

class Movie {
  const Movie({
    required this.id,
    required this.type,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.genreIds,
  });

  final int id;
  final MediaContentType type;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final double voteAverage;
  final List<int> genreIds;

  factory Movie.fromJson(Map<String, dynamic> json, MediaContentType type) =>
      Movie(
        id: json['id'],
        type: type,
        title: json['title'] ?? json['name'],
        overview: json['overview'],
        posterPath: json['poster_path'],
        backdropPath: json['backdrop_path'],
        releaseDate: json['release_date'] ?? json['first_air_date'],
        voteAverage: (json['vote_average'] as num).toDouble(),
        genreIds: List<int>.from(json['genre_ids']),
      );
}
