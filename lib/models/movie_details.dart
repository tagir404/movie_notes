import 'package:movie_match/models/genre.dart';

class MovieDetails {
  final int id;
  final String title;
  final String overview;
  final List<String>? originCountry;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final int? runtime;
  final double voteAverage;
  final int voteCount;
  final List<Genre> genres;
  final String? tagline;
  final String? homepage;

  MovieDetails({
    required this.id,
    required this.title,
    required this.overview,
    required this.originCountry,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.runtime,
    required this.voteAverage,
    required this.voteCount,
    required this.genres,
    required this.tagline,
    required this.homepage,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) => MovieDetails(
    id: json['id'],
    title: json['title'] ?? json['name'],
    overview: json['overview'],
    originCountry: (json['origin_country'] as List?)?.cast<String>(),
    posterPath: json['poster_path'],
    backdropPath: json['backdrop_path'],
    releaseDate: json['release_date'] ?? json['first_air_date'],
    runtime: parseRuntime(json),
    voteAverage: (json['vote_average'] as num).toDouble(),
    voteCount: json['vote_count'],
    genres: (json['genres'] as List)
        .map((genre) => Genre.fromJson(genre))
        .toList(),
    tagline: json['tagline'],
    homepage: json['homepage'],
  );
}

int? parseRuntime(Map<String, dynamic> json) {
  final runtime = json['runtime'];

  if (runtime is num) {
    return runtime.toInt();
  }

  final episodeRuntime = json['episode_run_time'];

  if (episodeRuntime is List && episodeRuntime.isNotEmpty) {
    return (episodeRuntime.first as num).toInt();
  }

  final lastEpisodeRuntime = json['last_episode_to_air']?['runtime'];

  if (lastEpisodeRuntime is num) {
    return lastEpisodeRuntime.toInt();
  }

  return null;
}
