import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_notes/constants/api_constants.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/models/genre.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';

class MovieApiService {
  final http.Client client;

  MovieApiService(this.client);

  final accessToken = dotenv.get('ACCESS_TOKEN');

  Future<List<Genre>> fetchGenres() async {
    final responses = await Future.wait([
      _get('/3/genre/movie/list'),
      _get('/3/genre/tv/list'),
    ]);

    final movieGenres = responses[0]['genres'] as List;
    final tvShowGenres = responses[1]['genres'] as List;

    return {
      ...movieGenres.map((json) => Genre.fromJson(json)),
      ...tvShowGenres.map((json) => Genre.fromJson(json)),
    }.toList();
  }

  Future<List<Movie>> fetchTrendingMovies() async {
    final json = await _get('/3/trending/movie/week');

    return (json['results'] as List)
        .map((item) => Movie.fromJson(item, MediaContentType.movie))
        .toList();
  }

  Future<List<Movie>> fetchTrendingTvShows() async {
    final json = await _get('/3/trending/tv/week');

    return (json['results'] as List)
        .map((item) => Movie.fromJson(item, MediaContentType.tvShow))
        .toList();
  }

  Future<MovieDetails> fetchMediaDetails(int id, MediaContentType type) async {
    final endpoint = type == MediaContentType.movie
        ? '/3/movie/$id'
        : '/3/tv/$id';

    final json = await _get(endpoint);

    debugPrint(json.toString());

    return MovieDetails.fromJson(json);
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Request failed: ${response.statusCode}');
    }
  }

  Future<List<Movie>> fetchMoviesByGenres(List<int> genreIds) async {
    final json = await _get(
      '/3/discover/movie',
      queryParameters: {'with_genres': genreIds.join(',')},
    );

    return (json['results'] as List)
        .map((item) => Movie.fromJson(item, MediaContentType.movie))
        .toList();
  }

  Future<List<Movie>> fetchTvShowsByGenres(List<int> genreIds) async {
    final json = await _get(
      '/3/discover/tv',
      queryParameters: {'with_genres': genreIds.join(',')},
    );

    return (json['results'] as List)
        .map((item) => Movie.fromJson(item, MediaContentType.tvShow))
        .toList();
  }

  Future<dynamic> _get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = Uri.https(ApiConstants.baseUrl, path, {
      'language': ApiConstants.language,
      ...?queryParameters,
    });

    final response = await client.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    _checkResponse(response);

    return jsonDecode(response.body);
  }
}
