import 'package:flutter/material.dart';
import 'package:movie_notes/screens/skipped_media_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.skip_next),
            title: const Text('Пропущенные'),
            subtitle: const Text('Список пропущенных фильмов'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SkippedMediaScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
