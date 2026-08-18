import 'package:flutter/widgets.dart';
import 'package:movie_match/enums/media_content_type.dart';
import 'package:movie_match/enums/media_sort_option.dart';
import 'package:movie_match/widgets/app_scope.dart';
import 'package:movie_match/widgets/filters/media_genre_filter.dart';
import 'package:movie_match/widgets/filters/media_sort_filter.dart';
import 'package:movie_match/widgets/filters/media_type_filter.dart';

class MediaFilters extends StatelessWidget {
  const MediaFilters({
    required this.selectedType,
    required this.onTypeChanged,
    required this.selectedSort,
    required this.selectedGenres,
    required this.onGenresChanged,
    required this.onSortChanged,
    // required this.selectedCountry,
    // required this.onCountryChanged,
    super.key,
  });

  final MediaContentType selectedType;
  final ValueChanged<MediaContentType> onTypeChanged;
  final List<int> selectedGenres;
  final ValueChanged<List<int>> onGenresChanged;
  final MediaSortOption selectedSort;
  final ValueChanged<MediaSortOption> onSortChanged;
  // final String? selectedCountry;
  // final ValueChanged<String?> onCountryChanged;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 12,
    runSpacing: 12,
    alignment: .spaceBetween,
    children: [
      MediaSortFilter(selectedSort: selectedSort, onChanged: onSortChanged),
      MediaGenreFilter(
        genres: AppScope.of(context).mediaRepository.genres(selectedType),
        selectedGenres: selectedGenres,
        onChanged: onGenresChanged,
      ),
      MediaTypeFilter(selectedType: selectedType, onChanged: onTypeChanged),
      // Фильтр по странам
      // MediaCountryFilter(
      //   countries: AppScope.of(context).mediaRepository.countries,
      //   selectedCountry: _selectedCountry,
      //   onChanged: _handleCountryChanged,
      // ),
    ],
  );
}
