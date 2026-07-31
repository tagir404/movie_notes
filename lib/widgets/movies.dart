import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/models/movie_filter.dart';
import 'package:movie_notes/repositories/movie_repository.dart';
import 'package:movie_notes/services/movie_api_service.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:movie_notes/widgets/movie_card.dart';
import 'package:movie_notes/widgets/movie_filter_widget.dart';
import 'package:movie_notes/widgets/pill.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  late final MovieApiService movieApiService;
  late final MovieRepository movieRepository;

  final CardSwiperController _cardSwiperController = CardSwiperController();
  final Map<int, MovieDetails> _movieDetails = {};
  bool isLoading = true;
  bool _initialized = false;
  List<Movie> movies = [];
  MovieFilter _filter = const MovieFilter();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    movieApiService = AppScope.of(context).movieApiService;
    movieRepository = AppScope.of(context).movieRepository;

    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      final loadedMovies = _filter.hasGenres
          ? await movieApiService.fetchMoviesByGenres(_filter.genreIds)
          : await movieApiService.fetchPopularMovies();

      if (!mounted) return;

      setState(() {
        movies = loadedMovies;
        isLoading = false;
      });

      if (movies.isNotEmpty) {
        _loadMovieDetails(movies.first.id);
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadMovieDetails(int movieId) async {
    if (_movieDetails.containsKey(movieId)) return;

    final details = await movieRepository.getMovieDetails(movieId);

    if (!mounted) return;

    setState(() {
      _movieDetails[movieId] = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (movies.isEmpty) return const Center(child: Text('Фильмы не найдены'));

    return Column(
      crossAxisAlignment: .start,
      children: [
        MovieFilterWidget(
          genres: movieRepository.genres,
          selectedGenres: _filter.genreIds,
          onChanged: (genreIds) {
            setState(() {
              _filter = _filter.copyWith(genreIds: genreIds);
            });

            _loadMovies();
          },
        ),

        const SizedBox(height: 16),

        Expanded(
          child: CardSwiper(
            controller: _cardSwiperController,
            allowedSwipeDirection: const .symmetric(
              horizontal: true,
              vertical: false,
            ),
            padding: const .all(0),
            cardsCount: movies.length,
            cardBuilder: (context, index, _, _) {
              final movie = movies[index];

              final movieGenres = movie.genreIds
                  .map(
                    (id) => movieRepository.genres
                        .firstWhere((genre) => genre.id == id)
                        .name,
                  )
                  .toList();

              return MovieCard(
                movie: movie,
                genreNames: movieGenres,
                movieDetails: _movieDetails[movie.id],
              );
            },
            onSwipe: (previousIndex, currentIndex, direction) {
              if (currentIndex == null) return true;

              _loadMovieDetails(movies[currentIndex].id);

              if (currentIndex + 1 < movies.length) {
                _loadMovieDetails(movies[currentIndex + 1].id);
              }

              return true;
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: .center,
          spacing: 40,
          children: [
            Pill(
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () => _cardSwiperController.swipe(.left),
                icon: const Icon(Icons.block, size: 44, color: Colors.red),
              ),
            ),
            Pill(
              shape: const CircleBorder(),
              child: IconButton(
                onPressed: () => _cardSwiperController.swipe(.right),
                icon: const Icon(
                  Icons.bookmark_add,
                  size: 44,
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
