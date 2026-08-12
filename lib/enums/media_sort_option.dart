import 'package:flutter/widgets.dart';
import 'package:movie_notes/enums/media_content_type.dart';
import '../l10n/app_localizations.dart';

enum MediaSortOption {
  popularity,
  newest;

  String label(BuildContext context) {
    final loc = AppLocalizations.of(context);
    switch (this) {
      case MediaSortOption.popularity:
        return loc!.media_sort_popularity;
      case MediaSortOption.newest:
        return loc!.media_sort_newest;
    }
  }

  String apiValueFor(MediaContentType type) {
    switch (this) {
      case MediaSortOption.popularity:
        return 'popularity.desc';
      case MediaSortOption.newest:
        return type == MediaContentType.movie
            ? 'release_date.desc'
            : 'first_air_date.desc';
    }
  }
}
