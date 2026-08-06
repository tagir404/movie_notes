import 'package:flutter/material.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/screens/favorites_screen.dart';
import 'package:movie_notes/screens/media_screen.dart';
import 'package:movie_notes/screens/settings_screen.dart';

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
        return 'Каталог';
      case 1:
        return 'Сохранённые';
      default:
        return '';
    }
  }

  static const _screens = [
    MediaScreen(type: MediaContentType.movie, emptyMessage: 'Каталог пуст'),
    FavoritesScreen(),
  ];

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
      destinations: const [
        NavigationDestination(icon: Icon(Icons.movie), label: 'Каталог'),
        NavigationDestination(
          icon: Icon(Icons.bookmarks),
          label: 'Сохранённые',
        ),
      ],
    ),
  );
}
