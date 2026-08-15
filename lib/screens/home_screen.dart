import 'package:material_ui/material_ui.dart';
import 'package:movie_notes/screens/favorites_screen.dart';
import 'package:movie_notes/screens/media_screen.dart';
import 'package:movie_notes/screens/settings_screen.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  String get _title {
    switch (_selectedIndex) {
      case 0:
        return AppLocalizations.of(context)!.home_catalog;
      case 1:
        return AppLocalizations.of(context)!.home_saved;
      default:
        return '';
    }
  }

  static const _screens = [MediaScreen(), FavoritesScreen()];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_title),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          icon: const Icon(Icons.settings),
        ),
      ],
      actionsPadding: const EdgeInsets.only(right: 8),
    ),
    body: IndexedStack(index: _selectedIndex, children: _screens),
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
      ],
    ),
  );
}
