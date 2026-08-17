import 'dart:convert';

import 'package:movie_match/enums/media_content_type.dart';
import 'package:movie_match/models/movie.dart';
import 'package:sqflite/sqflite.dart';

class SkippedMediaLocalDatasource {
  SkippedMediaLocalDatasource(this.db);

  final Database db;

  Future<void> addSkippedMedia(Movie movie) async {
    await db.insert('skipped_media', {
      'id': movie.id,
      'type': movie.type.name,
      'title': movie.title,
      'overview': movie.overview,
      'poster_path': movie.posterPath,
      'backdrop_path': movie.backdropPath,
      'release_date': movie.releaseDate,
      'vote_average': movie.voteAverage,
      'popularity': movie.popularity,
      'genre_ids': jsonEncode(movie.genreIds),
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeSkippedMedia(int movieId) async {
    await db.delete('skipped_media', where: 'id = ?', whereArgs: [movieId]);
  }

  Future<List<Movie>> getSkippedMedia() async {
    final List<Map<String, dynamic>> maps = await db.query('skipped_media');

    return List.generate(
      maps.length,
      (i) => Movie(
        id: maps[i]['id'],
        type: MediaContentType.values.byName(maps[i]['type']),
        title: maps[i]['title'],
        overview: maps[i]['overview'],
        posterPath: maps[i]['poster_path'],
        backdropPath: maps[i]['backdrop_path'],
        releaseDate: maps[i]['release_date'],
        voteAverage: (maps[i]['vote_average'] as num).toDouble(),
        popularity: (maps[i]['popularity'] as num).toDouble(),
        genreIds: maps[i]['genre_ids'] == null
            ? []
            : (jsonDecode(maps[i]['genre_ids']) as List)
                  .map((e) => e as int)
                  .toList(),
      ),
    );
  }
}
