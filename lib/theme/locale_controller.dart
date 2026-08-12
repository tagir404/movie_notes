import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localePreferenceKey = 'locale';

class LocaleController extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localePreferenceKey);
    _locale = code == null ? null : Locale(code);
  }

  Future<void> setLocale(Locale? locale) async {
    if ((_locale?.languageCode) == (locale?.languageCode)) return;
    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_localePreferenceKey);
    } else {
      await prefs.setString(_localePreferenceKey, locale.languageCode);
    }
  }
}
