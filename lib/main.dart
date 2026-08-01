import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:movie_notes/repositories/media_repository.dart';
import 'package:movie_notes/screens/movies_screen.dart';
import 'package:movie_notes/screens/tv_shows_screen.dart';
import 'package:movie_notes/services/movie_api_service.dart';
import 'package:movie_notes/widgets/app_scope.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  final client = http.Client();
  final apiService = MediaApiService(client);
  final repository = MediaRepository(apiService);

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
      home: const HomeScreen(),
      theme: ThemeData(textTheme: GoogleFonts.nunitoTextTheme()),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _screens = [MoviesScreen(), TvShowsScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const .all(25),
        child: IndexedStack(index: _selectedIndex, children: _screens),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.movie), label: 'Фильмы'),
          NavigationDestination(icon: Icon(Icons.tv), label: 'Сериалы'),
        ],
      ),
    );
  }
}
