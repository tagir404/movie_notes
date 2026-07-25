import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/widgets/movie_card.dart';

class Movies extends StatefulWidget {
  const Movies({super.key});

  @override
  State<Movies> createState() => _MoviesState();
}

class _MoviesState extends State<Movies> {
  final accessToken = dotenv.get('ACCESS_TOKEN');
  bool isLoading = true;

  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final uri = Uri.https('api.themoviedb.org', '/3/movie/popular', {
      'language': 'ru-RU',
    });

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json['results'] as List<dynamic>;

      setState(() {
        movies = results.map((movie) => Movie.fromJson(movie)).toList();
        isLoading = false;
      });
    } else {
      isLoading = false;
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
