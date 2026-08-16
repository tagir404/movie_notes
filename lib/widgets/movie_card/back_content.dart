import 'package:country_flags/country_flags.dart';
import 'package:material_ui/material_ui.dart';
import 'package:movie_match/models/movie.dart';
import 'package:movie_match/models/movie_details.dart';
import 'package:movie_match/screens/movie_cast_screen.dart';
import 'package:movie_match/screens/movie_video_screen.dart';
import 'package:movie_match/widgets/pill.dart';
import '../../l10n/app_localizations.dart';

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
            child: Stack(
              children: [
                Scrollbar(
                  thumbVisibility: true,
                  controller: _controller,
                  child: SingleChildScrollView(
                    controller: _controller,
                    padding: const EdgeInsets.only(right: 8, bottom: 8),
                    child: Text(
                      widget.movie.overview.isEmpty
                          ? AppLocalizations.of(context)!.description_missing
                          : widget.movie.overview,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 20,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Theme.of(context).colorScheme.surface,
                            Theme.of(context).colorScheme.surface.withAlpha(0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                spacing: 8,
                children: [
                  Pill(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieCastScreen(movie: widget.movie),
                      ),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    padding: const .all(12),
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.people,
                      size: 22,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Pill(
                    onTap: () => showDialog<void>(
                      context: context,
                      builder: (context) =>
                          MovieVideoScreen(movie: widget.movie),
                    ),
                    color: Theme.of(context).colorScheme.primary,
                    padding: const .all(12),
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.videocam,
                      size: 22,
                      color: Theme.of(context).colorScheme.onPrimary,
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
