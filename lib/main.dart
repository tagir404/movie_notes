// import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:movie_match/constants/api_constants.dart';
import 'package:movie_match/database/app_database.dart';
import 'package:movie_match/database/favorites_datasource.dart';
import 'package:movie_match/database/skipped_media_datasource.dart';
import 'package:movie_match/repositories/favorites_repository.dart';
import 'package:movie_match/repositories/media_repository.dart';
import 'package:movie_match/repositories/skipped_media_repository.dart';
import 'package:movie_match/screens/home_screen.dart';
import 'package:movie_match/services/ai_search_service.dart';
import 'package:movie_match/services/media_api_service.dart';
import 'package:movie_match/theme/theme_mode_controller.dart';
import 'package:movie_match/theme/locale_controller.dart';
import 'package:movie_match/widgets/app_scope.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final client = http.Client();
  final apiService = MediaApiService(client);
  final localeController = LocaleController();
  await localeController.load();
  apiService.language = ApiConstants.languageForLocaleCode(
    localeController.locale.languageCode,
  );
  final repository = MediaRepository(apiService);
  final favoritesRepository = FavoritesRepository(
    FavoritesLocalDatasource(await AppDatabase.database),
  );
  final skippedMediaRepository = SkippedMediaRepository(
    SkippedMediaLocalDatasource(await AppDatabase.database),
  );
  final aiSearchService = await AiSearchService.create();

  final themeController = ThemeModeController();
  await themeController.load();

  await repository.init();

  localeController.addListener(() {
    apiService.language = ApiConstants.languageForLocaleCode(
      localeController.locale.languageCode,
    );
  });

  runApp(
    AppScope(
      mediaApiService: apiService,
      mediaRepository: repository,
      favoritesRepository: favoritesRepository,
      skippedMediaRepository: skippedMediaRepository,
      aiSearchService: aiSearchService,
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
            // textTheme: GoogleFonts.nunitoTextTheme(),
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            // textTheme: GoogleFonts.nunitoTextTheme(
            //   ThemeData(brightness: Brightness.dark).textTheme,
            // ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.grey,
              brightness: Brightness.dark,
            ),
          ),
          themeMode: themeController.themeMode,
        ),
      ),
    );
  }
}
