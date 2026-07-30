import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_notes/repositories/movie_repository.dart';
import 'package:movie_notes/services/movie_api_service.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:movie_notes/widgets/movies.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final client = http.Client();
  final apiService = MovieApiService(client);
  final repository = MovieRepository(apiService);

  await repository.init();

  runApp(
    AppScope(
      movieApiService: apiService,
      movieRepository: repository,
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Padding(padding: .all(25), child: Movies()),
      ),
      theme: ThemeData(textTheme: GoogleFonts.nunitoTextTheme()),
    );
  }
}
