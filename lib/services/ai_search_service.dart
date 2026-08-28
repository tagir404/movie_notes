import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:movie_match/enums/media_content_type.dart';
import 'package:movie_match/models/movie.dart';
import 'package:uuid/uuid.dart';

class AiSearchService {
  AiSearchService({required http.Client client}) : _client = client;

  final http.Client _client;

  static Future<AiSearchService> create() async {
    final certificate = await rootBundle.load(
      'assets/certificates/russian_trusted_root_ca.pem',
    );
    final securityContext = SecurityContext(withTrustedRoots: true)
      ..setTrustedCertificatesBytes(certificate.buffer.asUint8List());

    return AiSearchService(
      client: IOClient(HttpClient(context: securityContext)),
    );
  }

  Future<String> _getAccessToken() async {
    final authKey = dotenv.get('GIGACHAT_AUTH_KEY', fallback: '');
    final scope = dotenv.get('GIGACHAT_SCOPE', fallback: 'GIGACHAT_API_PERS');

    if (authKey.isEmpty) {
      throw StateError('GIGACHAT_AUTH_KEY is missing. Add it to .env');
    }

    final response = await _client.post(
      Uri.parse('https://ngw.devices.sberbank.ru:9443/api/v2/oauth'),
      headers: {
        'Authorization': 'Basic $authKey',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        'RqUID': const Uuid().v4(),
      },
      body: 'scope=$scope',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'GigaChat OAuth failed: ${response.statusCode} ${response.body}',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final token = body['access_token'] as String?;
    if (token == null || token.isEmpty) {
      throw StateError('GigaChat access_token is missing in OAuth response');
    }

    return token;
  }

  Future<List<Movie>> search({
    required String description,
    MediaContentType contentType = MediaContentType.movie,
    int limit = 10,
  }) async {
    final accessToken = await _getAccessToken();

    final prompt = contentType == MediaContentType.tvShow
        ? '''
You are a TV show recommendation assistant.
User request: $description

Return ONLY a valid JSON array with up to $limit items.

Each object MUST have exactly these fields:
{
  "id": 1399,
  "name": "Game of Thrones",
  "overview": "Nine noble families fight...",
  "poster_path": null,
  "backdrop_path": null,
  "first_air_date": "2011-04-17",
  "vote_average": 8.4,
  "popularity": 100.5,
  "genre_ids": [10765, 18]
}

Use snake_case field names exactly.
Return valid JSON only, with no markdown or extra text.
'''
        : '''
You are a movie recommendation assistant.
User request: $description

Return ONLY a valid JSON array with up to $limit items.

Each object MUST have exactly these fields:
{
  "id": 550,
  "title": "Fight Club",
  "overview": "A depressed man...",
  "poster_path": null,
  "backdrop_path": null,
  "release_date": "1999-10-15",
  "vote_average": 8.4,
  "popularity": 92.1,
  "genre_ids": [18, 53]
}

Use snake_case field names exactly.
Return valid JSON only, with no markdown or extra text.
''';

    final response = await _client.post(
      Uri.parse('https://api.giga.chat/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'model': dotenv.get('GIGACHAT_MODEL', fallback: 'GigaChat-2'),
        'temperature': 0.2,
        'messages': [
          {'role': 'system', 'content': 'Return valid JSON only.'},
          {'role': 'user', 'content': prompt},
        ],
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'GigaChat request failed: ${response.statusCode} ${response.body}',
      );
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = body['choices'] as List<dynamic>? ?? const [];
    if (choices.isEmpty) {
      return const [];
    }

    final rawContent =
        (choices.first as Map<String, dynamic>)['message']?['content'] ?? '';
    final cleaned = rawContent
        .toString()
        .replaceAll('```json', '')
        .replaceAll('```', '')
        .trim();

    final parsed = jsonDecode(cleaned);
    print(cleaned);
    final items = parsed is List
        ? parsed
        : parsed is Map && parsed['items'] is List
        ? parsed['items']
        : const <dynamic>[];

    return (items as List<dynamic>)
        .map(
          (json) => Movie.fromJson(json as Map<String, dynamic>, contentType),
        )
        .toList();
  }
}
