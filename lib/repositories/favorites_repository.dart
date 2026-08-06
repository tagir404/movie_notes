import 'package:movie_notes/database/favorites_datasource.dart';
import 'package:movie_notes/models/movie.dart';

class FavoritesRepository {
  FavoritesRepository(this.local);

  final FavoritesLocalDatasource local;

  Future<void> addFavorite(Movie movie) => local.addFavorite(movie);

  Future<void> removeFavorite(int movieId) => local.removeFavorite(movieId);

  Future<List<Movie>> getFavorites() => local.getFavorites();
}
