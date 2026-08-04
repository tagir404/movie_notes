import 'package:flutter/material.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import 'package:movie_notes/screens/favorites_screen.dart';
import 'package:movie_notes/screens/media_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _screens = [
    MediaScreen(
      type: MediaContentType.movie,
      emptyMessage: 'Контент не найден',
    ),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.movie), label: 'Контент'),
          NavigationDestination(
            icon: Icon(Icons.bookmarks),
            label: 'Сохранённые',
          ),
        ],
      ),
    );
  }
}
