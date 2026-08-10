import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/models/genre.dart';
import 'package:movie_notes/models/movie_details.dart';
import 'package:movie_notes/models/movie_video.dart';
import 'package:movie_notes/services/media_api_service.dart';

class MediaRepository {
  MediaRepository(this.apiService);

  final MediaApiService apiService;

  List<Genre>? _movieGenres;
  List<Genre>? _tvGenres;

  Future<void> init() async {
    _movieGenres = await apiService.fetchGenres(.movie);
    _tvGenres = await apiService.fetchGenres(.tvShow);
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

  Future<List<MovieVideo>> getMediaVideos(int id, MediaContentType type) async {
    final response = await apiService.fetchMediaVideos(id, type);

    final rawVideos = (response['results'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    final videos = rawVideos
        .where((video) => (video['site'] as String?)?.toLowerCase() == 'youtube')
        .map((video) => MovieVideo.fromJson(video))
        .toList();

    if (videos.isNotEmpty) {
      videos.sort((a, b) {
        if (a.official == b.official) return 0;
        return a.official ? -1 : 1;
      });
    }

    return videos;
  }
}
