import 'package:flutter/material.dart';
import 'package:movie_notes/models/genre.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/utils/formatters.dart';
import 'package:movie_notes/widgets/pill.dart';
import 'package:movie_notes/widgets/rating_stars.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({
    required this.movie,
    required this.genres,
    required this.selectedGenreIds,
    required this.movieDetails,
    super.key,
  });

  final Movie movie;
  final List<Genre> genres;
  final List<int> selectedGenreIds;
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
                          padding: const .symmetric(
                            vertical: 4,
                            horizontal: 12,
                          ),
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
                          padding: const .symmetric(
                            vertical: 4,
                            horizontal: 12,
                          ),
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
                        ...genres.map((genre) {
                          final isSelected = selectedGenreIds.contains(
                            genre.id,
                          );

                          return Material(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.white.withValues(alpha: 0.15),
                            borderRadius: .circular(20),
                            child: Padding(
                              padding: const .symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              child: Text(
                                genre.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
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
                    const SizedBox(height: 24),
                    Row(
                      spacing: 4,
                      children: [
                        RatingStars(rating: movie.voteAverage),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '· ${formatCount(movieDetails?.voteCount ?? 0)} оценок',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
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
