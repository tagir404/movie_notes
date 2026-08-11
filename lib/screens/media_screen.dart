import 'package:flutter/material.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/enums/media_sort_option.dart';
import 'package:movie_notes/models/genre_filter.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/repositories/favorites_repository.dart';
import 'package:movie_notes/repositories/media_repository.dart';
import 'package:movie_notes/repositories/skipped_media_repository.dart';
import 'package:movie_notes/services/media_api_service.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:movie_notes/widgets/media_swiper_view.dart';
import 'package:movie_notes/widgets/movie_card/movie_card.dart';

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

  final Map<int, MovieDetails> _movieDetails = {};

  bool isLoading = true;
  bool _initialized = false;
  int page = 1;

  List<Movie> movies = [];

  GenreFilter _genreFilter = const GenreFilter();
  MediaContentType _selectedType = MediaContentType.movie;
  MediaSortOption _selectedSort = MediaSortOption.popularity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    mediaApiService = AppScope.of(context).mediaApiService;
    mediaRepository = AppScope.of(context).mediaRepository;
    favoritesRepository = AppScope.of(context).favoritesRepository;
    skippedMediaRepository = AppScope.of(context).skippedMediaRepository;

    _loadMedia();
  }

  Future<void> _loadMedia() async {
    setState(() => isLoading = true);

    try {
      final skippedMovies = await skippedMediaRepository.getSkippedMedia();
      final skippedIds = skippedMovies.map((movie) => movie.id).toSet();

      List<Movie> filteredMovies = const [];
      var attempts = 0;

      while (attempts < 5) {
        final loadedMovies = await _loadMediaPage();

        filteredMovies = loadedMovies
            .where((movie) => !skippedIds.contains(movie.id))
            .toList();

        if (filteredMovies.isNotEmpty ||
            _genreFilter.hasGenres ||
            loadedMovies.isEmpty) {
          break;
        }

        page++;
        attempts++;
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

  Future<List<Movie>> _loadMediaPage() => mediaApiService.fetchMedia(
    type: _selectedType,
    page: page,
    genreIds: _genreFilter.hasGenres ? _genreFilter.genreIds : null,
    sortOption: _selectedSort,
  );

  void _setContentType(MediaContentType type) {
    if (_selectedType == type) return;

    setState(() {
      _selectedType = type;
      page = 1;
      movies = [];
      _movieDetails.clear();
      _genreFilter = const GenreFilter();
      _selectedSort = MediaSortOption.popularity;
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

  @override
  Widget build(BuildContext context) => Scaffold(
    body: MediaSwiperView(
      isLoop: false,
      initialType: _selectedType,
      isLoading: isLoading,
      items: movies,
      selectedGenres: _genreFilter.genreIds,
      selectedSort: _selectedSort,
      onTypeChanged: _setContentType,
      onGenresChanged: (genreIds) {
        setState(() {
          _genreFilter = _genreFilter.copyWith(genreIds: genreIds);
          page = 1;
          movies = [];
          _movieDetails.clear();
        });

        _loadMedia();
      },

      onSortChanged: (sortOption) {
        setState(() {
          _selectedSort = sortOption;
          page = 1;
          movies = [];
          _movieDetails.clear();
        });

        _loadMedia();
      },
      cardBuilder: (context, movie, selectedType, selectedGenres) {
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
      actionsInfo: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            spacing: 8,
            children: [
              const Icon(Icons.swipe_left, size: 16),
              Text('Пропустить', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              Text('Сохранить', style: Theme.of(context).textTheme.bodyMedium),
              const Icon(Icons.swipe_right, size: 16),
            ],
          ),
        ],
      ),
      onSwipe: (previousIndex, currentIndex, direction, movie) {
        if (direction == .right) {
          favoritesRepository.addFavorite(movie);
        } else if (direction == .left) {
          skippedMediaRepository.addSkippedMedia(movie);
        }

        if (currentIndex == null) return true;
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
