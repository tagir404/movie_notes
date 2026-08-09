import 'package:flutter/material.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/models/genre_filter.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/repositories/favorites_repository.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:movie_notes/widgets/media_swiper_view.dart';
import 'package:movie_notes/widgets/movie_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesRepository _repository;
  MediaContentType _selectedType = MediaContentType.movie;
  GenreFilter _genreFilter = const GenreFilter();
  final Map<int, MovieDetails> _movieDetails = {};
  bool _isLoading = true;
  bool _initialized = false;
  List<Movie> _items = [];

  Future<void> _loadMovieDetails(Movie movie) async {
    if (_movieDetails.containsKey(movie.id)) return;

    final mediaRepository = AppScope.of(context).mediaRepository;
    final details = await mediaRepository.getMovieDetails(movie.id, movie.type);

    if (!mounted) return;

    setState(() {
      _movieDetails[movie.id] = details;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;
      _repository = AppScope.of(context).favoritesRepository;
      _loadItems();
    }
  }

  Future<void> _loadItems() async {
    final items = await _repository.getFavorites();

    if (!mounted) return;

    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  Future<void> _removeMovie(int movieId) async {
    await _repository.removeFavorite(movieId);
    if (!mounted) return;
    setState(() => _items.removeWhere((item) => item.id == movieId));
  }

  @override
  Widget build(BuildContext context) {
    final mediaRepository = AppScope.of(context).mediaRepository;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final movies = _items.where((movie) => movie.type == _selectedType).where((
      movie,
    ) {
      if (_genreFilter.genreIds.isEmpty) return true;
      return movie.genreIds.any(
        (genreId) => _genreFilter.genreIds.contains(genreId),
      );
    }).toList();

    if (movies.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Нет сохраненных элементов.')),
      );
    }

    return Scaffold(
      body: MediaSwiperView(
        initialType: _selectedType,
        isLoading: false,
        items: movies,
        selectedGenres: _genreFilter.genreIds,
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
        actionsInfo: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Row(
              spacing: 8,
              children: [
                const Icon(Icons.swipe_left, size: 16),
                Text('Удалить', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            Row(
              spacing: 8,
              children: [
                Text(
                  'Просмотрено',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Icon(Icons.swipe_right, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
