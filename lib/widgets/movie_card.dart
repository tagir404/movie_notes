import 'package:flutter/material.dart';
import 'package:movie_notes/models/movie.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({required this.movie, required this.genreNames, super.key});

  final Movie movie;
  final List<String> genreNames;

  @override
  Widget build(BuildContext context) {
    final posterUrl = 'https://image.tmdb.org/t/p/w500${movie.posterPath}';
    final movieYear = movie.releaseDate.substring(0, 4);
    final theme = Theme.of(context);

    return Container(
      padding: const .all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: const .all(.circular(12)),
      ),
      child: DefaultTextStyle(
        style: theme.textTheme.bodyMedium!.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
        child: IconTheme(
          data: IconThemeData(color: theme.colorScheme.onPrimary),
          child: Column(
            children: [
              Image.network(
                posterUrl,
                fit: .cover,
                height: MediaQuery.sizeOf(context).height * 0.5,
              ),
              const SizedBox(height: 12),
              Text(
                'Жанры: ${genreNames.join(', ')}',
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
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
                  const Icon(Icons.access_time),
                  Text('Год выхода: $movieYear'),
                ],
              ),
              const SizedBox(height: 4),
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
    );
  }
}
