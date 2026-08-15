import 'package:material_ui/material_ui.dart';
import 'package:movie_notes/screens/skipped_media_screen.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _onLanguageChanged(Locale? value) {
    if (value == null) return;
    final localeController = AppScope.of(context).localeController;

    localeController.setLocale(value);
  }

  @override
  Widget build(BuildContext context) {
    final themeController = AppScope.of(context).themeController;
    final localeContoller = AppScope.of(context).localeController;

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
            ),
            RadioGroup<ThemeMode>(
              groupValue: themeController.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) themeController.setThemeMode(value);
              },
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: Text(
                      AppLocalizations.of(context)!.settings_theme_system,
                    ),
                    value: ThemeMode.system,
                  ),
                  RadioListTile<ThemeMode>(
                    title: Text(
                      AppLocalizations.of(context)!.settings_theme_light,
                    ),
                    value: ThemeMode.light,
                  ),
                  RadioListTile<ThemeMode>(
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
              leading: const Icon(Icons.language),
              title: Text(
                AppLocalizations.of(context)!.settings_language_title,
              ),
            ),
            RadioGroup<Locale>(
              groupValue: localeContoller.locale,
              onChanged: (Locale? value) {
                _onLanguageChanged(value);
              },
              child: Column(
                children: [
                  RadioListTile<Locale>(
                    title: Text(AppLocalizations.of(context)!.language_en),
                    value: const Locale('en'),
                  ),
                  RadioListTile<Locale>(
                    title: Text(AppLocalizations.of(context)!.language_ru),
                    value: const Locale('ru'),
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
