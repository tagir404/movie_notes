import 'package:movie_match/enums/media_content_type.dart';
import 'package:movie_match/models/country.dart';
import 'package:movie_match/models/genre.dart';
import 'package:movie_match/models/movie_cast_member.dart';
import 'package:movie_match/models/movie_details.dart';
import 'package:movie_match/services/media_api_service.dart';

class MediaRepository {
  MediaRepository(this.apiService);

  final MediaApiService apiService;

  List<Genre>? _movieGenres;
  List<Genre>? _tvGenres;
  List<Country>? _countries;

  Future<void> init() async {
    _movieGenres = await apiService.fetchGenres(.movie);
    _tvGenres = await apiService.fetchGenres(.tvShow);
    _countries = await apiService.fetchCountries();
  }

  Future<void> refreshLocalizedData() async {
    _detailsCache.clear();
    await init();
  }

  List<Genre> get movieGenres {
    if (_movieGenres == null) {
      throw StateError('MediaRepository is not initialized');
    }

    return _movieGenres!;
  }

  List<Genre> get tvGenres {
    if (_tvGenres == null) {
      throw StateError('MediaRepository is not initialized');
    }

    return _tvGenres!;
  }

  List<Country> get countries {
    if (_countries == null) {
      throw StateError('MediaRepository is not initialized');
    }

    return _countries!;
  }

  List<Genre> genres(MediaContentType type) => switch (type) {
    .movie => movieGenres,
    .tvShow => tvGenres,
  };

  final Map<String, MovieDetails> _detailsCache = {};

  Future<MovieDetails> getMovieDetails(int id, MediaContentType type) async {
    final cacheKey = '$type-$id';

    final cachedMovie = _detailsCache[cacheKey];

    if (cachedMovie != null) return cachedMovie;

    final movieDetails = await apiService.fetchMediaDetails(id, type);

    _detailsCache[cacheKey] = movieDetails;

    return movieDetails;
  }

  Future<List<MovieCastMember>> getMediaCredits(
    int id,
    MediaContentType type,
  ) async => apiService.fetchMediaCredits(id, type);

  Future<String?> getTrailerKey(int id, MediaContentType type) async =>
      apiService.getTrailerKey(id, type);
}
