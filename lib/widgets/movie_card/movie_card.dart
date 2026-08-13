import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movie_notes/models/genre.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/widgets/movie_card/back_content.dart';
import 'package:movie_notes/widgets/movie_card/front_content.dart';
import 'package:movie_notes/widgets/pill.dart';

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
          child: Pill(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                  fit: BoxFit.cover,
                ),

                DecoratedBox(
                  decoration: isFront
                      ? const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0, .7, 1],
                            colors: [
                              Colors.transparent,
                              Colors.black,
                              Colors.black,
                            ],
                          ),
                        )
                      : BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: isFront
                      ? MovieCardFront(
                          movie: widget.movie,
                          genres: widget.genres,
                          selectedGenreIds: widget.selectedGenreIds,
                          movieDetails: widget.movieDetails,
                        )
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: MovieCardBack(
                            movie: widget.movie,
                            movieDetails: widget.movieDetails,
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
