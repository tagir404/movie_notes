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
import 'package:movie_notes/widgets/app_scope.dart';

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

  await repository.init();

  runApp(
    AppScope(
      mediaApiService: apiService,
      mediaRepository: repository,
      favoritesRepository: favoritesRepository,
      skippedMediaRepository: skippedMediaRepository,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const HomeScreen(),
    theme: ThemeData(
      textTheme: GoogleFonts.nunitoTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 255, 7, 7),
      ),
    ),
  );
}
