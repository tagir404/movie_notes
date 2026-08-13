// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get home_catalog => 'Каталог';

  @override
  String get home_saved => 'Сохранённые';

  @override
  String get favorites_empty => 'Нет сохраненных элементов.';

  @override
  String get settings_title => 'Настройки';

  @override
  String get settings_theme_title => 'Тема';

  @override
  String get settings_theme_system => 'Системная';

  @override
  String get settings_theme_light => 'Светлая';

  @override
  String get settings_theme_dark => 'Тёмная';

  @override
  String get settings_skipped => 'Пропущенные';

  @override
  String get settings_skipped_subtitle => 'Список пропущенных фильмов';

  @override
  String get skipped_title => 'Пропущенные';

  @override
  String get skipped_empty => 'Список пропущенных фильмов пуст';

  @override
  String get skipped_restore => 'Вернуть';

  @override
  String get movie_cast_title => 'Актёрский состав';

  @override
  String get movie_cast_load_error => 'Не удалось загрузить список актёров.';

  @override
  String get movie_cast_not_found => 'Актёры не найдены.';

  @override
  String get movie_cast_unknown_role => 'Роль неизвестна';

  @override
  String get action_delete => 'Удалить';

  @override
  String get action_swipe => 'Листать';

  @override
  String get dialog_confirm => 'Подтвердить';

  @override
  String get dialog_cancel => 'Отмена';

  @override
  String get filter_reset => 'Сбросить';

  @override
  String get filter_apply => 'Применить';

  @override
  String get skipped_restore_all_title => 'Вернуть все фильмы?';

  @override
  String get skipped_restore_all_content =>
      'Все пропущенные фильмы будут возвращены в каталог.';

  @override
  String get skipped_restore_all_tooltip => 'Вернуть все';

  @override
  String get filter_genres => 'Жанры';

  @override
  String get filter_choose_genres => 'Выберите жанры';

  @override
  String get media_sort_popularity => 'По популярности';

  @override
  String get media_sort_newest => 'По новизне';

  @override
  String get media_type_movies => 'Фильмы';

  @override
  String get media_type_tv_shows => 'Сериалы';

  @override
  String get media_empty => 'Ничего не найдено';

  @override
  String get action_skip => 'Пропустить';

  @override
  String get action_save => 'Сохранить';

  @override
  String get description_missing => 'Описание отсутствует.';

  @override
  String get no_available_videos => 'Нет доступных видео.';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get runtime_minutes_abbreviation => 'мин';

  @override
  String get runtime_hours_abbreviation => 'ч';

  @override
  String get ratings_label => 'оценок';

  @override
  String get settings_language_title => 'Язык';

  @override
  String get language_system => 'Системный';

  @override
  String get language_en => 'English';

  @override
  String get language_ru => 'Русский';
}
