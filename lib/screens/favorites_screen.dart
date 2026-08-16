import 'package:material_ui/material_ui.dart';
import 'package:movie_match/enums/media_content_type.dart';
import 'package:movie_match/enums/media_sort_option.dart';
import 'package:movie_match/models/genre_filter.dart';
import 'package:movie_match/models/movie.dart';
import 'package:movie_match/models/movie_details.dart';
import 'package:movie_match/repositories/favorites_repository.dart';
import 'package:movie_match/widgets/app_scope.dart';
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
      body: ValueListenableBuilder<List<Movie>>(
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
              case MediaSortOption.popularity:
                return b.voteAverage.compareTo(a.voteAverage);

              case MediaSortOption.newest:
                return b.releaseDate.compareTo(a.releaseDate);
            }
          });

          return MediaSwiperView(
            initialType: _selectedType,
            isLoading: false,
            items: movies,
            selectedGenres: _genreFilter.genreIds,
            selectedSort: _selectedSort,
            onTypeChanged: (type) {
              setState(() {
                _selectedType = type;
              });
            },
            onGenresChanged: (genreIds) {
              setState(() {
                _genreFilter = _genreFilter.copyWith(genreIds: genreIds);
              });
            },
            onSortChanged: (sortOption) {
              setState(() {
                _selectedSort = sortOption;
              });
            },
            cardBuilder: (context, movie, selectedType, selectedGenres) {
              _loadMovieDetails(movie);

              final movieGenres = movie.genreIds
                  .map(
                    (id) => mediaRepository
                        .genres(selectedType)
                        .firstWhere((genre) => genre.id == id),
                  )
                  .toList();

              return MovieCard(
                key: ValueKey(movie.id),
                movie: movie,
                genres: movieGenres,
                selectedGenreIds: selectedGenres,
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
    );
  }
}
