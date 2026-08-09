import 'dart:convert';

import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:sqflite/sqflite.dart';

class FavoritesLocalDatasource {
  FavoritesLocalDatasource(this.db);

  final Database db;

  Future<void> addFavorite(Movie movie) async {
    await db.insert('favorites', {
      'id': movie.id,
      'type': movie.type.name,
      'title': movie.title,
      'overview': movie.overview,
      'poster_path': movie.posterPath,
      'backdrop_path': movie.backdropPath,
      'release_date': movie.releaseDate,
      'vote_average': movie.voteAverage,
      'genre_ids': jsonEncode(movie.genreIds),
      'created_at': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<void> removeFavorite(int movieId) async {
    await db.delete('favorites', where: 'id = ?', whereArgs: [movieId]);
  }

  Future<List<Movie>> getFavorites() async {
    final List<Map<String, dynamic>> maps = await db.query('favorites');

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
        voteAverage: maps[i]['vote_average'],
        genreIds: maps[i]['genre_ids'] == null
            ? []
            : (jsonDecode(maps[i]['genre_ids']) as List)
                  .map((e) => e as int)
                  .toList(),
      ),
    );
  }
}
