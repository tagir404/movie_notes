import 'package:material_ui/material_ui.dart';
import 'package:movie_match/enums/media_content_type.dart';
import 'package:movie_match/enums/media_sort_option.dart';
import 'package:movie_match/models/genre_filter.dart';
import 'package:movie_match/models/movie.dart';
import 'package:movie_match/models/movie_details.dart';
import 'package:movie_match/repositories/favorites_repository.dart';
import 'package:movie_match/widgets/app_scope.dart';
import 'package:movie_match/widgets/media_filters.dart';
import 'package:movie_match/widgets/media_swiper_view.dart';
import 'package:movie_match/widgets/movie_card/movie_card.dart';
import '../l10n/app_localizations.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesRepository _repository;

  MediaContentType _selectedType = MediaContentType.movie;
  MediaSortOption _selectedSort = MediaSortOption.popularity;
  GenreFilter _genreFilter = const GenreFilter();
  // String? _selectedCountry;

  final Map<int, MovieDetails> _movieDetails = {};

  bool _isLoading = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;
      _repository = AppScope.of(context).favoritesRepository;
      _loadFavorites();
    }
  }

  Future<void> _loadFavorites() async {
    await _repository.getFavorites();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  void _setContentType(MediaContentType type) {
    if (_selectedType == type) return;

    setState(() {
      _selectedType = type;
      _genreFilter = const GenreFilter();
    });
  }

  void _setSort(MediaSortOption sortOption) {
    setState(() {
      _selectedSort = sortOption;
    });
  }

  void _setGenres(List<int> genreIds) {
    setState(() {
      _genreFilter = _genreFilter.copyWith(genreIds: genreIds);
    });
  }

  Future<void> _loadMovieDetails(Movie movie) async {
    if (_movieDetails.containsKey(movie.id)) return;

    final mediaRepository = AppScope.of(context).mediaRepository;

    final details = await mediaRepository.getMovieDetails(movie.id, movie.type);

    if (!mounted) return;

    setState(() {
      _movieDetails[movie.id] = details;
    });
  }

  Future<void> _removeMovie(int movieId) async {
    await _repository.removeFavorite(movieId);
  }

  @override
  Widget build(BuildContext context) {
    final mediaRepository = AppScope.of(context).mediaRepository;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
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
              child: ValueListenableBuilder<List<Movie>>(
                valueListenable: _repository.favorites,
                builder: (context, items, child) {
                  final movies = items
                      .where((movie) => movie.type == _selectedType)
                      .where((movie) {
                        if (_genreFilter.genreIds.isEmpty) return true;

                        return movie.genreIds.any(
                          (genreId) => _genreFilter.genreIds.contains(genreId),
                        );
                      })
                      .toList();

                  movies.sort((a, b) {
                    switch (_selectedSort) {
                      case .popularity:
                        return b.popularity.compareTo(a.popularity);

                      case .newest:
                        return b.releaseDate.compareTo(a.releaseDate);

                      case .rating:
                        return b.voteAverage.compareTo(a.voteAverage);
                    }
                  });

                  return MediaSwiperView(
                    isLoading: false,
                    items: movies,
                    cardBuilder: (context, movie) {
                      _loadMovieDetails(movie);

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
                    onSwipe: (previousIndex, currentIndex, direction, movie) {
                      if (direction == .left) {
                        _removeMovie(movie.id);
                      }

                      return true;
                    },
                    leftActionText: AppLocalizations.of(context)!.action_delete,
                    rightActionText: AppLocalizations.of(context)!.action_swipe,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
