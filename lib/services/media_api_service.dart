import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_notes/constants/api_constants.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/models/genre.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_details.dart';

class MediaApiService {
  final http.Client client;

  MediaApiService(this.client);

  final accessToken = dotenv.get('ACCESS_TOKEN');

  Future<List<Genre>> fetchGenres(MediaContentType type) async {
    final endpoint = switch (type) {
      .movie => '/3/genre/movie/list',
      .tvShow => '/3/genre/tv/list',
    };

    final response = await _get(endpoint);

    return (response['genres'] as List)
        .map((json) => Genre.fromJson(json))
        .toList();
  }

  Future<List<Movie>> fetchMedia({
    required MediaContentType type,
    int page = 1,
    List<int>? genreIds,
  }) async {
    final json = await _get(
      type == .movie ? '/3/discover/movie' : '/3/discover/tv',
      queryParameters: {
        'page': page.toString(),
        'sort_by': 'popularity.desc',
        'vote_average.gte': '6.5',
        'vote_count.gte': '1000',
        'include_adult': 'false',
        if (genreIds != null && genreIds.isNotEmpty)
          'with_genres': genreIds.join(','),
      },
    );

    return (json['results'] as List)
        .map((item) => Movie.fromJson(item, type))
        .toList();
  }

  Future<MovieDetails> fetchMediaDetails(int id, MediaContentType type) async {
    final endpoint = type == .movie ? '/3/movie/$id' : '/3/tv/$id';

    final json = await _get(endpoint);

    return MovieDetails.fromJson(json);
  }

  Future<Map<String, dynamic>> fetchMediaVideos(
    int id,
    MediaContentType type,
  ) async {
    final endpoint = type == .movie
        ? '/3/movie/$id/videos'
        : '/3/tv/$id/videos';

    return await _get(endpoint);
  }

  void _checkResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('Request failed: ${response.statusCode}');
    }
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
