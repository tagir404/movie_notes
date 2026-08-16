import 'package:flutter/widgets.dart';
import 'package:movie_match/repositories/favorites_repository.dart';
import 'package:movie_match/repositories/media_repository.dart';
import 'package:movie_match/repositories/skipped_media_repository.dart';
import 'package:movie_match/services/media_api_service.dart';
import 'package:movie_match/theme/theme_mode_controller.dart';
import 'package:movie_match/theme/locale_controller.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    required this.mediaApiService,
    required this.mediaRepository,
    required this.favoritesRepository,
    required this.skippedMediaRepository,
    required this.themeController,
    required this.localeController,
    required super.child,
    super.key,
  });

  final MediaApiService mediaApiService;
  final MediaRepository mediaRepository;
  final FavoritesRepository favoritesRepository;
  final SkippedMediaRepository skippedMediaRepository;
  final ThemeModeController themeController;
  final LocaleController localeController;

  static AppScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>();

  static AppScope of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'AppScope not found');
    return result!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => false;
}
