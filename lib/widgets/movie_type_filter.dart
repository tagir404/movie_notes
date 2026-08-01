import 'package:flutter/material.dart';
import 'package:movie_notes/enums/media_content_type.dart';

class MovieTypeFilter extends StatelessWidget {
  const MovieTypeFilter({
    required this.selectedFilter,
    required this.onChanged,
    super.key,
  });

  final MediaContentType? selectedFilter;
  final ValueChanged<MediaContentType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<MediaContentType>(
      segments: const [
        ButtonSegment(
          value: MediaContentType.movie,
          label: Text('Фильмы', softWrap: false),
        ),
        ButtonSegment(
          value: MediaContentType.tvShow,
          label: Text('Сериалы', softWrap: false),
        ),
      ],
      selected: selectedFilter == null ? {} : {selectedFilter!},
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      onSelectionChanged: (value) {
        onChanged(value.isEmpty ? null : value.first);
      },
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: Theme.of(context).colorScheme.primary,
        selectedForegroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const .symmetric(horizontal: 12, vertical: 8),
        side: .none,
      ),
    );
  }
}
