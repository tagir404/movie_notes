import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';

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
      style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
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
                  IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                      minimumSize: const Size(44, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.photo_library_outlined, size: 22),
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
