import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:movie_notes/models/movie.dart';
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

  bool isLoading = true;
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();

    movieApiService = AppScope.read(context).movieApiService;
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
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
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
        return MovieCard(movie: movies[index]);
      },
    );
  }
}
