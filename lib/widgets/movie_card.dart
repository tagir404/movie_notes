import 'package:flutter/material.dart';
import 'package:movie_notes/models/movie.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({required this.movie, super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final posterUrl = 'https://image.tmdb.org/t/p/w500${movie.posterPath}';
    final movieYear = movie.releaseDate.substring(0, 4);

    return Container(
      padding: const .all(12),
      // decoration: const BoxDecoration(
      //   color: Colors.black45,
      //   borderRadius: BorderRadius.all(Radius.circular(12)),
      // ),
      child: Column(
        children: [
          Image.network(posterUrl, fit: .cover),
          Text(movie.overview, style: Theme.of(context).textTheme.bodyLarge),
          Text('Год выхода: $movieYear'),
        ],
      ),
    );
  }
}
