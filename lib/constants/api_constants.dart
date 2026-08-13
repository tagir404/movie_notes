abstract final class ApiConstants {
  static const baseUrl = 'api.themoviedb.org';

  static String languageForLocaleCode(String languageCode) => switch (languageCode) {
        'ru' => 'ru-RU',
        _ => 'en-US',
      };
}
