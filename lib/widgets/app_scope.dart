import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:movie_notes/services/movie_api_service.dart';

class AppScope extends InheritedWidget {
  AppScope({required super.child, super.key})
    : movieApiService = MovieApiService(http.Client());

  final MovieApiService movieApiService;

  static AppScope read(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<AppScope>();

    assert(element != null, 'AppScope not found');

    return element!.widget as AppScope;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => false;
}
