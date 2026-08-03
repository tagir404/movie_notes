import 'package:movie_notes/database/favorite_datasource.dart';
import 'package:movie_notes/models/movie.dart';

class FavoriteRepository {
  FavoriteRepository(this.local);

  final FavoriteLocalDatasource local;

  Future<void> addFavorite(Movie movie) => local.addFavorite(movie);

  Future<void> removeFavorite(int movieId) => local.removeFavorite(movieId);

  Future<List<Movie>> getFavorites() => local.getFavorites();
}
