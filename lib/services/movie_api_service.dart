import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_notes/constants/api_constants.dart';
import 'package:movie_notes/models/genre.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';

class MovieApiService {
  final http.Client client;

  MovieApiService(this.client);

  final accessToken = dotenv.get('ACCESS_TOKEN');

  Future<List<Genre>> fetchGenres() async {
    final json = await _get('/3/genre/movie/list');

    return (json['genres'] as List)
        .map((genre) => Genre.fromJson(genre))
        .toList();
  }

  Future<List<Movie>> fetchPopularMovies() async {
    final json = await _get('/3/movie/popular');

    return (json['results'] as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();
  }

  Future<MovieDetails> fetchMovieDetails(int movieId) async {
    final json = await _get('/3/movie/$movieId');

    return MovieDetails.fromJson(json);
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Request failed: ${response.statusCode}');
    }
  }

  Future<dynamic> _get(String path) async {
    final uri = Uri.https(ApiConstants.baseUrl, path, {
      'language': ApiConstants.language,
    });

    final response = await client.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    _checkResponse(response);

    return jsonDecode(response.body);
  }
}
