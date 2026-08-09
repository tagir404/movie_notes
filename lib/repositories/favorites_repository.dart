import 'package:flutter/foundation.dart';
import 'package:movie_notes/database/favorites_datasource.dart';
import 'package:movie_notes/models/movie.dart';

class FavoritesRepository {
  FavoritesRepository(this.local);

  final FavoritesLocalDatasource local;
  final ValueNotifier<List<Movie>> favorites = ValueNotifier<List<Movie>>(
    const [],
  );

  Future<void> addFavorite(Movie movie) async {
    await local.addFavorite(movie);
    await refreshFavorites();
  }

  Future<void> removeFavorite(int movieId) async {
    await local.removeFavorite(movieId);
    await refreshFavorites();
  }

  Future<List<Movie>> getFavorites() async {
    final items = await local.getFavorites();
    favorites.value = items;
    return items;
  }

  Future<void> refreshFavorites() => getFavorites();
}
