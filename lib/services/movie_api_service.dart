import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_notes/constants/api_constants.dart';
import 'package:movie_notes/models/genre.dart';
import 'package:movie_notes/models/movie.dart';

class MovieApiService {
  final http.Client client;

  MovieApiService(this.client);

  final accessToken = dotenv.get('ACCESS_TOKEN');

  Future<List<Genre>> fetchGenres() async {
    final uri = Uri.https(ApiConstants.baseUrl, '/3/genre/movie/list', {
      'language': ApiConstants.language,
    });

    final response = await client.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load genres');
    }

    final json = jsonDecode(response.body);

    return (json['genres'] as List)
        .map((genre) => Genre.fromJson(genre))
        .toList();
  }

  Future<List<Movie>> fetchMovies() async {
    final uri = Uri.https(ApiConstants.baseUrl, '/3/movie/popular', {
      'language': ApiConstants.language,
    });

    final response = await client.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load genres');
    }

    final json = jsonDecode(response.body);

    return (json['results'] as List)
        .map((movie) => Movie.fromJson(movie))
        .toList();
  }
}
