import 'package:movie_match/enums/media_content_type.dart';
import 'package:movie_match/enums/media_sort_option.dart';
import 'package:movie_match/models/movie.dart';

List<Movie> filterMedia({
  required List<Movie> movies,
  required MediaContentType type,
  required List<int> genreIds,
}) => movies.where((movie) => movie.type == type).where((movie) {
  if (genreIds.isEmpty) return true;

  return movie.genreIds.any(genreIds.contains);
}).toList();

void sortMedia(List<Movie> movies, MediaSortOption sortOption) {
  movies.sort((a, b) {
    switch (sortOption) {
      case .popularity:
        return b.popularity.compareTo(a.popularity);

      case .newest:
        return b.releaseDate.compareTo(a.releaseDate);

      case .rating:
        return b.voteAverage.compareTo(a.voteAverage);
    }
  });
}
