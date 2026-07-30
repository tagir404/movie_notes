import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/repositories/movie_repository.dart';
import 'package:movie_notes/services/movie_api_service.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:movie_notes/widgets/movie_card.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  late final MovieApiService movieApiService;
  late final MovieRepository movieRepository;

  final Map<int, MovieDetails> _movieDetails = {};
  bool isLoading = true;
  bool _initialized = false;
  List<Movie> movies = [];

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
      final loadedMovies = await movieApiService.fetchPopularMovies();

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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (movies.isEmpty) {
      return const Center(child: Text('Фильмы не найдены'));
    }

    return CardSwiper(
      cardsCount: movies.length,
      cardBuilder: (context, index, _, _) {
        final movieGenres = movies[index].genreIds
            .map(
              (id) => movieRepository.genres
                  .firstWhere((genre) => genre.id == id)
                  .name,
            )
            .toList();

        final movie = movies[index];

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
    );
  }
}
