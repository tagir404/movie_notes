import 'package:material_ui/material_ui.dart';
import 'package:movie_match/models/genre.dart';
import 'package:movie_match/models/movie.dart';
import 'package:movie_match/models/movie_details.dart';
import 'package:movie_match/utils/formatters.dart';
import '../../l10n/app_localizations.dart';
import 'package:movie_match/widgets/pill.dart';
import 'package:movie_match/widgets/rating_stars.dart';

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
                        : formatRuntime(context, movieDetails!.runtime!),
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
                  Text(movieYear, style: theme.textTheme.bodyLarge?.copyWith()),
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
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : Colors.white,
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
              ' · ${formatCount(context, movieDetails?.voteCount ?? 0)} ${AppLocalizations.of(context)!.ratings_label}',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
