import 'package:flutter/material.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/utils/formatters.dart';
import 'package:movie_notes/widgets/pill.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    required this.movie,
    required this.genreNames,
    required this.movieDetails,
    super.key,
  });

  final Movie movie;
  final List<String> genreNames;
  final MovieDetails? movieDetails;

  @override
  Widget build(BuildContext context) {
    final posterUrl = 'https://image.tmdb.org/t/p/w500${movie.posterPath}';
    final movieYear = movie.releaseDate.substring(0, 4);
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: .circular(12),
      child: Stack(
        fit: .expand,
        children: [
          Image.network(posterUrl, fit: .cover),

          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: .topCenter,
                end: .bottomCenter,
                stops: [0, 0.7, 1.0],
                colors: [Colors.transparent, Colors.black, Colors.black],
              ),
            ),
          ),

          Padding(
            padding: const .all(12),
            child: DefaultTextStyle(
              style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
              child: IconTheme(
                data: const IconThemeData(color: Colors.white),
                child: Column(
                  mainAxisAlignment: .end,
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Pill(
                          borderRadius: .circular(20),
                          child: Row(
                            spacing: 6,
                            children: [
                              const Icon(Icons.access_time, size: 18),
                              Text(
                                movieDetails == null ||
                                        movieDetails!.runtime == null
                                    ? '...'
                                    : formatRuntime(movieDetails!.runtime!),
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Pill(
                          borderRadius: .circular(20),
                          child: Row(
                            spacing: 6,
                            children: [
                              const Icon(Icons.calendar_today, size: 18),
                              Text(
                                '$movieYear г',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...genreNames.map(
                          (genre) => Material(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: .circular(20),
                            child: Padding(
                              padding: const .symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: Text(
                                genre,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.title,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.overview,
                      maxLines: 4,
                      overflow: .ellipsis,
                      textAlign: .justify,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      spacing: 4,
                      children: [
                        const Icon(Icons.star),
                        Text('Оценка: ${movie.voteAverage.toStringAsFixed(1)}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
