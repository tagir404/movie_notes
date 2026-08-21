import 'package:material_ui/material_ui.dart';
import 'package:movie_match/screens/favorites_screen.dart';
import 'package:movie_match/screens/media_screen.dart';
import 'package:movie_match/screens/settings_screen.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _screens = [MediaScreen(), FavoritesScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: IndexedStack(index: _selectedIndex, children: _screens),
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.movie),
          label: AppLocalizations.of(context)!.home_catalog,
        ),
        NavigationDestination(
          icon: const Icon(Icons.bookmarks),
          label: AppLocalizations.of(context)!.home_saved,
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings),
          label: AppLocalizations.of(context)!.settings_title,
        ),
      ],
    ),
  );
}
