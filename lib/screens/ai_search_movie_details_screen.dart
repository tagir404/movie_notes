import 'package:material_ui/material_ui.dart';
import 'package:movie_match/models/genre.dart';
import 'package:movie_match/models/movie.dart';
import 'package:movie_match/models/movie_details.dart';
import 'package:movie_match/repositories/favorites_repository.dart';
import 'package:movie_match/repositories/media_repository.dart';
import 'package:movie_match/widgets/app_scope.dart';
import 'package:movie_match/widgets/movie_card/movie_card.dart';
import '../l10n/app_localizations.dart';

class AiSearchMovieDetailsScreen extends StatefulWidget {
  const AiSearchMovieDetailsScreen({required this.movie, super.key});

  final Movie movie;

  @override
  State<AiSearchMovieDetailsScreen> createState() =>
      _AiSearchMovieDetailsScreenState();
}

class _AiSearchMovieDetailsScreenState
    extends State<AiSearchMovieDetailsScreen> {
  late final MediaRepository _mediaRepository;
  late final FavoritesRepository _favoritesRepository;
  bool _initialized = false;

  MovieDetails? _movieDetails;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;
    _mediaRepository = AppScope.of(context).mediaRepository;
    _favoritesRepository = AppScope.of(context).favoritesRepository;
    _loadMovieDetails();
  }

  Future<void> _loadMovieDetails() async {
    final details = await _mediaRepository.getMovieDetails(
      widget.movie.id,
      widget.movie.type,
    );

    if (!mounted) return;

    setState(() => _movieDetails = details);
  }

  List<Genre> get _genres => _mediaRepository
      .genres(widget.movie.type)
      .where((genre) => widget.movie.genreIds.contains(genre.id))
      .toList();

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;

    await _favoritesRepository.addFavorite(widget.movie);

    if (!mounted) return;

    Navigator.of(context).pop(widget.movie);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          persist: false,
          content: Text(l10n.media_saved_snackbar(widget.movie.type.name)),
          shape: const RoundedRectangleBorder(
            borderRadius: .only(
              topLeft: .circular(24),
              topRight: .circular(24),
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ai_search_movie_details_title),
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const .only(left: 20, right: 20, top: 12, bottom: 20),
        child: Column(
          children: [
            Expanded(
              child: MovieCard(
                movie: widget.movie,
                genres: _genres,
                selectedGenreIds: const [],
                movieDetails: _movieDetails,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const .symmetric(vertical: 12),
                ),
                child: Text(l10n.action_save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
