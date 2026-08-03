import 'package:flutter/material.dart';
import 'package:movie_notes/screens/movies_screen.dart';
import 'package:movie_notes/screens/trends_screen.dart';
import 'package:movie_notes/screens/tv_shows_screen.dart';
import 'package:movie_notes/screens/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _screens = [
    MoviesScreen(),
    TvShowsScreen(),
    TrendsScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const .all(20),
          child: IndexedStack(index: _selectedIndex, children: _screens),
        ),
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
          NavigationDestination(
            icon: Icon(Icons.local_fire_department),
            label: 'Тренды',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmarks),
            label: 'Сохранённые',
          ),
        ],
      ),
    );
  }
}
