import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModePreferenceKey = 'theme_mode';

class ThemeModeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getString(_themeModePreferenceKey);
    _themeMode = _themeModeFromString(savedValue) ?? ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModePreferenceKey, _themeModeToString(mode));
  }
}

String _themeModeToString(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return 'system';
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
  }
}

ThemeMode? _themeModeFromString(String? value) {
  switch (value) {
    case 'system':
      return ThemeMode.system;
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return null;
  }
}
