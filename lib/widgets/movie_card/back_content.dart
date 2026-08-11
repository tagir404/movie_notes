import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/widgets/movie_card/movie_videos_dialog.dart';
import 'package:movie_notes/widgets/pill.dart';

class MovieCardBack extends StatefulWidget {
  const MovieCardBack({
    required this.movie,
    required this.movieDetails,
    super.key,
  });

  final Movie movie;
  final MovieDetails? movieDetails;

  @override
  State<MovieCardBack> createState() => _MovieCardBackState();
}

class _MovieCardBackState extends State<MovieCardBack> {
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
      style: theme.textTheme.bodyLarge!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(widget.movie.title, style: theme.textTheme.headlineMedium),

          if ((widget.movieDetails?.tagline ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.movieDetails!.tagline!,
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
          ],

          const SizedBox(height: 12),

          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              controller: _controller,
              child: SingleChildScrollView(
                controller: _controller,
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  widget.movie.overview.isEmpty
                      ? 'Описание отсутствует.'
                      : widget.movie.overview,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
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
              Row(
                children: [
                  InkWell(
                    onTap: () => showDialog<void>(
                      context: context,
                      builder: (context) =>
                          MovieVideosDialog(movie: widget.movie),
                    ),
                    child: Pill(
                      color: Theme.of(context).colorScheme.primary,
                      padding: const .all(12),
                      shape: const CircleBorder(),
                      child: Icon(
                        Icons.videocam,
                        size: 22,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
