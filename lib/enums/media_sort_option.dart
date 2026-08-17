import 'package:flutter/widgets.dart';
import 'package:movie_match/enums/media_content_type.dart';
import '../l10n/app_localizations.dart';

enum MediaSortOption {
  popularity,
  newest,
  rating;

  String label(BuildContext context) {
    final loc = AppLocalizations.of(context);
    switch (this) {
      case .popularity:
        return loc!.media_sort_popularity;
      case .newest:
        return loc!.media_sort_newest;
      case .rating:
        return loc!.media_sort_rating;
    }
  }

  String apiValueFor(MediaContentType type) {
    switch (this) {
      case .popularity:
        return 'popularity.desc';
      case .newest:
        return type == .movie ? 'release_date.desc' : 'first_air_date.desc';
      case .rating:
        return 'vote_average.desc';
    }
  }
}
