import 'package:flutter/material.dart';
import 'package:movie_notes/models/movie.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({required this.movie, super.key});

  final Movie movie;

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
        style: const TextStyle(color: Colors.white),
        child: IconTheme(
          data: IconThemeData(color: theme.colorScheme.onPrimary),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Image.network(posterUrl, fit: .cover),
              Text(movie.overview, maxLines: 4, overflow: .ellipsis),
              Row(
                spacing: 4,
                children: [
                  const Icon(Icons.access_time),
                  Text('Год выхода: $movieYear'),
                ],
              ),
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
