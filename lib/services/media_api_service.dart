import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_notes/constants/api_constants.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/enums/media_sort_option.dart';
import 'package:movie_notes/models/genre.dart';
import 'package:movie_notes/models/media_page_result.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_cast_member.dart';
import 'package:movie_notes/models/movie_details.dart';

class MediaApiService {
  final http.Client client;

  MediaApiService(this.client);

  final accessToken = dotenv.get('ACCESS_TOKEN');

  String language = ApiConstants.languageForLocaleCode('en');

  Future<List<Genre>> fetchGenres(MediaContentType type) async {
    final endpoint = switch (type) {
      .movie => '/genre/movie/list',
      .tvShow => '/genre/tv/list',
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
    MediaSortOption sortOption = MediaSortOption.popularity,
  }) async {
    final result = await fetchMediaPage(
      type: type,
      page: page,
      genreIds: genreIds,
      sortOption: sortOption,
    );

    return result.movies;
  }

  Future<MediaPageResult> fetchMediaPage({
    required MediaContentType type,
    int page = 1,
    List<int>? genreIds,
    MediaSortOption sortOption = MediaSortOption.popularity,
  }) async {
    final json = await _get(
      type == .movie ? '/discover/movie' : '/discover/tv',
      queryParameters: {
        'page': page.toString(),
        'sort_by': sortOption.apiValueFor(type),
        'vote_average.gte': '6.5',
        'vote_count.gte': '1000',
        'include_adult': 'false',
        if (genreIds != null && genreIds.isNotEmpty)
          'with_genres': genreIds.join(','),
      },
    );

    return MediaPageResult(
      movies: (json['results'] as List)
          .map((item) => Movie.fromJson(item, type))
          .toList(),
      totalPages: (json['total_pages'] as num?)?.toInt() ?? page,
    );
  }

  Future<MovieDetails> fetchMediaDetails(int id, MediaContentType type) async {
    final endpoint = type == .movie ? '/movie/$id' : '/tv/$id';

    final json = await _get(endpoint);

    return MovieDetails.fromJson(json);
  }

  Future<String?> getTrailerKey(int mediaId, MediaContentType type) async {
    final endpoint = type == MediaContentType.movie
        ? '/movie/$mediaId/videos'
        : '/tv/$mediaId/videos';

    final json = await _get(endpoint);

    final videos = json['results'] as List;

    final trailers = videos
        .where(
          (video) => video['site'] == 'YouTube' && video['type'] == 'Trailer',
        )
        .cast<Map<String, dynamic>>()
        .toList();

    if (trailers.isEmpty) return null;

    trailers.sort((a, b) => (b['size'] ?? 0).compareTo(a['size'] ?? 0));

    final officialTrailer = trailers.where(
      (video) => video['official'] == true,
    );

    if (officialTrailer.isNotEmpty) {
      return officialTrailer.first['key'] as String;
    }

    return trailers.first['key'] as String;
  }

  Future<List<MovieCastMember>> fetchMediaCredits(
    int id,
    MediaContentType type,
  ) async {
    final endpoint = type == .movie ? '/movie/$id/credits' : '/tv/$id/credits';

    final json = await _get(endpoint);

    return (json['cast'] as List?)
            ?.map(
              (item) => MovieCastMember.fromJson(item as Map<String, dynamic>),
            )
            .toList() ??
        [];
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
    final uri = Uri.https(ApiConstants.baseUrl, '/3$path', {
      'language': language,
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
