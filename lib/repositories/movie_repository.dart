import 'package:movie_notes/models/genre.dart';
import 'package:movie_notes/services/movie_api_service.dart';

class MovieRepository {
  MovieRepository(this.apiService);

  final MovieApiService apiService;

  List<Genre>? _genres;

  Future<void> init() async {
    _genres = await apiService.fetchGenres();
  }

  List<Genre> get genres {
    if (_genres == null) {
      throw StateError('MovieRepository is not initialized');
    }

    return _genres!;
  }
}
