import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:movie_notes/database/app_database.dart';
import 'package:movie_notes/database/favorites_datasource.dart';
import 'package:movie_notes/database/skipped_media_datasource.dart';
import 'package:movie_notes/repositories/favorites_repository.dart';
import 'package:movie_notes/repositories/media_repository.dart';
import 'package:movie_notes/repositories/skipped_media_repository.dart';
import 'package:movie_notes/screens/home_screen.dart';
import 'package:movie_notes/services/media_api_service.dart';
import 'package:movie_notes/theme/theme_mode_controller.dart';
import 'package:movie_notes/theme/locale_controller.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final client = http.Client();
  final apiService = MediaApiService(client);
  final repository = MediaRepository(apiService);
  final favoritesRepository = FavoritesRepository(
    FavoritesLocalDatasource(await AppDatabase.database),
  );
  final skippedMediaRepository = SkippedMediaRepository(
    SkippedMediaLocalDatasource(await AppDatabase.database),
  );
  final themeController = ThemeModeController();
  await themeController.load();
  final localeController = LocaleController();
  await localeController.load();

  await repository.init();

  runApp(
    AppScope(
      mediaApiService: apiService,
      mediaRepository: repository,
      favoritesRepository: favoritesRepository,
      skippedMediaRepository: skippedMediaRepository,
      themeController: themeController,
      localeController: localeController,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = AppScope.of(context).themeController;
    final localeController = AppScope.of(context).localeController;

    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) => AnimatedBuilder(
        animation: localeController,
        builder: (context, _) => MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: localeController.locale,
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
          theme: ThemeData(
            textTheme: GoogleFonts.nunitoTextTheme(),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 7, 7),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            textTheme: GoogleFonts.nunitoTextTheme(
              ThemeData(brightness: Brightness.dark).textTheme,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 7, 7),
              brightness: Brightness.dark,
            ),
          ),
          themeMode: themeController.themeMode,
        ),
      ),
    );
  }
}
