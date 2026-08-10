import 'package:flutter/material.dart';
import 'package:movie_notes/models/genre.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/utils/formatters.dart';
import 'package:movie_notes/widgets/pill.dart';
import 'package:movie_notes/widgets/rating_stars.dart';

class MovieCardFront extends StatelessWidget {
  const MovieCardFront({
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
    final theme = Theme.of(context);
    final movieYear = movie.releaseDate.substring(0, 4);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Pill(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    movieDetails?.runtime == null
                        ? '...'
                        : formatRuntime(movieDetails!.runtime!),
                    style: theme.textTheme.bodyLarge?.copyWith(),
                  ),
                ],
              ),
            ),
            Pill(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '$movieYear г',
                    style: theme.textTheme.bodyLarge?.copyWith(),
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
          children: genres.map((genre) {
            final isSelected = selectedGenreIds.contains(genre.id);

            return Material(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.white.withAlpha(38),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  genre.name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          movie.title,
          style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            RatingStars(rating: movie.voteAverage),
            const SizedBox(width: 8),
            Text(
              movie.voteAverage.toStringAsFixed(1),
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            Text(
              ' · ${formatCount(movieDetails?.voteCount ?? 0)} оценок',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
