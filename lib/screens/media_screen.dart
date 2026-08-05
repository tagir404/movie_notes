import 'package:flutter/material.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/models/genre_filter.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/repositories/favorite_repository.dart';
import 'package:movie_notes/repositories/media_repository.dart';
import 'package:movie_notes/services/movie_api_service.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:movie_notes/widgets/media_swiper_view.dart';
import 'package:movie_notes/widgets/movie_card.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({
    required this.type,
    required this.emptyMessage,
    super.key,
  });

  final MediaContentType type;
  final String emptyMessage;

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  late final MediaApiService movieApiService;
  late final MediaRepository movieRepository;
  late final FavoriteRepository favoriteRepository;

  final Map<int, MovieDetails> _movieDetails = {};

  bool isLoading = true;
  bool _initialized = false;
  int page = 1;

  List<Movie> movies = [];
  GenreFilter _genreFilter = const GenreFilter();
  late MediaContentType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.type;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    movieApiService = AppScope.of(context).movieApiService;
    movieRepository = AppScope.of(context).movieRepository;
    favoriteRepository = AppScope.of(context).favoriteRepository;

    _loadMedia();
  }

  Future<void> _loadMedia() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedMovies = _selectedType == .movie
          ? await _loadMovies()
          : await _loadTvShows();

      if (!mounted) return;

      setState(() {
        movies = loadedMovies;
        isLoading = false;
      });

      if (movies.isNotEmpty) {
        _preloadDetails(0);
      }
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  void _setContentType(MediaContentType type) {
    if (_selectedType == type) return;

    setState(() {
      _selectedType = type;
      page = 1;
      movies = [];
      _movieDetails.clear();
      _genreFilter = const GenreFilter();
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

  Future<List<Movie>> _loadMovies() {
    if (_genreFilter.hasGenres) {
      return movieApiService.fetchMoviesByGenres(_genreFilter.genreIds);
    }

    return movieApiService.fetchPopularMovies(page);
  }

  Future<List<Movie>> _loadTvShows() {
    if (_genreFilter.hasGenres) {
      return movieApiService.fetchTvShowsByGenres(_genreFilter.genreIds);
    }

    return movieApiService.fetchPopularTvShows(page);
  }

  Future<void> _loadMovieDetails(Movie movie) async {
    if (_movieDetails.containsKey(movie.id)) return;

    final details = await movieRepository.getMovieDetails(movie.id, movie.type);

    if (!mounted) return;

    setState(() {
      _movieDetails[movie.id] = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Контент')),
      body: MediaSwiperView(
        initialType: _selectedType,
        emptyMessage: widget.emptyMessage,
        isLoading: isLoading,
        items: movies,
        genresForType: movieRepository.genres,
        selectedGenres: _genreFilter.genreIds,
        onTypeChanged: (type) {
          _setContentType(type);
        },
        onGenresChanged: (genreIds) {
          setState(() {
            _genreFilter = _genreFilter.copyWith(genreIds: genreIds);
          });

          _loadMedia();
        },
        cardBuilder: (context, movie, selectedType, selectedGenres) {
          final movieGenres = movie.genreIds
              .map(
                (id) => movieRepository
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
        leftActionInfo: Row(
          spacing: 8,
          children: [
            const Icon(Icons.swipe_left, size: 16),
            Text('Неинтересно', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        rightActionInfo: Row(
          spacing: 8,
          children: [
            Text('Сохранить', style: Theme.of(context).textTheme.bodyMedium),
            const Icon(Icons.swipe_right, size: 16),
          ],
        ),
        onSwipe: (previousIndex, currentIndex, direction, movie) {
          if (currentIndex == null) return true;
          direction == .right ? favoriteRepository.addFavorite(movie) : null;

          _preloadDetails(currentIndex);

          return true;
        },
        onEnd: () {
          setState(() {
            page++;
          });

          _loadMedia();
        },
      ),
    );
  }
}
