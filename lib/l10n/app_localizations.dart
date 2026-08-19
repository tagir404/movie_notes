import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @home_catalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get home_catalog;

  /// No description provided for @home_saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get home_saved;

  /// No description provided for @favorites_empty.
  ///
  /// In en, this message translates to:
  /// **'No saved movies'**
  String get favorites_empty;

  /// No description provided for @settings_title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings_title;

  /// No description provided for @settings_theme_title.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_theme_title;

  /// No description provided for @settings_theme_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settings_theme_system;

  /// No description provided for @settings_theme_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settings_theme_light;

  /// No description provided for @settings_theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settings_theme_dark;

  /// No description provided for @settings_skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get settings_skipped;

  /// No description provided for @settings_skipped_subtitle.
  ///
  /// In en, this message translates to:
  /// **'List of skipped movies'**
  String get settings_skipped_subtitle;

  /// No description provided for @skipped_title.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped_title;

  /// No description provided for @skipped_empty.
  ///
  /// In en, this message translates to:
  /// **'Skipped movies list is empty'**
  String get skipped_empty;

  /// No description provided for @skipped_restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get skipped_restore;

  /// No description provided for @movie_cast_title.
  ///
  /// In en, this message translates to:
  /// **'Cast'**
  String get movie_cast_title;

  /// No description provided for @movie_cast_load_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cast list.'**
  String get movie_cast_load_error;

  /// No description provided for @movie_cast_not_found.
  ///
  /// In en, this message translates to:
  /// **'Actors not found.'**
  String get movie_cast_not_found;

  /// No description provided for @movie_cast_unknown_role.
  ///
  /// In en, this message translates to:
  /// **'Unknown role'**
  String get movie_cast_unknown_role;

  /// No description provided for @action_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get action_delete;

  /// No description provided for @action_swipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe'**
  String get action_swipe;

  /// No description provided for @dialog_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get dialog_confirm;

  /// No description provided for @dialog_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialog_cancel;

  /// No description provided for @filter_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get filter_reset;

  /// No description provided for @filter_reset_all.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get filter_reset_all;

  /// No description provided for @filter_apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get filter_apply;

  /// No description provided for @skipped_restore_all_title.
  ///
  /// In en, this message translates to:
  /// **'Restore all movies?'**
  String get skipped_restore_all_title;

  /// No description provided for @skipped_restore_all_content.
  ///
  /// In en, this message translates to:
  /// **'All skipped movies will be restored to the catalog.'**
  String get skipped_restore_all_content;

  /// No description provided for @skipped_restore_all_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Restore all'**
  String get skipped_restore_all_tooltip;

  /// No description provided for @filter_country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get filter_country;

  /// No description provided for @filter_choose_country.
  ///
  /// In en, this message translates to:
  /// **'Choose country'**
  String get filter_choose_country;

  /// No description provided for @filter_genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get filter_genres;

  /// No description provided for @filter_choose_genres.
  ///
  /// In en, this message translates to:
  /// **'Choose genres'**
  String get filter_choose_genres;

  /// No description provided for @media_sort_popularity.
  ///
  /// In en, this message translates to:
  /// **'By popularity'**
  String get media_sort_popularity;

  /// No description provided for @media_sort_newest.
  ///
  /// In en, this message translates to:
  /// **'By newest'**
  String get media_sort_newest;

  /// No description provided for @media_sort_rating.
  ///
  /// In en, this message translates to:
  /// **'By rating'**
  String get media_sort_rating;

  /// No description provided for @media_type_movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get media_type_movies;

  /// No description provided for @media_type_tv_shows.
  ///
  /// In en, this message translates to:
  /// **'TV Shows'**
  String get media_type_tv_shows;

  /// No description provided for @media_empty.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get media_empty;

  /// No description provided for @media_empty_filtered_hint.
  ///
  /// In en, this message translates to:
  /// **'Change the filter settings'**
  String get media_empty_filtered_hint;

  /// No description provided for @action_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get action_skip;

  /// No description provided for @action_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get action_save;

  /// No description provided for @description_missing.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get description_missing;

  /// No description provided for @trailer_title.
  ///
  /// In en, this message translates to:
  /// **'Trailer'**
  String get trailer_title;

  /// No description provided for @no_available_videos.
  ///
  /// In en, this message translates to:
  /// **'No available videos.'**
  String get no_available_videos;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @runtime_minutes_abbreviation.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get runtime_minutes_abbreviation;

  /// No description provided for @runtime_hours_abbreviation.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get runtime_hours_abbreviation;

  /// No description provided for @ratings_label.
  ///
  /// In en, this message translates to:
  /// **'ratings'**
  String get ratings_label;

  /// No description provided for @settings_language_title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language_title;

  /// No description provided for @language_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get language_system;

  /// No description provided for @language_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_en;

  /// No description provided for @language_ru.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get language_ru;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
