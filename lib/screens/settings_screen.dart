import 'package:flutter/material.dart';
import 'package:movie_notes/screens/skipped_media_screen.dart';
import 'package:movie_notes/widgets/app_scope.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = AppScope.of(context).themeController;

    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Настройки')),
        body: ListView(
          children: [
            const ListTile(
              leading: Icon(Icons.color_lens),
              title: Text('Тема'),
              subtitle: Text('Системная, светлая или тёмная'),
            ),
            RadioGroup<ThemeMode>(
              groupValue: themeController.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) themeController.setThemeMode(value);
              },
              child: const Column(
                children: [
                  RadioListTile(
                    title: Text('Системная'),
                    value: ThemeMode.system,
                  ),
                  RadioListTile(title: Text('Светлая'), value: ThemeMode.light),
                  RadioListTile(title: Text('Темная'), value: ThemeMode.dark),
                ],
              ),
            ),
            const Divider(),
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
      ),
    );
  }
}
