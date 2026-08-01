import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/models/genre_filter.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/repositories/media_repository.dart';
import 'package:movie_notes/services/movie_api_service.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:movie_notes/widgets/movie_card.dart';
import 'package:movie_notes/widgets/movie_genre_filter.dart';
import 'package:movie_notes/widgets/pill.dart';

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

  final CardSwiperController _cardSwiperController = CardSwiperController();
  final Map<int, MovieDetails> _movieDetails = {};

  bool isLoading = true;
  bool _initialized = false;

  List<Movie> movies = [];

  GenreFilter _genreFilter = const GenreFilter();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    movieApiService = AppScope.of(context).movieApiService;
    movieRepository = AppScope.of(context).movieRepository;

    _loadMedia();
  }

  Future<void> _loadMedia() async {
    setState(() {
      isLoading = true;
    });

    try {
      final loadedMovies = widget.type == MediaContentType.movie
          ? await _loadMovies()
          : await _loadTvShows();

      if (!mounted) return;

      setState(() {
        movies = loadedMovies;
        isLoading = false;
      });

      _preloadDetails(0);
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  void _preloadDetails(int index) {
    _loadMovieDetails(movies[index]);

    if (index + 1 < movies.length) {
      _loadMovieDetails(movies[index + 1]);
    }
  }

  Future<List<Movie>> _loadMovies() {
    if (_genreFilter.hasGenres) {
      return movieApiService.fetchMoviesByGenres(_genreFilter.genreIds);
    }

    return movieApiService.fetchTrendingMovies();
  }

  Future<List<Movie>> _loadTvShows() {
    if (_genreFilter.hasGenres) {
      return movieApiService.fetchTvShowsByGenres(_genreFilter.genreIds);
    }

    return movieApiService.fetchTrendingTvShows();
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (movies.isEmpty) {
      return Center(child: Text(widget.emptyMessage));
    }

    return Column(
      children: [
        MovieGenreFilter(
          genres: movieRepository.genres(widget.type),
          selectedGenres: _genreFilter.genreIds,
          onChanged: (genreIds) {
            setState(() {
              _genreFilter = _genreFilter.copyWith(genreIds: genreIds);
            });

            _loadMedia();
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: CardSwiper(
            padding: const .all(0),
            controller: _cardSwiperController,
            allowedSwipeDirection: const .symmetric(
              horizontal: true,
              vertical: false,
            ),
            cardsCount: movies.length,
            cardBuilder: (context, index, _, _) {
              final movie = movies[index];

              final movieGenres = movie.genreIds
                  .map(
                    (id) => movieRepository
                        .genres(widget.type)
                        .firstWhere((genre) => genre.id == id),
                  )
                  .toList();

              return MovieCard(
                movie: movie,
                genres: movieGenres,
                selectedGenreIds: _genreFilter.genreIds,
                movieDetails: _movieDetails[movie.id],
              );
            },
            onSwipe: (previousIndex, currentIndex, direction) {
              if (currentIndex == null) return true;

              _preloadDetails(currentIndex);

              return true;
            },
          ),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: .center,
          spacing: 40,
          children: [
            Pill(
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () => _cardSwiperController.swipe(.left),
                icon: const Icon(Icons.block, size: 40, color: Colors.red),
              ),
            ),
            Pill(
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () => _cardSwiperController.swipe(.right),
                icon: const Icon(
                  Icons.bookmark_add,
                  size: 40,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
