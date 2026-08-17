// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get home_catalog => 'Catalog';

  @override
  String get home_saved => 'Saved';

  @override
  String get favorites_empty => 'No saved items.';

  @override
  String get settings_title => 'Settings';

  @override
  String get settings_theme_title => 'Theme';

  @override
  String get settings_theme_system => 'System';

  @override
  String get settings_theme_light => 'Light';

  @override
  String get settings_theme_dark => 'Dark';

  @override
  String get settings_skipped => 'Skipped';

  @override
  String get settings_skipped_subtitle => 'List of skipped movies';

  @override
  String get skipped_title => 'Skipped';

  @override
  String get skipped_empty => 'Skipped movies list is empty';

  @override
  String get skipped_restore => 'Restore';

  @override
  String get movie_cast_title => 'Cast';

  @override
  String get movie_cast_load_error => 'Failed to load cast list.';

  @override
  String get movie_cast_not_found => 'Actors not found.';

  @override
  String get movie_cast_unknown_role => 'Unknown role';

  @override
  String get action_delete => 'Delete';

  @override
  String get action_swipe => 'Swipe';

  @override
  String get dialog_confirm => 'Confirm';

  @override
  String get dialog_cancel => 'Cancel';

  @override
  String get filter_reset => 'Reset';

  @override
  String get filter_apply => 'Apply';

  @override
  String get skipped_restore_all_title => 'Restore all movies?';

  @override
  String get skipped_restore_all_content =>
      'All skipped movies will be restored to the catalog.';

  @override
  String get skipped_restore_all_tooltip => 'Restore all';

  @override
  String get filter_genres => 'Genres';

  @override
  String get filter_choose_genres => 'Choose genres';

  @override
  String get media_sort_popularity => 'By popularity';

  @override
  String get media_sort_newest => 'By newest';

  @override
  String get media_sort_rating => 'By rating';

  @override
  String get media_type_movies => 'Movies';

  @override
  String get media_type_tv_shows => 'TV Shows';

  @override
  String get media_empty => 'Nothing found';

  @override
  String get action_skip => 'Skip';

  @override
  String get action_save => 'Save';

  @override
  String get description_missing => 'No description available.';

  @override
  String get trailer_title => 'Trailer';

  @override
  String get no_available_videos => 'No available videos.';

  @override
  String get unknown => 'Unknown';

  @override
  String get runtime_minutes_abbreviation => 'min';

  @override
  String get runtime_hours_abbreviation => 'h';

  @override
  String get ratings_label => 'ratings';

  @override
  String get settings_language_title => 'Language';

  @override
  String get language_system => 'System';

  @override
  String get language_en => 'English';

  @override
  String get language_ru => 'Русский';
}
