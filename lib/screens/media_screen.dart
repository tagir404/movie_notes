import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/models/genre_filter.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/repositories/favorites_repository.dart';
import 'package:movie_notes/repositories/media_repository.dart';
import 'package:movie_notes/services/media_api_service.dart';
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
  late final MediaApiService mediaApiService;
  late final MediaRepository mediaRepository;
  late final FavoritesRepository favoritesRepository;

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

    mediaApiService = AppScope.of(context).mediaApiService;
    mediaRepository = AppScope.of(context).mediaRepository;
    favoritesRepository = AppScope.of(context).favoritesRepository;

    _loadMedia();
  }

  Future<void> _loadMedia() async {
    setState(() => isLoading = true);

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

      setState(() => isLoading = false);
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
      return mediaApiService.fetchMedia(
        type: MediaContentType.movie,
        genreIds: _genreFilter.genreIds,
      );
    }

    return mediaApiService.fetchMedia(type: MediaContentType.movie, page: page);
  }

  Future<List<Movie>> _loadTvShows() {
    if (_genreFilter.hasGenres) {
      return mediaApiService.fetchMedia(
        type: MediaContentType.tvShow,
        genreIds: _genreFilter.genreIds,
      );
    }

    return mediaApiService.fetchMedia(
      type: MediaContentType.tvShow,
      page: page,
    );
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
      initialType: _selectedType,
      isLoading: isLoading,
      items: movies,
      genresForType: mediaRepository.genres,
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
      allowedSwipeDirection: const AllowedSwipeDirection.symmetric(
        horizontal: true,
        vertical: false,
      ),
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
              Text(
                'Неинтересно',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
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
        if (currentIndex == null) return true;
        if (direction == .right) {
          favoritesRepository.addFavorite(movie);
        } else if (direction == .left) {
          AppScope.of(context).skippedMediaRepository.addSkippedMedia(movie);
        }

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
