import 'dart:math';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:movie_notes/models/genre.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/utils/formatters.dart';
import 'package:movie_notes/widgets/pill.dart';
import 'package:movie_notes/widgets/rating_stars.dart';

class MovieCard extends StatefulWidget {
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
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_controller.value == 0) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _flip,
    child: AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final angle = _controller.value * pi;
        final isFront = angle < pi / 2;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, .001)
            ..rotateY(angle),
          child: isFront
              ? _MovieCardSurface(
                  movie: widget.movie,
                  child: _FrontContent(
                    movie: widget.movie,
                    genres: widget.genres,
                    selectedGenreIds: widget.selectedGenreIds,
                    movieDetails: widget.movieDetails,
                  ),
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: _MovieCardSurface(
                    isBack: true,
                    movie: widget.movie,
                    child: _BackContent(
                      movie: widget.movie,
                      movieDetails: widget.movieDetails,
                    ),
                  ),
                ),
        );
      },
    ),
  );
}

class _MovieCardSurface extends StatelessWidget {
  const _MovieCardSurface({
    required this.movie,
    required this.child,
    this.isBack = false,
  });

  final Movie movie;
  final Widget child;
  final bool isBack;

  @override
  Widget build(BuildContext context) {
    final posterUrl = 'https://image.tmdb.org/t/p/w500${movie.posterPath}';

    return ClipRRect(
      borderRadius: .circular(12),
      child: Stack(
        fit: .expand,
        children: [
          Image.network(posterUrl, fit: .cover),

          Container(
            decoration: isBack
                ? const BoxDecoration(color: Color.fromARGB(220, 0, 0, 0))
                : const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, .7, 1],
                      colors: [Colors.transparent, Colors.black, Colors.black],
                    ),
                  ),
          ),

          Padding(padding: const .all(16), child: child),
        ],
      ),
    );
  }
}

class _FrontContent extends StatelessWidget {
  const _FrontContent({
    required this.movie,
    required this.genres,
    required this.selectedGenreIds,
    required this.movieDetails,
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
      mainAxisAlignment: .end,
      crossAxisAlignment: .start,
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Pill(
              padding: const .symmetric(vertical: 4, horizontal: 12),
              borderRadius: .circular(20),
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
              padding: const .symmetric(vertical: 4, horizontal: 12),
              borderRadius: .circular(20),
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
                  : Colors.white.withValues(alpha: .15),
              borderRadius: .circular(20),
              child: Padding(
                padding: const .symmetric(vertical: 4, horizontal: 8),
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

class _BackContent extends StatefulWidget {
  const _BackContent({required this.movie, required this.movieDetails});

  final Movie movie;
  final MovieDetails? movieDetails;

  @override
  State<_BackContent> createState() => _BackContentState();
}

class _BackContentState extends State<_BackContent> {
  final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTextStyle(
      style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .end,
        children: [
          Text(
            widget.movie.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
            ),
          ),

          if ((widget.movieDetails?.tagline ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.movieDetails!.tagline!,
              style: const TextStyle(fontStyle: .italic),
            ),
          ],

          const SizedBox(height: 12),

          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              controller: _controller,
              child: SingleChildScrollView(
                controller: _controller,
                padding: const .only(right: 8),
                child: Text(
                  widget.movie.overview.isEmpty
                      ? 'Описание отсутствует.'
                      : widget.movie.overview,
                  textAlign: .justify,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          if (widget.movieDetails?.originCountry != null &&
              widget.movieDetails!.originCountry!.isNotEmpty)
            Row(
              spacing: 8,
              children: [
                ...widget.movieDetails!.originCountry!.map(
                  (countryCode) => CountryFlag.fromCountryCode(
                    countryCode,
                    theme: const ImageTheme(
                      width: 30,
                      height: 20,
                      shape: RoundedRectangle(4),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
