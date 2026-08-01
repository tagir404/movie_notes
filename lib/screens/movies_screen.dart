import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/models/genre_filter.dart';
import 'package:movie_notes/repositories/movie_repository.dart';
import 'package:movie_notes/services/movie_api_service.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:movie_notes/widgets/movie_card.dart';
import 'package:movie_notes/widgets/movie_genre_filter.dart';
import 'package:movie_notes/widgets/movie_type_filter.dart';
import 'package:movie_notes/widgets/pill.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  late final MovieApiService movieApiService;
  late final MovieRepository movieRepository;

  final CardSwiperController _cardSwiperController = CardSwiperController();
  final Map<int, MovieDetails> _movieDetails = {};

  bool isLoading = true;
  bool _initialized = false;

  List<Movie> movies = [];

  GenreFilter _genreFilter = const GenreFilter();
  MediaContentType? _movieTypeFilter;

  List<Movie> get filteredMovies {
    return movies.where((movie) {
      if (_movieTypeFilter != null && movie.type != _movieTypeFilter) {
        return false;
      }

      return true;
    }).toList();
  }

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
    try {
      final List<Movie> loadedMovies;

      if (_genreFilter.hasGenres) {
        if (_movieTypeFilter != null) {
          loadedMovies = await movieApiService.fetchMediaByGenres(
            _genreFilter.genreIds,
            _movieTypeFilter!,
          );
        } else {
          loadedMovies = await movieApiService.fetchTrendingByGenres(
            _genreFilter.genreIds,
          );
        }
      } else {
        loadedMovies = await movieApiService.fetchTrending();
      }

      if (!mounted) return;

      setState(() {
        movies = loadedMovies;
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
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

    if (filteredMovies.isEmpty) {
      return const Center(child: Text('Фильмы не найдены'));
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: .spaceAround,
          children: [
            MovieGenreFilter(
              genres: movieRepository.genres,
              selectedGenres: _genreFilter.genreIds,
              onChanged: (genreIds) {
                setState(() {
                  _genreFilter = _genreFilter.copyWith(genreIds: genreIds);
                });

                _loadMedia();
              },
            ),
            MovieTypeFilter(
              selectedFilter: _movieTypeFilter,
              onChanged: (filter) {
                setState(() {
                  _movieTypeFilter = filter;
                });

                _loadMedia();
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: CardSwiper(
            controller: _cardSwiperController,
            allowedSwipeDirection: const .symmetric(
              horizontal: true,
              vertical: false,
            ),
            cardsCount: filteredMovies.length,
            cardBuilder: (context, index, _, _) {
              final movie = filteredMovies[index];

              final movieGenres = movie.genreIds
                  .map(
                    (id) => movieRepository.genres.firstWhere(
                      (genre) => genre.id == id,
                    ),
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

              _loadMovieDetails(filteredMovies[currentIndex]);

              if (currentIndex + 1 < filteredMovies.length) {
                _loadMovieDetails(filteredMovies[currentIndex + 1]);
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
