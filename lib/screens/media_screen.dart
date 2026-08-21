import 'package:material_ui/material_ui.dart';
import 'package:movie_match/enums/media_content_type.dart';
import 'package:movie_match/enums/media_sort_option.dart';
import 'package:movie_match/l10n/app_localizations.dart';
import 'package:movie_match/models/genre_filter.dart';
import 'package:movie_match/models/media_page_result.dart';
import 'package:movie_match/models/movie.dart';
import 'package:movie_match/models/movie_details.dart';
import 'package:movie_match/repositories/favorites_repository.dart';
import 'package:movie_match/repositories/media_repository.dart';
import 'package:movie_match/repositories/skipped_media_repository.dart';
import 'package:movie_match/services/media_api_service.dart';
import 'package:movie_match/theme/locale_controller.dart';
import 'package:movie_match/widgets/app_scope.dart';
import 'package:movie_match/widgets/media_empty_state.dart';
import 'package:movie_match/widgets/media_filters.dart';
import 'package:movie_match/widgets/media_swiper_view.dart';
import 'package:movie_match/widgets/movie_card/movie_card.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  late final MediaApiService mediaApiService;
  late final MediaRepository mediaRepository;
  late final FavoritesRepository favoritesRepository;
  late final SkippedMediaRepository skippedMediaRepository;
  late final LocaleController localeController;

  final Map<int, MovieDetails> _movieDetails = {};
  final _swiperKey = GlobalKey<MediaSwiperViewState>();

  bool isLoading = true;
  bool _initialized = false;
  int page = 1;

  List<Movie> movies = [];

  GenreFilter _genreFilter = const GenreFilter();
  MediaContentType _selectedType = MediaContentType.movie;
  MediaSortOption _selectedSort = MediaSortOption.popularity;
  String? _selectedCountry;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    mediaApiService = AppScope.of(context).mediaApiService;
    mediaRepository = AppScope.of(context).mediaRepository;
    favoritesRepository = AppScope.of(context).favoritesRepository;
    skippedMediaRepository = AppScope.of(context).skippedMediaRepository;
    localeController = AppScope.of(context).localeController;
    localeController.addListener(_reloadLocalizedMedia);

    _loadMedia();
  }

  Future<void> _loadMedia() async {
    setState(() => isLoading = true);

    try {
      final skippedMovies = await skippedMediaRepository.getSkippedMedia();
      final favoriteMovies = await favoritesRepository.getFavorites();
      final excludedIds = {
        ...skippedMovies.map((movie) => movie.id),
        ...favoriteMovies.map((movie) => movie.id),
      };

      List<Movie> filteredMovies = const [];
      bool hasMorePages = true;

      while (hasMorePages) {
        final loadedPage = await _loadMediaPage();
        final loadedMovies = loadedPage.movies;

        filteredMovies = loadedMovies
            .where((movie) => !excludedIds.contains(movie.id))
            .toList();

        hasMorePages = page < loadedPage.totalPages;

        if (filteredMovies.isNotEmpty ||
            loadedMovies.isEmpty ||
            !hasMorePages) {
          break;
        }

        page++;
      }

      if (!mounted) return;

      setState(() {
        movies = filteredMovies;
        isLoading = false;
      });

      if (movies.isNotEmpty) {
        _preloadDetails(0);
      }
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() => isLoading = false);
    }
  }

  Future<void> _reloadLocalizedMedia() async {
    setState(() {
      _resetPagination();
      isLoading = true;
    });

    await mediaRepository.refreshLocalizedData();

    if (!mounted) return;

    await _loadMedia();
  }

  @override
  void dispose() {
    if (_initialized) {
      localeController.removeListener(_reloadLocalizedMedia);
    }
    super.dispose();
  }

  Future<MediaPageResult> _loadMediaPage() => mediaApiService.fetchMediaPage(
    type: _selectedType,
    page: page,
    genreIds: _genreFilter.hasGenres ? _genreFilter.genreIds : null,
    sortOption: _selectedSort,
    countryCode: _selectedCountry,
  );

  void _setContentType(MediaContentType type) {
    if (_selectedType == type) return;

    setState(() {
      _selectedType = type;
      _resetPagination();
      _genreFilter = const GenreFilter();
    });

    _loadMedia();
  }

  void _setSort(MediaSortOption sortOption) {
    setState(() {
      _selectedSort = sortOption;
      _resetPagination();
    });

    _loadMedia();
  }

  void _setGenres(List<int> genreIds) {
    setState(() {
      _genreFilter = _genreFilter.copyWith(genreIds: genreIds);
      _resetPagination();
    });

    _loadMedia();
  }

  void _preloadDetails(int index) {
    if (index < 0 || index >= movies.length) return;

    _loadMovieDetails(movies[index]);

    if (index + 1 < movies.length) {
      _loadMovieDetails(movies[index + 1]);
    }
  }

  Future<void> _loadMovieDetails(Movie movie) async {
    if (_movieDetails.containsKey(movie.id)) return;

    final details = await mediaRepository.getMovieDetails(movie.id, movie.type);

    if (!mounted) return;

    setState(() {
      _movieDetails[movie.id] = details;
    });
  }

  void _resetPagination() {
    page = 1;
    movies = [];
    _movieDetails.clear();
  }

  void _resetFilters() {
    setState(() {
      _selectedType = .movie;
      _genreFilter = const GenreFilter();
      _resetPagination();
    });

    _loadMedia();
  }

  void _showUndoSnackBar({
    required String message,
    required VoidCallback onUndo,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: AppLocalizations.of(context)!.action_undo,
            onPressed: onUndo,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(
      padding: const .only(left: 20, right: 20, top: 12, bottom: 12),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: MediaFilters(
              selectedSort: _selectedSort,
              onSortChanged: _setSort,
              selectedType: _selectedType,
              onTypeChanged: _setContentType,
              selectedGenres: _genreFilter.genreIds,
              onGenresChanged: _setGenres,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : movies.isEmpty
                ? MediaEmptyState(onReset: _resetFilters)
                : MediaSwiperView(
                    key: _swiperKey,
                    isLoop: false,
                    items: movies,
                    cardBuilder: (context, movie) {
                      final movieGenres = movie.genreIds
                          .map(
                            (id) => mediaRepository
                                .genres(_selectedType)
                                .firstWhere((genre) => genre.id == id),
                          )
                          .toList();

                      return MovieCard(
                        key: ValueKey(movie.id),
                        movie: movie,
                        genres: movieGenres,
                        selectedGenreIds: _genreFilter.genreIds,
                        movieDetails: _movieDetails[movie.id],
                      );
                    },
                    leftActionText: AppLocalizations.of(context)!.action_skip,
                    rightActionText: AppLocalizations.of(context)!.action_save,
                    onSwipe: (previousIndex, currentIndex, direction, movie) {
                      if (direction == .right) {
                        favoritesRepository.addFavorite(movie);
                        _showUndoSnackBar(
                          message: AppLocalizations.of(
                            context,
                          )!.media_saved_snackbar,
                          onUndo: () async {
                            await favoritesRepository.removeFavorite(movie.id);
                            _swiperKey.currentState?.undo();
                          },
                        );
                      } else if (direction == .left) {
                        skippedMediaRepository.addSkippedMedia(movie);
                        _showUndoSnackBar(
                          message: AppLocalizations.of(
                            context,
                          )!.media_skipped_snackbar,
                          onUndo: () async {
                            await skippedMediaRepository.removeSkippedMedia(
                              movie.id,
                            );
                            _swiperKey.currentState?.undo();
                          },
                        );
                      }

                      if (currentIndex == null) return true;
                      _preloadDetails(currentIndex);

                      return true;
                    },
                    onEnd: () {
                      setState(() => page++);

                      _loadMedia();
                    },
                  ),
          ),
        ],
      ),
    ),
  );
}
