import 'package:flutter/material.dart';
import 'package:movie_notes/screens/skipped_media_screen.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = AppScope.of(context).themeController;

    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settings_title),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: Text(AppLocalizations.of(context)!.settings_theme_title),
              subtitle: Text(
                AppLocalizations.of(context)!.settings_theme_subtitle,
              ),
            ),
            RadioGroup<ThemeMode>(
              groupValue: themeController.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) themeController.setThemeMode(value);
              },
              child: Column(
                children: [
                  RadioListTile(
                    title: Text(
                      AppLocalizations.of(context)!.settings_theme_system,
                    ),
                    value: ThemeMode.system,
                  ),
                  RadioListTile(
                    title: Text(
                      AppLocalizations.of(context)!.settings_theme_light,
                    ),
                    value: ThemeMode.light,
                  ),
                  RadioListTile(
                    title: Text(
                      AppLocalizations.of(context)!.settings_theme_dark,
                    ),
                    value: ThemeMode.dark,
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.skip_next),
              title: Text(AppLocalizations.of(context)!.settings_skipped),
              subtitle: Text(
                AppLocalizations.of(context)!.settings_skipped_subtitle,
              ),
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
