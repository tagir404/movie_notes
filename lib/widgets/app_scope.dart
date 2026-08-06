import 'package:flutter/widgets.dart';
import 'package:movie_notes/repositories/favorite_repository.dart';
import 'package:movie_notes/repositories/media_repository.dart';
import 'package:movie_notes/repositories/skipped_media_repository.dart';
import 'package:movie_notes/services/media_api_service.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    required this.mediaApiService,
    required this.mediaRepository,
    required this.favoriteRepository,
    required this.skippedMediaRepository,
    required super.child,
    super.key,
  });

  final MediaApiService mediaApiService;
  final MediaRepository mediaRepository;
  final FavoriteRepository favoriteRepository;
  final SkippedMediaRepository skippedMediaRepository;

  static AppScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppScope>();
  }

  static AppScope of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'AppScope not found');
    return result!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => false;
}
