import 'package:movie_notes/enums/media_content_type.dart';

enum MediaSortOption {
  popularity,
  newest;

  String get label {
    switch (this) {
      case MediaSortOption.popularity:
        return 'По популярности';
      case MediaSortOption.newest:
        return 'По новизне';
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
