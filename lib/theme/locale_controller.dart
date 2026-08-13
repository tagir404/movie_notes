import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _localePreferenceKey = 'locale';
const _russianLocale = Locale('ru');
const _englishLocale = Locale('en');

class LocaleController extends ChangeNotifier {
  Locale _locale = _englishLocale;

  Locale get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localePreferenceKey);
    _locale = code == null
        ? _localeFromSystem()
        : _supportedLocaleForLanguageCode(code);
  }

  Future<void> setLocale(Locale locale) async {
    final supportedLocale = _supportedLocaleForLanguageCode(
      locale.languageCode,
    );
    if (_locale.languageCode == supportedLocale.languageCode) return;
    _locale = supportedLocale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localePreferenceKey, supportedLocale.languageCode);
  }

  static Locale _localeFromSystem() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;

    return _supportedLocaleForLanguageCode(systemLocale.languageCode);
  }

  static Locale _supportedLocaleForLanguageCode(String languageCode) =>
      languageCode == _russianLocale.languageCode
      ? _russianLocale
      : _englishLocale;
}
