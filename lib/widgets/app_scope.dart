import 'package:flutter/widgets.dart';
import 'package:movie_notes/repositories/media_repository.dart';
import 'package:movie_notes/services/movie_api_service.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    required this.movieApiService,
    required this.movieRepository,
    required super.child,
    super.key,
  });

  final MediaApiService movieApiService;
  final MediaRepository movieRepository;

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
