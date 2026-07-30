import 'package:flutter/widgets.dart';
import 'package:movie_notes/repositories/movie_repository.dart';
import 'package:movie_notes/services/movie_api_service.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    required this.movieApiService,
    required this.movieRepository,
    required super.child,
    super.key,
  });

  final MovieApiService movieApiService;
  final MovieRepository movieRepository;

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
