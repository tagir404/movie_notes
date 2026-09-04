import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:movie_match/enums/media_content_type.dart';
import 'package:movie_match/models/movie.dart';
import 'package:movie_match/services/media_api_service.dart';

class AiSearchService {
  AiSearchService({
    required http.Client client,
    required MediaApiService mediaApiService,
  }) : _client = client,
       _mediaApiService = mediaApiService;

  final http.Client _client;
  final MediaApiService _mediaApiService;

  static Future<AiSearchService> create(
    MediaApiService mediaApiService,
  ) async =>
      AiSearchService(client: http.Client(), mediaApiService: mediaApiService);

  Future<List<Movie>> search({
    required String description,
    MediaContentType contentType = MediaContentType.movie,
    int limit = 10,
  }) async {
    final titles = await _fetchTitles(
      description: description,
      contentType: contentType,
      limit: limit,
    );

    final movies = <Movie>[];
    final seenIds = <int>{};

    for (final title in titles) {
      if (movies.length >= limit) break;

      final results = await _mediaApiService.searchMedia(
        query: title,
        type: contentType,
      );
      if (results.isEmpty) continue;

      final match = results.first;
      if (seenIds.add(match.id)) {
        movies.add(match);
      }
    }

    return movies;
  }

  Future<List<String>> _fetchTitles({
    required String description,
    required MediaContentType contentType,
    required int limit,
  }) async {
    final apiKey = dotenv.get('GEMINI_API_KEY', fallback: '');
    if (apiKey.isEmpty) {
      throw StateError('GEMINI_API_KEY is missing. Add it to .env');
    }

    final kind = contentType == MediaContentType.tvShow ? 'TV show' : 'movie';
    final prompt =
        '''
You are a $kind recommendation assistant.
User request: $description

Return ONLY a valid JSON array of up to $limit $kind titles that best match the request.
Each item is a plain string with just the title, e.g. ["Fight Club", "Se7en"].
Return valid JSON only, with no markdown or extra text.
''';

    final model = dotenv.get('GEMINI_MODEL', fallback: 'gemini-3.5-flash');
    final response = await _client.post(
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {'temperature': 0.2},
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Gemini request failed: ${response.statusCode} ${response.body}',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = body['candidates'] as List<dynamic>? ?? const [];
    if (candidates.isEmpty) {
      return const [];
    }

    final parts =
        (candidates.first as Map<String, dynamic>)['content']?['parts']
            as List<dynamic>? ??
        const [];
    if (parts.isEmpty) {
      return const [];
    }

    final rawText = (parts.first as Map<String, dynamic>)['text'] ?? '';
    final cleaned = rawText
        .toString()
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final parsed = jsonDecode(cleaned);
    final items = parsed is List ? parsed : const <dynamic>[];

    return items.map((title) => title.toString()).toList();
  }
}
