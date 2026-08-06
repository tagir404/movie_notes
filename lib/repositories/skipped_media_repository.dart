import 'package:flutter/foundation.dart';
import 'package:movie_notes/database/skipped_media_datasource.dart';
import 'package:movie_notes/models/movie.dart';

class SkippedMediaRepository {
  SkippedMediaRepository(this.local);

  final SkippedMediaLocalDatasource local;
  final ValueNotifier<List<Movie>> skippedMedia = ValueNotifier<List<Movie>>(
    const [],
  );

  Future<void> addSkippedMedia(Movie movie) async {
    await local.addSkippedMedia(movie);
    await refreshSkippedMedia();
  }

  Future<void> removeSkippedMedia(int movieId) async {
    await local.removeSkippedMedia(movieId);
    await refreshSkippedMedia();
  }

  Future<void> restoreAllSkippedMedia() async {
    final items = await local.getSkippedMedia();

    for (final item in items) {
      await local.removeSkippedMedia(item.id);
    }

    await refreshSkippedMedia();
  }

  Future<List<Movie>> getSkippedMedia() async {
    final items = await local.getSkippedMedia();
    skippedMedia.value = items;
    return items;
  }

  Future<void> refreshSkippedMedia() => getSkippedMedia();
}
